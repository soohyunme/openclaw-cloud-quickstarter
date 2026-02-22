terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "OpenClaw"
      ManagedBy = "Terraform"
      Namespace = var.namespace
    }
  }
}

# 1. VPC & Networking
resource "aws_vpc" "openclaw_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.namespace}-vpc" }
}

resource "aws_internet_gateway" "openclaw_igw" {
  vpc_id = aws_vpc.openclaw_vpc.id
  tags = { Name = "${var.namespace}-igw" }
}

resource "aws_route_table" "openclaw_rt" {
  vpc_id = aws_vpc.openclaw_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openclaw_igw.id
  }
  tags = { Name = "${var.namespace}-rt" }
}

resource "aws_subnet" "openclaw_subnet" {
  vpc_id                  = aws_vpc.openclaw_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = { Name = "${var.namespace}-subnet" }
}

resource "aws_route_table_association" "openclaw_rta" {
  subnet_id      = aws_subnet.openclaw_subnet.id
  route_table_id = aws_route_table.openclaw_rt.id
}

# 2. Security Group (Firewall)
resource "aws_security_group" "openclaw_sg" {
  name        = "${var.namespace}-sg"
  description = "Allow SSH, OpenClaw"
  vpc_id      = aws_vpc.openclaw_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.namespace}-sg" }
}

# 3. AMI (Ubuntu 22.04 LTS)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 4. Key Pair (Upload local key to AWS)
resource "random_id" "key_suffix" {
  byte_length = 2
}

resource "aws_key_pair" "openclaw_auth" {
  key_name   = "${var.namespace}-key-${random_id.key_suffix.hex}"
  public_key = file(var.public_key_path)
}

# 5. EC2 Instance
resource "aws_instance" "openclaw_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.openclaw_auth.key_name

  subnet_id                   = aws_subnet.openclaw_subnet.id
  vpc_security_group_ids      = [aws_security_group.openclaw_sg.id]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/../scripts/bootstrap.sh", {
      CLOUD_PROVIDER   = "aws"
      USER             = "ubuntu"
  }))

  root_block_device {
    volume_size           = var.disk_size_gb
    volume_type           = var.disk_type
    delete_on_termination = true
  }

  tags = {
    Name = "${var.namespace}-server"
  }
}

# 6. Elastic IP (Fixed IP)
resource "aws_eip" "openclaw_eip" {
  instance = aws_instance.openclaw_server.id
  domain   = "vpc"

  tags = {
    Name = "${var.namespace}-eip"
  }
}
