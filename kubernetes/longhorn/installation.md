# Installation Longhorn

## Kubectl

```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.0/deploy/longhorn.yaml
```

## Helm

### Add the Longhorn Helm Repository

```bash
helm repo add longhorn https://charts.longhorn.io
```

### Fetch the latest charts from the repository

```bash
helm repo update
```

### Install Longhorn in the longhorn-system namespace

```bash
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.0
```
