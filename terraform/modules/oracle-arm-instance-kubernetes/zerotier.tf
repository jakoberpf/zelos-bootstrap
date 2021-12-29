resource "zerotier_identity" "oaik_0" {
}

resource "zerotier_member" "oaik_internal_0" {
  name        = "${var.cluster_compartment}-${oci_core_instance.oaik_0.display_name}"
  member_id   = zerotier_identity.oaik_0.id
  network_id  = var.zerotier_network_id_internal
  ip_assignments = [
    var.zerotier_ip_assignment_internal
  ]
}

resource "zerotier_member" "oaik_external_0" {
  name        = "${var.cluster_compartment}-${oci_core_instance.oaik_0.display_name}"
  member_id   = zerotier_identity.oaik_0.id
  network_id  = var.zerotier_network_id_external
  ip_assignments = [
    var.zerotier_ip_assignment_external
  ]
}
