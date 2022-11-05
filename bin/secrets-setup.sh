#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Setup SSH credentials
mkdir -p .ssh
echo -e $(yq e -o=j -I=0 '.ssh.private_key' terraform/terragrunt.yaml | tr -d '"') > .ssh/automation
chmod 600 .ssh/automation

# Setup OCI credentials
mkdir -p .oci
mkdir -p .oci/keys
rm -f .oci/config
touch .oci/config
oci_count=$(yq e -o=j -I=0 '.oci | length' terraform/terragrunt.yaml)
for (( c=0; c<${oci_count}; c++ ))
do 
   oci_credentials=$(yq e -o=j -I=0 ".oci[${c}]" terraform/terragrunt.yaml)
   oci_id=$(echo "${oci_credentials}" | yq '.id')
   oci_user=$(echo "${oci_credentials}" | yq '.user_ocid')
   oci_fingerprint=$(echo "${oci_credentials}" | yq '.fingerprint')
   oci_tenancy=$(echo "${oci_credentials}" | yq '.tenancy_ocid')
   oci_region=$(echo "${oci_credentials}" | yq '.region')
   printf "[${oci_id^^}]\nuser=${oci_user}\nfingerprint=${oci_fingerprint}\ntenancy=${oci_tenancy}\nregion=${oci_region}\nkey_file=${PWD}/.oci/keys/${oci_id}.pem\n\n" >> .oci/config
   echo -e $(echo "${oci_credentials}" | yq '.private_key') > .oci/keys/${oci_id}.pem
   oci setup repair-file-permissions --file .oci/config
   oci setup repair-file-permissions --file .oci/keys/${oci_id}.pem
done
