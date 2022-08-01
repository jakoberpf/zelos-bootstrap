# zelos-bootstrap

This project is the first stage of the zelos kubernetes cluster.

- ***zelos-bootstrap***
- zelos-installer
- zelos-configuration

All resources are part of the oracle free tier (although multiple accounts from my wife and my brother where used). Terraform is used for creating all OCI resources and a bash script will setup a peering connections between the VPCs. Afterwards `kubespray` is used for creating the Kubernetes cluster itself. I am still working on making everything configurable and plugable, but the idea is that this could be a boilerplate or template for a *free* kubernetes cluster in the cloud with actually usable resources. To my knowledge this does not break any `Term of Use` of Oracle since its actually just one account per individual, as long it is not used for production purposes.

## Guide

TODO tooling
TODO bash

### Terraform

TODO Terraform

### Kubespray

**Notes**

- OCI Kubernetes Configuration Guide [oracle.github.io](https://oracle.github.io/cluster-api-provider-oci/networking/calico.html)
- OCI Networking does not allow IP-in-IP or IPIP (93) protocol in local peering which is why we are using calicos XVLAN implementation [stackoverflow.com](https://stackoverflow.com/questions/53247682/kubernetes-calico-on-oracle-cloud-vms)
- Calico https://projectcalico.docs.tigera.io/getting-started/kubernetes/requirements
- TODO Rolling Upgrade with https://gmusumeci.medium.com/how-to-get-the-latest-os-image-in-oracle-cloud-infrastructure-using-terraform-f53823223968