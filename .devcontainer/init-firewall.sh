#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

# Flush existing rules and delete existing ipsets
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
ipset destroy blocked-ips 2>/dev/null || true

# Allow localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Get host IP from default route and allow host network
HOST_IP=$(ip route | grep default | cut -d" " -f3)
if [ -z "$HOST_IP" ]; then
    echo "ERROR: Failed to detect host IP"
    exit 1
fi

HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")
echo "Host network detected as: $HOST_NETWORK"
iptables -A INPUT -s "$HOST_NETWORK" -j ACCEPT
iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

# Create blocklist ipset
ipset create blocked-ips hash:net

# Add known malicious IP ranges to blocklist (minimal for development)
# Note: These are example ranges - adjust based on security requirements
echo "Adding blocked IP ranges..."
# Block some known bad actor ranges (examples - customize as needed)
# ipset add blocked-ips "10.0.0.0/8"     # Private networks if needed
# ipset add blocked-ips "192.168.0.0/16" # Private networks if needed

# Set permissive default policies
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP  # Keep forward restricted
iptables -P OUTPUT ACCEPT

# Block traffic to/from blocklist
iptables -I INPUT 1 -m set --match-set blocked-ips src -j DROP
iptables -I OUTPUT 1 -m set --match-set blocked-ips dst -j DROP

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
