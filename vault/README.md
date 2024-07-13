# Vault injection to K8s Pod in WSL2 Ubuntu 24.04

## Generate TLS cert and ca

```shell
cd tls

docker run -it --rm -v ${PWD}:/work -w /work debian bash

apt-get update && apt-get install -y curl &&
curl -kL https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64 -o /usr/local/bin/cfssl && \
curl -kL https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64 -o /usr/local/bin/cfssljson && \
chmod +x /usr/local/bin/cfssl && \
chmod +x /usr/local/bin/cfssljson

#generate ca in /tmp
cfssl gencert -initca ca-csr.json | cfssljson -bare /tmp/ca

#generate certificate in /tmp
cfssl gencert \
  -ca=/tmp/ca.pem \
  -ca-key=/tmp/ca-key.pem \
  -config=ca-config.json \
  -hostname="vault,vault.vault.svc.cluster.local,vault.vault.svc,localhost,127.0.0.1" \
  -profile=default \
  ca-csr.json | cfssljson -bare /tmp/vault

ls -l /tmp
mv /tmp/* .
exit
```

## Create TLS secret

```shell
sudo chown shengzhen:shengzhen ca*
sudo chown shengzhen:shengzhen vault*
chmod go-r ~/.kube/config
kubectl create ns vault
kubectl -n vault create secret tls tls-ca --cert ./ca.pem --key ./ca-key.pem
kubectl -n vault create secret tls tls-server --cert ./vault.pem --key ./vault-key.pem
```

## helm installation

```shell
sudo snap install helm --classic
```

## Consul installation

```shell
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/consul --versions
helm install consul hashicorp/consul --version 1.5.0 -n vault --values consul-values.yaml
```

## Vault installation

```shell
helm search repo hashicorp/vault --versions
helm install vault hashicorp/vault --version 0.28.1 -n vault --values vault-values.yaml
# works in kind
kubectl -n vault port-forward svc/vault-ui 8443:8200 &
# works in k3s
# kubectl expose svc vault-ui -n vault --type=NodePort --target-port=8200 --name=vault-ui-svc-nodeport

kubectl -n vault exec -it vault-0 -- sh
vault operator init
Unseal Key 1: 8ayi36wreA+AEd1udaoN1512U77MI7KVhPsb1TtZsX0n
Unseal Key 2: C9PO8Tb8tCTzU3psH9256N4p096+DEBBClxoS3guoJyI
Unseal Key 3: UBIyqTsXcl23LbKMweWPb9kCDhSqT8nkQd31AjeRIqwW
Unseal Key 4: A0PSr22VnxUnLlCaxjjk4neZN3fHyWrGGm66JN7b2xOp
Unseal Key 5: 7l2Ods+2InhnEEGURQvB+od95B+IS+ZW46YH+zyPxvz4
Initial Root Token: s.lRhNykpPVZgTxt933wlCUVAO

vault operator unseal
vault status
kubectl -n vault exec -it vault-0 -- vault status

```

## create secret in vault

```shell
vault login
vault auth enable kubernetes

vault write auth/kubernetes/config \
token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
issuer="https://kubernetes.default.svc.cluster.local"

cat <<EOF > /home/vault/app-policy.hcl
path "secret/basic-secret/*" {
  capabilities = ["read"]
}
EOF
vault policy write basic-secret-policy /home/vault/app-policy.hcl
vault secrets enable -path=secret/ kv
vault kv put secret/basic-secret/helloworld username=dbuser password=dbpassword2024
```

## vault injection example app

```shell
kubectl -n vault exec -it vault-0 -- sh
vault write auth/kubernetes/role/basic-secret-role \
   bound_service_account_names=basic-secret \
   bound_service_account_namespaces=example-app \
   policies=basic-secret-policy \
   ttl=1h

kubectl create ns example-app
kubectl -n example-app apply -f example-app/deployment.yaml
kubectl -n example-app exec -it $(kubectl -n example-app get po -o jsonpath='{.items[0].metadata.name}') -- sh -c "cat /vault/secrets/helloworld"
```

## K9s installation

```shell
sudo snap install k9s
sudo ln -s /snap/k9s/current/bin/k9s /snap/bin/
```

##
