#!/usr/bin/env bash

set -eo pipefail

# https://platform.cloudogu.com/en/blog/velero-longhorn-backup-restore/
# https://picluster.ricsanfre.com/docs/backup/

# helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm upgrade --install velero --version 5.1.2 \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    -f values.yml \
    vmware-tanzu/velero

# https://tanzu.vmware.com/developer/guides/velero-gs/

# velero backup create vaultwarden-zelos --include-namespaces vaultwarden --wait
