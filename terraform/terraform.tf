terraform {
  backend "s3" {}
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
    zerotier = {
      source = "zerotier/zerotier"
    }
  }
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
