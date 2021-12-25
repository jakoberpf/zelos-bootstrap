resource "oci_core_instance" "oaik_0" {
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "${var.clustername}-node"
  shape               = var.instance_shape

  shape_config {
    memory_in_gbs = var.instance_memory
    ocpus         = var.instance_ocpus
  }

  source_details {
    source_id               = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa6ueulrtedgclrxznl5pkzhzseddl7b6iq6jhdl3vjm62zhddpxta"
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.oaik.id
    assign_public_ip = true
    hostname_label   = "${var.clustername}-node"
    nsg_ids = [
      oci_core_network_security_group.oaik_kube.id,
      oci_core_network_security_group.oaik_etcd.id,
    ]
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    user_data = base64encode(templatefile("${path.module}/templates/node.yaml.tpl",
      {
        zerotier_network_id  = "",
    }
    ))
  }
}


