# Network Automation & Troubleshooting Lab

A hands-on virtual networking lab built with Containerlab, Docker, and Linux networking tools to strengthen practical networking and troubleshooting skills.

## Objective

I built this lab to move beyond networking theory and observe how Layer 2 and Layer 3 behavior actually works on the wire.

The lab demonstrates:

- VLAN segmentation
- access ports and PVIDs
- 802.1Q trunking
- router-on-a-stick
- inter-VLAN routing
- DHCP
- DNS
- ARP
- ICMP
- packet analysis with tcpdump

## Topology

```text
USER                            CAMERA
VLAN 10                         VLAN 20
192.168.10.x                    192.168.20.x
   |                               |
   | Access VLAN 10                | Access VLAN 20
   |                               |
   +----------- SWITCH ------------+
               Linux br0
                   |
                   | 802.1Q trunk
                   | VLAN 10 + 20
                   |
                 ROUTER
          eth1.10 = 192.168.10.1
          eth1.20 = 192.168.20.1
               DHCP + DNS
## DHCP and DNS

dnsmasq provides DHCP and local DNS.

Clients successfully complete:

Discover -> Offer -> Request -> ACK

Local DNS resolves names such as:

camera.lab -> 192.168.20.140

## Packet Analysis

I used tcpdump on the switch trunk while running:

ping camera.lab

The capture showed:

1. User ARPs for its default gateway.
2. User queries DNS for camera.lab.
3. DNS returns the Camera's IP.
4. User recognizes that the Camera is on another subnet.
5. User sends the frame to the router's MAC while keeping the Camera as the destination IP.
6. Router performs a route lookup.
7. Router ARPs for the Camera in VLAN 20.
8. Router creates a new Layer 2 frame and forwards the packet.
9. Camera sends the ICMP Echo Reply back through its gateway.

A key observation:

Before routing:
VLAN: 10
MAC: User -> Router
IP:  User -> Camera
TTL: 64

After routing:
VLAN: 20
MAC: Router -> Camera
IP:  User -> Camera
TTL: 63

The Layer 2 frame changes at the router, while the source and destination IP addresses remain unchanged because there is no NAT.

## Key Learning

This project helped connect concepts that are often learned separately:

- VLANs create separate Layer 2 broadcast domains.
- ARP resolves a local or next-hop IPv4 address to a MAC address.
- Hosts send remote-subnet traffic to their default gateway.
- Routers connect Layer 3 networks.
- Routing replaces the Layer 2 frame and decrements TTL.
- tcpdump provides evidence of what the network is actually doing.

## Next Steps

- structured failure injection
- Ansible automation
- automated validation
- idempotent network-state restoration
