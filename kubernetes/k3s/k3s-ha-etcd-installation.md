# Installtion k3s HA Cluster with etcd

## First k3s master node

```bash
curl -sfL https://get.k3s.io | K3S_TOKEN=WbdCc43q2gXA88 sh -s - server \
   --write-kubeconfig-mode 644 \
   --disable=traefik \
   --disable=servicelb \
   --disable-cloud-controller \
   --disable=local-storage \
   --tls-san=10.10.10.30 \
   --cluster-init
```

## Further k3s master nodes

```bash
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server \
    --server https://<IP of First Host>:6443 \
    --write-kubeconfig-mode 644 \
    --disable=traefik \
    --disable=servicelb \
    --disable-cloud-controller \
    --disable local-storage \
    --tls-san=<IP or Hostname for Cluster>
```

## Further k3s master nodes without Pod Deployment

```bash
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server \
    --server https://<IP of First Host>:6443 \
    --write-kubeconfig-mode 644 \
    --disable=traefik \
    --disable=servicelb \
    --node-taint CriticalAddonsOnly=true:NoExecute \
    --disable-cloud-controller \
    --disable local-storage \
    --tls-san=<IP or Hostname for Cluster>
```
