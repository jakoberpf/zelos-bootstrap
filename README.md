# zelos-bootstrap

This project is the first stage of the zelos kubernetes cluster.

- ***zelos-bootstrap***
- zelos-installer
- zelos-configuration

All resources are part of the oracle free tier (although multiple accounts from my wife and my brother where used). Terraform is used for creating all OCI resources and a bash script will setup a peering connections between the VPCs. Afterwards `kubespray` is used for creating the Kubernetes cluster itself. I am still working on making everything configurable and plugable, but the idea is that this could be a boilerplate or template for a *free* kubernetes cluster in the cloud with actually usable resources. To my knowledge this does not break any `Term of Use` of Oracle since its actually just one account per individual.

## Guide

TODO tooling
TODO bash

### Terraform

TODO Terraform

### Kubespray

TODO Kubespray

## gcr.k8s.io blocked IPs

- 130.61.172.91
