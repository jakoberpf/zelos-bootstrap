## S3 Terraform Backend
# variable "tf_backend_region" {
#   type = string
# }
# variable "tf_backend_access_key" {
#   type = string
# }
# variable "tf_backend_secret_access_key" {
#   type = string
# }
# variable "tf_backend_bucket" {
#   type = string
# }
# variable "tf_backend_kms_key_id" {
#   type = string
# }
# variable "tf_backend_dynamo_table" {
#   type = string
# }

# OracleCloud
variable "instance_shape" {
  type    = string
  default = "VM.Standard.E2.1.Micro"
}
variable "region" {
  type = string
}
variable "authorized_keys" {
  type = string
}

## jakoberpf
variable "jakob_tenancy_ocid" {
  type = string
}
variable "jakob_compartment_ocid" {
  type = string
}
variable "jakob_user_ocid" {
  type = string
}
variable "jakob_fingerprint" {
  type = string
}
variable "jakob_private_key_path" {
  type = string
}
variable "jakob_availability_domains" {
  type    = list(string)
  default = []
}
variable "jakob_vcn_id" {
  type = string
}
variable "jakob_default_dhcp_options_id" {
  type = string
}
variable "jakob_route_table_id" {
  type = string
}

## fabianerpf
variable "fabian_tenancy_ocid" {
  type = string
}
variable "fabian_compartment_ocid" {
  type = string
}
variable "fabian_user_ocid" {
  type = string
}
variable "fabian_fingerprint" {
  type = string
}
variable "fabian_private_key_path" {
  type = string
}
variable "fabian_availability_domains" {
  type    = list(string)
}
variable "fabian_vcn_id" {
  type = string
}
variable "fabian_default_dhcp_options_id" {
  type = string
}
variable "fabian_route_table_id" {
  type = string
}

## tanjaboghdady
variable "tanja_tenancy_ocid" {
  type = string
}
variable "tanja_compartment_ocid" {
  type = string
}
variable "tanja_user_ocid" {
  type = string
}
variable "tanja_fingerprint" {
  type = string
}
variable "tanja_private_key_path" {
  type = string
}
variable "tanja_availability_domains" {
  type    = list(string)
}
variable "tanja_vcn_id" {
  type = string
}
variable "tanja_default_dhcp_options_id" {
  type = string
}
variable "tanja_route_table_id" {
  type = string
}

# Zerotier
variable "zerotier_central_token" {
  type = string
}
