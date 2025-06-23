#!/bin/bash
set -euo pipefail

echo "Running post-create setup..."

# Initialize firewall
sudo /usr/local/bin/init-firewall.sh

# Set up environment sourcing with error handling
setup_env_sourcing() {
    local shell_rc="$1"
    if [ -f "$shell_rc" ]; then
        # Add conditional sourcing to shell rc files
        cat >> "$shell_rc" << 'EOF'

# Source .env file if it exists
if [ -f "/workspace/.env" ]; then
    set -a  # automatically export all variables
    source /workspace/.env
    set +a  # disable automatic export
fi
EOF
        echo "✅ Added environment sourcing to $shell_rc"
    fi
}

setup_env_sourcing ~/.bashrc
setup_env_sourcing ~/.zshrc

# Source .env if it exists to get variables for MCP setup
if [ -f "/workspace/.env" ]; then
    set -a
    source /workspace/.env
    set +a
    echo "✅ Sourced environment variables from .env"
else
    echo "⚠️  No .env file found - MCP services may need manual configuration"
fi

# Add MCP services with error handling
echo "Setting up MCP services..."

# Add Firecrawl MCP service if API key is available
if [ -n "${FIRECRAWL_API_KEY:-}" ] && [ "$FIRECRAWL_API_KEY" != "your_firecrawl_api_key_here" ]; then
    echo "Adding Firecrawl MCP service..."
    claude mcp add firecrawl --scope project --env FIRECRAWL_API_KEY="${FIRECRAWL_API_KEY}" -- npx -y firecrawl-mcp
    echo "✅ Firecrawl MCP service added"
else
    echo "⚠️  FIRECRAWL_API_KEY not set or using placeholder - Firecrawl MCP service not configured"
    echo "   Please update .env with your API key and run: claude mcp add firecrawl --scope project --env FIRECRAWL_API_KEY=your_key -- npx -y firecrawl-mcp"
fi

# Add Context7 MCP service (doesn't require API key)
echo "Adding Context7 MCP service..."
claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp
echo "✅ Context7 MCP service added"

echo "🎉 Post-create setup completed!"