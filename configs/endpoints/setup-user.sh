#!/bin/bash
set -e

ip addr flush dev eth1
ip addr add 192.168.10.10/24 dev eth1
ip link set eth1 up

echo "User eth1:"
ip addr show eth1
