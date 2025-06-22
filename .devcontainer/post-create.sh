#!/bin/bash
set -euo pipefail

echo "Running post-create setup..."

# Initialize firewall
sudo /usr/local/bin/init-firewall.sh

# Set up environment sourcing
echo 'source /workspace/.env' >> ~/.bashrc
echo 'source /workspace/.env' >> ~/.zshrc

# Add MCP services
claude mcp add firecrawl --scope project --env FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY} -- npx -y firecrawl-mcp
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp

echo "Post-create setup completed!"