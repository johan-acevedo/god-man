# AI Development Sandbox

> A comprehensive development environment for AI coding assistants with pre-configured MCP services, security optimizations, and multi-agent support.

## Overview

This repository provides a complete development sandbox environment designed for working with multiple AI coding assistants including Claude Code, Cline, Roo Code, and Augment Code. It features automated MCP (Model Context Protocol) service configuration, security-optimized networking, and seamless integration with both local development and GitHub Codespaces.

## Getting Started

This project runs in a VS Code dev container with Claude Code integration.

### Prerequisites

- VS Code with Dev Containers extension
- Docker

### Setup

1. Open this repository in VS Code
2. When prompted, reopen in dev container
3. Start building your project!

## Environment Configuration

This project uses a robust environment variable system that works seamlessly in both local development and GitHub Codespaces.

### Local Development

For local development, the devcontainer will automatically:

1. **Auto-create .env file**: If `.env` doesn't exist, it's automatically created from `.env.example`
2. **Use placeholder values**: You'll need to manually update `.env` with your actual API keys
3. **Provide helpful guidance**: The setup process will guide you on what needs to be configured

**Steps:**
1. Clone the repository
2. Open in VS Code
3. Accept the "Reopen in Container" prompt
4. The `.env` file is automatically created
5. Update `.env` with your actual API keys:
   ```bash
   # Edit .env file
   FIRECRAWL_API_KEY=your_actual_api_key_here
   ```
6. Rebuild the container if needed: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

### GitHub Codespaces

For GitHub Codespaces, the system intelligently uses repository secrets:

1. **Automatic secret integration**: Environment variables are automatically populated from Codespaces secrets
2. **No manual configuration**: If secrets are properly set, everything works out of the box
3. **Security first**: Secrets are never committed to the repository

**Setup Codespaces Secrets:**
1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Codespaces**
3. Click **New repository secret**
4. Add the following secrets:
   - `FIRECRAWL_API_KEY`: Your Firecrawl API key from https://firecrawl.dev/

**Verification:**
- When you open the repository in Codespaces, check the setup output
- Look for `✅ Using FIRECRAWL_API_KEY from environment` messages
- If you see warnings about missing secrets, add them to your repository secrets

### Environment Variables

The following environment variables are supported:

| Variable | Description | Required | Local Setup | Codespaces Setup |
|----------|-------------|----------|-------------|------------------|
| `FIRECRAWL_API_KEY` | Firecrawl API key for web scraping | Optional | Update `.env` file | Repository secret |

## MCP Configuration

This repository uses a **dynamic MCP configuration approach** that keeps secrets secure while maintaining functionality:

### How It Works

1. **`.mcp.json` is generated dynamically** during container startup - it's not tracked in Git
2. **API keys are validated** before configuring services to ensure they work correctly
3. **Services are cleaned up and regenerated** on each container rebuild for consistency
4. **Environment variables are sourced** from `.env` (local) or Codespaces secrets (cloud)

### Supported MCP Services

- **Firecrawl**: Web scraping and crawling service (requires API key)
- **Context7**: Library documentation and code context service (free)

### Troubleshooting

**Problem**: Devcontainer fails to start with "docker: open .env: no such file or directory"
**Solution**: This is now automatically handled. The setup script creates `.env` from `.env.example` if it doesn't exist.

**Problem**: MCP services not working
**Solution**: 
1. Check that your API keys are properly set in `.env` (local) or Codespaces secrets (cloud)
2. Verify the keys are not placeholder values (should start with `fc-` for Firecrawl)
3. Check the container startup logs for API key validation messages
4. Rebuild the container after updating environment variables: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

**Problem**: "Firecrawl API key validation failed"
**Solution**: 
1. Ensure your API key is valid and starts with `fc-`
2. Test the key manually: `curl -H "Authorization: Bearer YOUR_KEY" https://api.firecrawl.dev/v0/scrape`
3. Get a new key from https://firecrawl.dev/ if needed

**Problem**: Environment variables not loading in shell
**Solution**: 
1. Reload your shell: `source ~/.bashrc` or `source ~/.zshrc`
2. The `.env` file is automatically sourced in new terminal sessions

## Development

This project includes:

- 🐳 Dev container with pre-configured environment
- 🤖 Claude Code integration for AI-assisted development
- ⚙️ VS Code extensions (ESLint, Prettier, Claude Code, Cline, Roo Code, Augment Code)
- 🔧 Automated formatting and linting

### Using Claude Code

- Run `claude` in the terminal to start Claude Code
- Use `@claude` mentions in GitHub issues and PRs for AI assistance
- Check `CLAUDE.md` for project-specific Claude guidance

## Contributing

Add your contribution guidelines here.

## License

Add your license information here.
