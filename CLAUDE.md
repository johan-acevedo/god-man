# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a template repository for running cloud code in a dev container environment. The repository provides a complete development sandbox with AI coding assistant integrations, pre-configured tooling, and security-optimized networking.

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

- Ubuntu-based container with Node.js 20
- Zsh as default shell with Powerline10k theme
- VSCode extensions: Claude Code, ESLint, Prettier, GitLens, Cline, Roo Code, Augment Code
- Format on save enabled with Prettier
- Network capabilities for testing (NET_ADMIN, NET_RAW caps)
- Automatic post-creation setup via `post-create.sh`
- Comprehensive CLI toolset: nano, vim, ripgrep, fd-find, bat, tree, htop, tmux, python3

## Common Development Commands

**Container Management:**
- Open in devcontainer: VS Code will prompt when opening the repo
- Rebuild container: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

**AI Coding Assistants:**
- `claude` - Start Claude Code CLI
- Use `@claude` mentions in GitHub issues/PRs
- Multiple AI assistants available: Claude Code, Cline, Roo Code, Augment Code

**Development Tools:**
- `rg <pattern>` - Fast text search (preferred over grep)
- `fd <pattern>` - Fast file search
- `bat <file>` - Syntax-highlighted file viewing
- `tree` - Directory structure visualization
- `htop` - Process monitoring

## MCP Services

This repository includes pre-configured MCP (Model Context Protocol) services:

- **Firecrawl**: Web scraping and crawling service (requires FIRECRAWL_API_KEY)
- **Context7**: Library documentation and code context service

Services are automatically configured during container setup via the `post-create.sh` script. API keys and configuration are stored in `.mcp.json` (excluded from Git for security).

## Architecture

**Container Setup:**
- Base: Node.js 20 on Ubuntu
- Post-creation script (`post-create.sh`) handles:
  - Firewall initialization via `init-firewall.sh`
  - Environment variable sourcing (.env file)
  - MCP service registration (Firecrawl, Context7)

**Security Model:**
- Permissive firewall optimized for development
- Default ACCEPT policies for INPUT/OUTPUT
- Host network access automatically configured
- Malicious IP blocking via ipset (minimal blocklist for development)
- Network capabilities (NET_ADMIN, NET_RAW) for testing

**AI Integration:**
- Multiple AI coding assistants pre-installed
- MCP services for enhanced capabilities (web scraping, documentation)
- Claude Code CLI available globally
- GitHub integration for @claude mentions
