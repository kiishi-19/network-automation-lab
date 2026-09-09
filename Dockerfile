FROM debian:12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        iproute2 \
        iputils-ping \
        traceroute \
        tcpdump \
        dnsutils \
        dnsmasq \
        isc-dhcp-client \
        curl \
        procps \
        iptables \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
