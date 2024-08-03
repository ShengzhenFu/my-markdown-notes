k3d cluster create k3d-cluster-3node \
	--agents 3 \
	--k3s-arg "--disable=traefik@server:*" \
	--k3s-arg "--disable=servicelb@server:*"
