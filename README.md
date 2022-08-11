# zelos-bootstrap

This project is the first stage of the zelos kubernetes cluster.

- [***zelos-bootstrap***](https://github.com/jakoberpf/zelos-bootstrap)
- [zelos-installer](https://github.com/jakoberpf/zelos-installer)
- [zelos-configuration](https://github.com/jakoberpf/zelos-configuration)

All resources are part of the oracle free tier (although multiple accounts from my wife and my brother where used). Terraform is used for creating all OCI resources and a bash script will setup a peering connections between the VPCs. Afterwards `kubespray` is used for creating the Kubernetes cluster itself. I am still working on making everything configurable and plugable, but the idea is that this could be a boilerplate or template for a *free* kubernetes cluster in the cloud with actually usable resources. To my knowledge this does not break any `Term of Use` of Oracle since its actually just one account per individual, as long it is not used for production purposes.

## Guide

This project is almost completely automated (but not yet completely configurable) with some `bash` scripts in `bin/` and can be executed with the commands from the `Makefile`. These commands mainly include ...

- tooling: Will setup all required tools like ansible, terraform, terraform, ...
- vault: Will pull all required secrets from the defined vault instance. ***TODO*** Make this optional, as local secrets could be provided
- terraform: ***TODO***
  - force: ***TODO***
  - post: ***TODO***s
- kubespray: ***TODO***

Additionally there is a `deploy` and `destroy` command, which will run the complete process of bootstrapping and destroying the cluster. Be aware that you ***cannot*** recover from the `destroy` command.

### Terraform

***TODO*** Terraform

### Kubespray

***TODO*** Kubespray

**Development-Notes**

- OCI Kubernetes Configuration Guide [oracle.github.io](https://oracle.github.io/cluster-api-provider-oci/networking/calico.html)
- OCI Networking does not allow IP-in-IP or IPIP (93) protocol in local peering which is why we are using calicos XVLAN implementation [stackoverflow.com](https://stackoverflow.com/questions/53247682/kubernetes-calico-on-oracle-cloud-vms)
- Calico <https://projectcalico.docs.tigera.io/getting-started/kubernetes/requirements>
- TODO Rolling Upgrade with <https://gmusumeci.medium.com/how-to-get-the-latest-os-image-in-oracle-cloud-infrastructure-using-terraform-f53823223968>
