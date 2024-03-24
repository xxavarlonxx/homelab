# Installation Kubernetes SMB

## Install CSI Driver

```bash
curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/v1.14.0/deploy/install-driver.sh | bash -s v1.14.0 --
```

## Create SMB credentials

```bash
kubectl create secret generic smbcreds --from-literal username=USERNAME --from-literal password="PASSWORD"
```
