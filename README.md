# zelos-bootstrap

This project is the first stage of the zelos kubernetes cluster.

- ***zelos-bootstrap***
- zelos-installer
- zelos-configuration

All ressources are part of the oracle free tier (although mutiple accounts from my wife and my brother where used). Terraform is used for creating all resources and kubespray for creating the cluster itself. I am still working on makeing everything configurably and plugable, but the idea is that this could be a boilerplate or template for a *free* kubernetes cluster in the cloud with actually usabel ressources. To my knowledge this does not break any TOU of Oracle since its actually just one account per individual.

## Ressouces

<https://www.reddit.com/r/Terraform/comments/isvudj/terragrunt_how_do_you_deal_with_multiple_providers/>
