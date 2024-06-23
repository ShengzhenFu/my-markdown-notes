# Install k3s on Ubuntu 24.04

```bash
sudo curl -sfl https://get.k3s.io | sh -s - server --docker --disable servicelb --disable traefik --write-kubeconfig-mode 644
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

