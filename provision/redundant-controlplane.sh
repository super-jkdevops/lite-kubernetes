#!/bin/bash
set -eux

channel="$1"; shift
version="$1"; shift
token="$1"; shift
ip_address="$1"; shift
kube_config="$1"; shift
first_control_plane_ip="$1"; shift # Only for orher control plane needs (ensure redundancy)
fqdn="$(hostname --fqdn)"

# configure the motd.
cat >/etc/motd <<'EOF' 
  _    ____         _____            _             _   _____  _                  
 | |  |___ \       / ____|          | |           | | |  __ \| |                 
 | | __ __) |___  | |     ___  _ __ | |_ _ __ ___ | | | |__) | | __ _ _ __   ___ 
 | |/ /|__ </ __| | |    / _ \| '_ \| __| '__/ _ \| | |  ___/| |/ _` | '_ \ / _ \
 |   < ___) \__ \ | |___| (_) | | | | |_| | | (_) | | | |    | | (_| | | | |  __/
 |_|\_\____/|___/  \_____\___/|_| |_|\__|_|  \___/|_| |_|    |_|\__,_|_| |_|\___|
 _____
 REST
                                                                                 
EOF

# install k3s.
curl -sfL curl -sfL https://get.k3s.io \
    | INSTALL_K3S_CHANNEL="$channel" \
      INSTALL_K3S_VERSION="$version" \
      K3S_TOKEN="$token" \
      K3S_KUBECONFIG_OUTPUT="$kube_config" \
      K3S_URL="https://$first_control_plane_ip:6443" \
      sh -s -- \
          server \
          --cluster-init \
          --no-deploy traefik \
          --node-ip "$ip_address" \
          --flannel-backend 'none' \
          --disable-network-policy \
          --cluster-cidr '10.244.0.0/16'

# see the systemd unit for k3s
systemctl cat k3s

# see status k3s service
systemctl status k3s

# wait for this node to be Ready.
$SHELL -c 'node_name=$(hostname); echo "waiting for node $node_name to be ready..."; while [ -z "$(kubectl get nodes $node_name | grep -E "$node_name\s+Ready\s+")" ]; do sleep 3; done; echo "node ready!"'

# wait for the kube-dns pod to be Running.
$SHELL -c 'while [ -z "$(kubectl get pods --selector k8s-app=kube-dns --namespace kube-system | grep -E "\s+Running\s+")" ]; do sleep 3; done'

# symlink the default kubeconfig path so local tools like k9s can easily
ln -s /etc/rancher/k3s/k3s.yaml ~/.kube/config

# show cluster-info.
kubectl cluster-info

# list nodes.
kubectl get nodes -o wide

# show versions.
kubectl version
crictl version
k3s ctr version
