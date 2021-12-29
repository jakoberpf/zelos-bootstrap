terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
    zerotier = {
      source = "zerotier/zerotier"
      version = "1.2.0"
    }
  }
}

resource "random_string" "deployment_id" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}