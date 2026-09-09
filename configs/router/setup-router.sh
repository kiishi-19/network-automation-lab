#!/bin/bash
set -e

echo "Configuring router-on-a-stick..."

# Remove old VLAN interfaces if this script is re-run
ip link del eth1.10 2>/dev/null || true
ip link del eth1.20 2>/dev/null || true

# Make sure physical trunk interface is up
ip link set eth1 up

# Create VLAN subinterfaces
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20

# Assign gateway addresses
ip addr add 192.168.10.1/24 dev eth1.10
ip addr add 192.168.20.1/24 dev eth1.20

# Bring interfaces up
ip link set eth1.10 up
ip link set eth1.20 up

# Allow Linux to route packets between interfaces
sysctl -w net.ipv4.ip_forward=1

echo
echo "Router interfaces:"
ip -br addr show eth1
ip -br addr show eth1.10
ip -br addr show eth1.20

echo
echo "Routing table:"
ip route
