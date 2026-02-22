terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# 1. VCN & Subnet
resource "oci_core_vcn" "openclaw_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "${var.namespace}-vcn"
}

resource "oci_core_internet_gateway" "openclaw_ig" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.openclaw_vcn.id
  display_name   = "${var.namespace}-ig"
}

resource "oci_core_route_table" "openclaw_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.openclaw_vcn.id
  display_name   = "${var.namespace}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.openclaw_ig.id
  }
}

resource "oci_core_subnet" "openclaw_subnet" {
  cidr_block        = "10.0.1.0/24"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.openclaw_vcn.id
  display_name      = "${var.namespace}-subnet"
  route_table_id    = oci_core_route_table.openclaw_rt.id
  security_list_ids = [oci_core_security_list.openclaw_sl.id]
}

# 2. Security List (Firewall)
resource "oci_core_security_list" "openclaw_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.openclaw_vcn.id
  display_name   = "${var.namespace}-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = var.allowed_ssh_cidr
    tcp_options {
      min = 22
      max = 22
    }
  }

}

# 3. Compute Instance
resource "oci_core_instance" "openclaw_server" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain_number - 1].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.namespace}-server"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.openclaw_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_images.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(templatefile("${path.module}/../scripts/bootstrap.sh", {
      CLOUD_PROVIDER   = "oracle"
      OPENCLAW_MODEL   = var.openclaw_model
      LLM_API_KEY      = var.llm_api_key
      USER             = var.ssh_user
    }))
  }

  freeform_tags = {
    Project   = "OpenClaw"
    ManagedBy = "Terraform"
    Namespace = var.namespace
  }
}

# Data Sources
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
