terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
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