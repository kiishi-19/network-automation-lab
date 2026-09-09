#!/bin/bash
set -e

echo "Configuring DHCP server..."

# Stop an old lab dnsmasq instance if this script is reapplied.
pkill dnsmasq 2>/dev/null || true

cat > /tmp/dnsmasq-lab.conf <<'EOF'

# Only serve our two lab VLAN interfaces.
interface=eth1.10
interface=eth1.20
bind-interfaces

# This is the authoritative DHCP server for these lab networks.
dhcp-authoritative

# VLAN 10 - Users
dhcp-range=set:vlan10,192.168.10.100,192.168.10.150,255.255.255.0,1h
dhcp-option=tag:vlan10,option:router,192.168.10.1
dhcp-option=tag:vlan10,option:dns-server,192.168.10.1

# VLAN 20 - Cameras / IoT
dhcp-range=set:vlan20,192.168.20.100,192.168.20.150,255.255.255.0,1h
dhcp-option=tag:vlan20,option:router,192.168.20.1
dhcp-option=tag:vlan20,option:dns-server,192.168.20.1

# Helpful while learning
log-dhcp

EOF

echo "Checking configuration..."
dnsmasq --test --conf-file=/tmp/dnsmasq-lab.conf

echo "Starting dnsmasq..."
dnsmasq --conf-file=/tmp/dnsmasq-lab.conf

echo
echo "DHCP server running:"
pgrep -a dnsmasq
