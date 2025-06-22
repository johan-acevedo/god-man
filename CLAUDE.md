# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a template repository for running cloud code in a dev container environment

## Key Files and Structure

- **README.md**: Main documentation with installation instructions and overview
- **CLAUDE.md**: This file - provides guidance to Claude Code when working with the repository
- **.devcontainer/**: Development container configuration for consistent dev environment
  - `devcontainer.json`: Container configuration with extensions and settings
  - `Dockerfile`: Container image configuration with installation and setup code
  - `init-firewall.sh`: Firewall initialization script
  - `post-create.sh`: Post-creation setup script that configures environment and MCP services
- **.github/workflows/**: GitHub Actions including claude.yml for @claude mentions
- **.claude/settings.local.json**: Local Claude Code permissions and settings
- **.env.example**: Example environment variables file
- **.mcp.json**: MCP (Model Context Protocol) configuration (contains API keys/secrets, excluded from Git)

## Development Environment

This repository uses a devcontainer setup with:

- Ubuntu-based container with Node.js
- Zsh as default shell
- VSCode extensions: ESLint, Prettier, GitLens
- Format on save enabled with Prettier
- Network capabilities for testing (NET_ADMIN, NET_RAW caps)
- Automatic post-creation setup via `post-create.sh`

## MCP Services

This repository includes pre-configured MCP (Model Context Protocol) services:

- **Firecrawl**: Web scraping and crawling service (requires FIRECRAWL_API_KEY)
- **Context7**: Library documentation and code context service

Services are automatically configured during container setup via the `post-create.sh` script. API keys and configuration are stored in `.mcp.json` (excluded from Git for security).

## Firewall Configuration

This sandbox runs a permissive firewall configuration optimized for development:

- Default policies are ACCEPT for both INPUT and OUTPUT traffic
- Host network access is automatically configured
- Only malicious IP ranges are blocked via ipset blocklist
- The `init-firewall.sh` script configures firewall rules during container startup
- Network operations should generally work without restrictions

The firewall provides basic security while allowing development flexibility. If specific network restrictions are needed, modify the `init-firewall.sh` script accordingly.
