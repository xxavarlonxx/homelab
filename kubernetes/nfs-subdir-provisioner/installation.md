# Installation nfs-subdir-external-provisioner

## Helm

First add the Helm Repo

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/
```

Then you can install the nfs-subdir-external-provisioner

```bash
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=xx.xx.xx \
    --set nfs.path=/mnt/example \
    --set storageClass.name=nfs-xxx \
    --set storageClass.provisionerName=k8s-sigs.io/nfs-xxxx-provisioner
```

All posible Configparameters can be find (here)[https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/blob/master/charts/nfs-subdir-external-provisioner/README.md]
