#!/bin/bash

echo "🚀 Setting up development environment..."

# 1. Create .env file from .env.example if needed
if [ -f .env.example ]; then
    if [ ! -f .env ] || [ "$(cat .env)" = "# Environment variables for MCP servers
# This file will be updated during container startup
FIRECRAWL_API_KEY=your_firecrawl_api_key_here" ]; then
        cp .env.example .env
        echo "✅ Created .env file from .env.example"
    else
        echo "ℹ️  .env file already exists, skipping creation"
    fi
else
    echo "❌ Warning: .env.example not found"
    if [ ! -f .env ]; then
        echo "# Environment variables for MCP servers" > .env
        echo "FIRECRAWL_API_KEY=your_firecrawl_api_key_here" >> .env
        echo "✅ Created basic .env file"
    fi
fi

# 2. Handle GitHub Codespaces environment variables
if [ -n "${CODESPACES:-}" ]; then
    echo "🌐 Running in GitHub Codespaces"
    
    # Override .env values with Codespaces secrets if they exist
    if [ -n "${FIRECRAWL_API_KEY:-}" ]; then
        # Replace the placeholder in .env with the actual secret
        sed -i "s/FIRECRAWL_API_KEY=your_firecrawl_api_key_here/FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY}/" .env
        echo "✅ Using FIRECRAWL_API_KEY from Codespaces secrets"
    else
        echo "⚠️  FIRECRAWL_API_KEY secret not set in Codespaces"
        echo "   Add it via: Repository Settings → Secrets → Codespaces → New repository secret"
    fi
else
    echo "💻 Running locally - please edit .env with your actual values"
fi

# 3. Set proper permissions
chmod 644 .env* 2>/dev/null || true

echo "✅ Development environment setup complete!"
echo ""
if [ -n "${CODESPACES:-}" ]; then
    echo "📚 Your GitHub Codespaces secrets are automatically configured"
else
    echo "📚 Next steps:"
    echo "  • Edit .env file with your actual secret values"
    echo "  • See .env.example for required variables"
fi
echo "  • Happy coding! 🎉"