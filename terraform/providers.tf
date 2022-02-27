terraform {
  backend "s3" {}
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

provider "oci" {
  alias            = "ulrike"
  tenancy_ocid     = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].tenancy_ocid
  user_ocid        = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].user_ocid
  fingerprint      = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].fingerprint
  private_key_path = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].private_key_path
  region           = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].region
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
