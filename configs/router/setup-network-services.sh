#!/bin/bash
set -e

echo "Configuring DHCP + DNS..."

# Stop previous lab dnsmasq process
pkill dnsmasq 2>/dev/null || true

cat > /tmp/dnsmasq-lab.conf <<'EOF'

# ==========================================
# Interfaces
# ==========================================

interface=eth1.10
interface=eth1.20
bind-interfaces


# ==========================================
# Local DNS
# ==========================================

domain=lab
local=/lab/


# ==========================================
# DHCP
# ==========================================

dhcp-authoritative

# VLAN 10 - Users
dhcp-range=set:vlan10,192.168.10.100,192.168.10.150,255.255.255.0,1h
dhcp-option=tag:vlan10,option:router,192.168.10.1
dhcp-option=tag:vlan10,option:dns-server,192.168.10.1

# VLAN 20 - Camera / IoT
dhcp-range=set:vlan20,192.168.20.100,192.168.20.150,255.255.255.0,1h
dhcp-option=tag:vlan20,option:router,192.168.20.1
dhcp-option=tag:vlan20,option:dns-server,192.168.20.1


# ==========================================
# Logging
# ==========================================

log-dhcp
log-queries

EOF

echo "Testing dnsmasq configuration..."

dnsmasq --test --conf-file=/tmp/dnsmasq-lab.conf

echo "Starting dnsmasq..."

dnsmasq --conf-file=/tmp/dnsmasq-lab.conf

echo
echo "dnsmasq running:"
pgrep -a dnsmasq
