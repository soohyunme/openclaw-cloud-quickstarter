# 🚨 Project Safety Rules

These rules are absolute and must be followed by any Agent or automation system interacting with this repository.

## 1. No Automated Deployment
- **NEVER** execute `terraform apply` or `terraform destroy` automatically.
- **NEVER** execute `git push` to any branch.
- **NEVER** use `aws` CLI commands that create, modify, or delete resources without explicit user approval.

## 2. Safe Infrastructure Verification
- Use `terraform plan` to preview changes.
- Use `terraform validate` to check configuration syntax.
- Use `terraform init` only to download providers/modules.
- All "Safe mode" operations must be non-destructive and read-only.

## 3. Secret Management
- **NEVER** commit `terraform.tfstate`, `*.tfvars`, or any files containing API keys or credentials.
- Ensure `.gitignore` is strictly enforced.

## 4. Confirmation Workflow
- The user must manually review and execute any command that results in infrastructure changes or code pushes.
