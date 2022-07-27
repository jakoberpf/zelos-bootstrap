terraform {
  backend "s3" {}
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
