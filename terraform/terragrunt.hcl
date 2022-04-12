locals {
  vars = jsondecode(file("terragrunt.json"))
  oci_credentials = local.vars.oci_credentials
}

terraform {
    extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = ["${get_parent_terragrunt_dir()}/terraform.tfvars"]
  }
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for key, content in local.oci_credentials}
provider "oci" {
  alias            = "${content.id}"
  tenancy_ocid     = "${content.tenancy_ocid}"
  user_ocid        = "${content.user_ocid}"
  fingerprint      = "${content.fingerprint}"
  private_key_path = "${content.private_key_path}"
  region           = "${content.region}"
}%{endfor}

EOF
}

inputs = {}