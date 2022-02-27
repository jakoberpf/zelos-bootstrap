module "oracle_vcn_ulrike" {
  source = "../../terraform/modules/oracle/base-vpc"

  providers = {
    oci = oci.ulrike
  }

  name                 = "zelos"
  compartment_id       = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].compartment_ocid
  availability_domains = var.oci_credentials[index(var.oci_credentials.*.id, "ulrike")].availability_domains
}
