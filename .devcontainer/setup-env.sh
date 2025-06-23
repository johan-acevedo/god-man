#!/bin/bash
set -euo pipefail

echo "Setting up environment variables..."

# Define the workspace directory
WORKSPACE_DIR="/workspace"
ENV_FILE="$WORKSPACE_DIR/.env"
ENV_EXAMPLE_FILE="$WORKSPACE_DIR/.env.example"

# Function to create .env from .env.example with intelligent defaults
create_env_file() {
    echo "Creating .env file from .env.example..."
    
    # Start with the example file
    cp "$ENV_EXAMPLE_FILE" "$ENV_FILE"
    
    # Replace placeholder values with actual values or environment-specific defaults
    
    # Handle FIRECRAWL_API_KEY
    if [ -n "${FIRECRAWL_API_KEY:-}" ]; then
        # Use the environment variable (from Codespaces secrets or local export)
        echo "Using FIRECRAWL_API_KEY from environment"
        sed -i "s/FIRECRAWL_API_KEY=your_firecrawl_api_key_here/FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY}/" "$ENV_FILE"
    elif [ -n "${CODESPACES:-}" ]; then
        # We're in GitHub Codespaces but no secret is set
        echo "⚠️  WARNING: In GitHub Codespaces but FIRECRAWL_API_KEY secret not set"
        echo "   Please add FIRECRAWL_API_KEY to your Codespaces secrets for full functionality"
        echo "   Repository Settings → Secrets → Codespaces → New repository secret"
        # Leave the placeholder value for now
    else
        # Local development - leave placeholder for manual configuration
        echo "📝 Local development detected - please update .env with your actual API keys"
    fi
    
    echo "✅ .env file created successfully"
}

# Check if we're in a container build context or runtime
if [ -d "$WORKSPACE_DIR" ]; then
    # We have access to the workspace directory
    if [ ! -f "$ENV_FILE" ]; then
        if [ -f "$ENV_EXAMPLE_FILE" ]; then
            create_env_file
        else
            echo "❌ ERROR: .env.example file not found at $ENV_EXAMPLE_FILE"
            echo "   Cannot create .env file without template"
            exit 1
        fi
    else
        echo "✅ .env file already exists"
        
        # Check if we need to update environment variables from Codespaces secrets
        if [ -n "${CODESPACES:-}" ] && [ -n "${FIRECRAWL_API_KEY:-}" ]; then
            echo "Updating .env with Codespaces secrets..."
            # Update the .env file with the secret value if it's still a placeholder
            if grep -q "your_firecrawl_api_key_here" "$ENV_FILE"; then
                sed -i "s/FIRECRAWL_API_KEY=your_firecrawl_api_key_here/FIRECRAWL_API_KEY=${FIRECRAWL_API_KEY}/" "$ENV_FILE"
                echo "✅ Updated FIRECRAWL_API_KEY from Codespaces secrets"
            fi
        fi
    fi
else
    echo "ℹ️  Workspace directory not available yet - will be handled during container startup"
fi

echo "Environment setup completed!"