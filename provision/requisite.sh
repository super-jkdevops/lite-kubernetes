#!/bin/bash
set -eux

# update the package cache.
apt-get update

# Install necessary system packages
while read -r package ; do apt-get install -y $package ; done < <(cat << "EOF"
    curl
    jq
EOF
)