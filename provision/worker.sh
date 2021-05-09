#!/bin/bash
set -eux

channel="$1"; shift
version="$1"; shift
token="$1"; shift
ip_address="$1"; shift
first_control_plane_ip="$1"; shift

# configure the motd.
# NB this was generated at http://patorjk.com/software/taag/#p=display&f=Big&t=k3s%0Aagent.
#    it could also be generated with figlet.org.
cat >/etc/motd <<'EOF'
  _    ____       __          __        _               _   _           _      
 | |  |___ \      \ \        / /       | |             | \ | |         | |     
 | | __ __) |___   \ \  /\  / /__  _ __| | _____ _ __  |  \| | ___   __| | ___ 
 | |/ /|__ </ __|   \ \/  \/ / _ \| '__| |/ / _ \ '__| | . ` |/ _ \ / _` |/ _ \
 |   < ___) \__ \    \  /\  / (_) | |  |   <  __/ |    | |\  | (_) | (_| |  __/
 |_|\_\____/|___/     \/  \/ \___/|_|  |_|\_\___|_|    |_| \_|\___/ \__,_|\___|

EOF

# install k3s.
curl -sfL curl -sfL https://get.k3s.io \
    | INSTALL_K3S_CHANNEL="$channel" \
      INSTALL_K3S_VERSION="$version" \
      K3S_TOKEN="$token" \
      K3S_URL="https://$first_control_plane_ip:6443" \
      sh -s -- \
        agent \
        --node-ip "$ip_address" 
        #--flannel-iface 'eth1' 

# see the systemd unit.
systemctl cat k3s-agent
