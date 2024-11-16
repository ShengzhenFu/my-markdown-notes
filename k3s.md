## Install k3s on Ubuntu 24.04

```bash
sudo curl -sfl https://get.k3s.io | sh -s - server --docker --disable servicelb --disable traefik --write-kubeconfig-mode 644
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## uninstall k3s

```bash
/usr/local/bin/k3s-killall.sh
/usr/local/bin/k3s-uninstall.sh

# fix group/world readable warning
chmod go-r /etc/rancher/k3s/k3s.yaml
```
