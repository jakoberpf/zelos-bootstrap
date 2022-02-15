terraform {
  backend "s3" {
    bucket         = "hashicorp-terraform-backend"
    key            = "jakoberpf/zelos-bootstrap/live/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    kms_key_id     = "f066dc61-8dbe-4bbb-b4fe-1171fa476a4c"
    dynamodb_table = "tf-remote-state-lock"
  }
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.58.0"
      configuration_aliases = [
        oci.jakob,
        oci.fabian,
        oci.tanja
      ]
    }
    zerotier = {
      source  = "zerotier/zerotier"
      version = "1.2.0"
    }
  }
}

provider "oci" {
  alias            = "jakob"
  tenancy_ocid     = var.jakob_tenancy_ocid
  user_ocid        = var.jakob_user_ocid
  fingerprint      = var.jakob_fingerprint
  private_key_path = var.jakob_private_key_path
  region           = var.region
}

provider "oci" {
  alias            = "fabian"
  tenancy_ocid     = var.fabian_tenancy_ocid
  user_ocid        = var.fabian_user_ocid
  fingerprint      = var.fabian_fingerprint
  private_key_path = var.fabian_private_key_path
  region           = var.region
}

provider "oci" {
  alias            = "tanja"
  tenancy_ocid     = var.tanja_tenancy_ocid
  user_ocid        = var.tanja_user_ocid
  fingerprint      = var.tanja_fingerprint
  private_key_path = var.tanja_private_key_path
  region           = var.region
}

# provider "oci" {
#   alias            = "tobias"
#   tenancy_ocid     = var.tanja_tenancy_ocid
#   user_ocid        = var.tanja_user_ocid
#   fingerprint      = var.tanja_fingerprint
#   private_key_path = var.tanja_private_key_path
#   region           = var.region
# }

# provider "oci" {
#   alias            = "paulina"
#   tenancy_ocid     = var.tanja_tenancy_ocid
#   user_ocid        = var.tanja_user_ocid
#   fingerprint      = var.tanja_fingerprint
#   private_key_path = var.tanja_private_key_path
#   region           = var.region
# }

# provider "oci" {
#   alias            = "ulrike"
#   tenancy_ocid     = var.tanja_tenancy_ocid
#   user_ocid        = var.tanja_user_ocid
#   fingerprint      = var.tanja_fingerprint
#   private_key_path = var.tanja_private_key_path
#   region           = var.region
# }

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
