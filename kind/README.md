# Install Kind on WSL Ubuntu 22.04

```shell
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

kind create cluster --name a-kind-cluster --image kindest/node:v1.30.2 --config kind.yaml

kind get clusters

kubectl cluster-info --context kind-a-kind-cluster

kind delete cluster --name a-kind-cluster

# Load image to Cluster
kind load docker-image my-custom-image-0 my-custom-image-1 --name a-kind-cluster

# Ingress Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

```
