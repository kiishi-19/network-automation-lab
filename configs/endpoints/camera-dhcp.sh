#!/bin/bash
set -e

echo "Removing old static configuration..."

pkill dhclient 2>/dev/null || true

ip addr flush dev eth1
ip route flush dev eth1 2>/dev/null || true

rm -f /var/lib/dhcp/dhclient*.leases 2>/dev/null || true

ip link set eth1 up

echo "Creating DHCP client configuration..."

cat > /tmp/dhclient-camera.conf <<'EOF'
send host-name "camera";
EOF

echo "Requesting DHCP lease..."

dhclient -v \
  -cf /tmp/dhclient-camera.conf \
  eth1

echo
echo "New interface configuration:"
ip addr show eth1

echo
echo "Routing table:"
ip route
