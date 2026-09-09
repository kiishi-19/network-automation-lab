#!/bin/bash
set -e

ip addr flush dev eth1
ip addr add 192.168.20.10/24 dev eth1
ip link set eth1 up

echo "Camera eth1:"
ip addr show eth1

