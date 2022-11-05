# zelos-bootstrap

This project is the first stage of the zelos kubernetes cluster deployment.

- [***zelos-bootstrap***](https://github.com/jakoberpf/zelos-bootstrap)
- [zelos-installer](https://github.com/jakoberpf/zelos-installer)
- [zelos-configuration](https://github.com/jakoberpf/zelos-configuration)

All resources are part of the oracle free tier (although multiple accounts from my wife and my brother where used). Terraform is used for creating all OCI resources and a bash script will setup a peering connections between the VPCs. Afterwards `kubespray` is used for creating the Kubernetes cluster itself. I am still working on making everything configurable and plug-able, but the idea is that this could be a boilerplate or template for a *free* kubernetes cluster in the cloud with actually usable resources. To my knowledge this does not break any `Term of Use` of Oracle since its actually just one account per individual, as long it is not used for production purposes.

## Guide

This project is almost completely automated (but ***not yes*** completely configurable) with some `bash` scripts in `bin/` and can be managed with the commands from the `Makefile`. These commands can be run by executing

```bash
make <command>
```

and mainly include:

- `tooling`: Will setup all required tools like ansible, terraform and terragrunt.
- `terraform`: Will generate terraform code with terragrunt and apply the generated definitions.
  - `init`: Will initialize the terraform code.
  - `validate`:  Will validate the terraform code.
  - `apply`: Will apply the terraform code.
  - `force`: Does basically the same as `make terraform.apply`, but will run a force apply instead and this until all resources where created successfully. Is is done to conquer a common `OCI Ampere Instance` issue where when creating instances the apply will fail frequently because the free tier available instances are limited and an error `Out of Host capacity` will occur. So this is simple brute forcing.
  - `post`: As the `terraform.apply` process with generate some script which need to be applied after the resource creations, but are still part of the infrastructure, the `terraform.post` step will run all these generated scripts.
- `kubespray`: Will run the kubespray cluster deployment playbook.

Additionally there is a `deploy` and `destroy` command, which will run the complete process of bootstrapping and destroying the cluster. Be aware that you ***cannot*** recover from the `destroy` command.

### Terraform

***TODO*** Terraform

### Kubespray

***TODO*** Kubespray

Please refer to the documentation of kubespray for detailed information.

### Pipelines

***TODO*** Github / Gitlab Pipelines

Currently my deployment is managed with a mix of local commands an github terraform pipelines. This needs to be refined before publishing.

**Development-Notes**

- OCI Kubernetes Configuration Guide [oracle.github.io](https://oracle.github.io/cluster-api-provider-oci/networking/calico.html)
- OCI Networking does not allow IP-in-IP or IPIP (93) protocol in local peering which is why we are using calicos XVLAN implementation [stackoverflow.com](https://stackoverflow.com/questions/53247682/kubernetes-calico-on-oracle-cloud-vms)
- Calico <https://projectcalico.docs.tigera.io/getting-started/kubernetes/requirements>
- TODO Rolling Upgrade with <https://gmusumeci.medium.com/how-to-get-the-latest-os-image-in-oracle-cloud-infrastructure-using-terraform-f53823223968>
- TODO https://github.com/aws-actions/configure-aws-credentials#assuming-a-role
- TODO https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
