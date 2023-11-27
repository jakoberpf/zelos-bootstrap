kc apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.2.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kc apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.2.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kc apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v6.2.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
