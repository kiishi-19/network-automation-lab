#!/bin/bash
set -e

echo "Creating VLAN-aware bridge..."

# Remove old bridge if this script is being reapplied
ip link del br0 2>/dev/null || true

# Create our virtual Layer 2 switch
ip link add br0 type bridge vlan_filtering 1
ip link set br0 up

# Attach physical lab interfaces to the bridge
ip link set eth1 master br0
ip link set eth2 master br0
ip link set eth3 master br0

ip link set eth1 up
ip link set eth2 up
ip link set eth3 up

# Remove default VLAN 1 from the ports
bridge vlan del dev eth1 vid 1 2>/dev/null || true
bridge vlan del dev eth2 vid 1 2>/dev/null || true
bridge vlan del dev eth3 vid 1 2>/dev/null || true

# USER PORT
# Untagged traffic entering eth1 belongs to VLAN 10
bridge vlan add dev eth1 vid 10 pvid untagged

# CAMERA PORT
# Untagged traffic entering eth2 belongs to VLAN 20
bridge vlan add dev eth2 vid 20 pvid untagged

# TRUNK
# eth3 carries both VLANs using 802.1Q tags
bridge vlan add dev eth3 vid 10
bridge vlan add dev eth3 vid 20

echo
echo "VLAN configuration:"
bridge vlan show
