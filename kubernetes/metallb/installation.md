# Installation MetalLb

## Kubectl

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml
```

```yaml
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: metallb-config
  namespace: metallb-system
spec:
  addresses:
    - xx.xx.xx.xx-xx.xx.xx.xx
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: metallb-advertisement
  namespace: metallb-system
```
