k3d cluster create my-cluster \
    --k3s-arg "--advertise-address=192.168.35.60@server:0" \
    --k3s-arg "--node-ip=192.168.35.60@all" \
    --api-port 192.168.35.60:6443 \
    --k3s-arg "--disable=traefik@server:*" \
    --port 6443:6443@loadbalancer  \
    --k3s-arg "--disable=flannel@server:*" \
    --k3s-arg "--flannel-backend=none@server:*" \
    --k3s-arg "--cluster-cidr=10.244.0.0/16@server:*" \
    --volume /Users/user/Documents/k3s/cni-bin:/opt/cni/bin@server:0 \