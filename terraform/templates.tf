resource "local_file" "kubespray_inventory" {
  depends_on = [
    module.oracle_instance_jakob.public_ip,
    module.oracle_instance_fabian.public_ip,
    module.oracle_instance_tanja.public_ip
  ]
  content = templatefile("${path.module}/templates/inventory.tpl",
  {
    masters-ip-public = [
        module.oracle_instance_jakob.public_ip,
        module.oracle_instance_fabian.public_ip,
        module.oracle_instance_tanja.public_ip
    ]
    masters-ip-zt-internal = [
        module.oracle_instance_jakob.zt_internal_ip,
        module.oracle_instance_fabian.zt_internal_ip,
        module.oracle_instance_tanja.zt_internal_ip
    ]
    masters-ip-zt-external = [
        module.oracle_instance_jakob.zt_external_ip,
        module.oracle_instance_fabian.zt_external_ip,
        module.oracle_instance_tanja.zt_external_ip
    ]
    masters-id = [
        "master-jakob",
        "master-fabian",
        "master-tanja"
    ],
    masters-user = "ubuntu",
    workers-ip = []
    workers-id = [],
    workers-user = "ubuntu",
    bastion-ip = ""
    bastion-id = "",
    bastion-user = "ubuntu",
  }
 )
 filename = "${path.root}/../kubespray/inventory/zelos/inventory.ini"
}

resource "local_file" "ssh_config" {
  depends_on = [
    module.oracle_instance_jakob.public_ip,
    module.oracle_instance_fabian.public_ip,
    module.oracle_instance_tanja.public_ip
  ]
  content = templatefile("${path.module}/templates/config.tpl",
  {
    node-ip = [
        module.oracle_instance_jakob.public_ip,
        module.oracle_instance_fabian.public_ip,
        module.oracle_instance_tanja.public_ip
    ]
    node-id = [
        "zelos-jakob",
        "zelos-fabian",
        "zelos-tanja"
    ],
    node-user = "ubuntu",
    node-key = "${abspath(path.root)}/../.ssh/automation.openssh.pem"
  }
 )
 filename = "${path.root}/../.ssh/config"
}