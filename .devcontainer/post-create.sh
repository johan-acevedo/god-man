#!/bin/bash
set -euo pipefail

echo "Running post-create setup..."

# Initialize firewall
sudo /usr/local/bin/init-firewall.sh

# API key validation functions
validate_firecrawl_key() {
    local key="$1"
    
    # Check if key is empty or placeholder
    if [ -z "$key" ] || [ "$key" = "your_firecrawl_api_key_here" ]; then
        return 1
    fi
    
    # Check key format (Firecrawl keys typically start with "fc-")
    if [[ ! "$key" =~ ^fc-[a-zA-Z0-9]{32}$ ]]; then
        echo "⚠️  API key format invalid: Expected 'fc-' followed by 32 characters"
        echo "   Example: fc-1234567890abcdef1234567890abcdef"
        return 1
    fi
    
    # Test API connectivity
    echo "🔍 Validating Firecrawl API key..."
    response=$(curl -s -w "%{http_code}" \
        -H "Authorization: Bearer $key" \
        -H "Content-Type: application/json" \
        https://api.firecrawl.dev/v0/scrape \
        -d '{"url": "https://example.com"}' \
        -o /tmp/firecrawl_test 2>/dev/null || echo "000")
    
    http_code="${response: -3}"
    if [ "$http_code" = "200" ] || [ "$http_code" = "202" ]; then
        echo "✅ Firecrawl API key validated successfully"
        return 0
    else
        echo "❌ Firecrawl API key validation failed (HTTP $http_code)"
        return 1
    fi
}

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

# Clean up existing MCP configuration to start fresh
echo "Setting up MCP services..."
if [ -f "/workspace/.mcp.json" ]; then
    echo "🧹 Removing existing MCP configuration..."
    rm -f /workspace/.mcp.json
fi

# Remove existing MCP services to avoid conflicts
echo "🧹 Cleaning up existing MCP services..."
claude mcp remove firecrawl --scope project 2>/dev/null || true
claude mcp remove context7 --scope project 2>/dev/null || true

# Add Context7 MCP service (doesn't require API key)
echo "Adding Context7 MCP service..."
if claude mcp add context7 --scope project -- npx -y @upstash/context7-mcp; then
    echo "✅ Context7 MCP service added"
    echo "   📚 Context7 provides library documentation and code context for AI assistants"
else
    echo "❌ Failed to add Context7 MCP service"
fi

# Add Firecrawl MCP service if API key is available and valid
if [ -n "${FIRECRAWL_API_KEY:-}" ]; then
    if validate_firecrawl_key "$FIRECRAWL_API_KEY"; then
        echo "Adding Firecrawl MCP service..."
        if claude mcp add firecrawl --scope project --env FIRECRAWL_API_KEY="${FIRECRAWL_API_KEY}" -- npx -y firecrawl-mcp; then
            echo "✅ Firecrawl MCP service added with validated API key"
            echo "   🕷️  Web scraping, crawling, and content extraction now available"
        else
            echo "❌ Failed to add Firecrawl MCP service"
        fi
    else
        echo ""
        echo "🌐 FIRECRAWL API KEY VALIDATION FAILED"
        echo "   Your API key format appears invalid or the service is unreachable."
        echo ""
        echo "   📋 To fix this:"
        echo "   1. Verify your API key starts with 'fc-' and is 35 characters long"
        echo "   2. Get a fresh key from: https://firecrawl.dev/"
        echo "   3. Edit: nano /workspace/.env"
        echo "   4. Update: FIRECRAWL_API_KEY=fc-your-actual-key-here"
        echo "   5. Rebuild: Ctrl+Shift+P → 'Dev Containers: Rebuild Container'"
        echo ""
        echo "   💡 Test your key: curl -H \"Authorization: Bearer YOUR_KEY\" https://api.firecrawl.dev/v0/scrape"
        echo ""
    fi
else
    echo ""
    echo "🌐 FIRECRAWL SETUP NEEDED"
    echo "   Firecrawl provides web scraping and crawling capabilities for AI assistants."
    echo "   This enables Claude Code to fetch content from websites and analyze web pages."
    echo ""
    echo "   📋 To enable Firecrawl MCP service:"
    echo "   1. Get a free API key: https://firecrawl.dev/"
    echo "   2. Edit the .env file: nano /workspace/.env"
    echo "   3. Replace: FIRECRAWL_API_KEY=your_firecrawl_api_key_here"
    echo "      With:    FIRECRAWL_API_KEY=fc-your-actual-key-here"
    echo "   4. Rebuild container: Ctrl+Shift+P → 'Dev Containers: Rebuild Container'"
    echo ""
    echo "   💡 Firecrawl keys start with 'fc-' and are 35 characters long"
    echo "   ⏭️  Skip this step if you don't need web scraping capabilities"
    echo ""
fi

echo "🎉 Post-create setup completed!"