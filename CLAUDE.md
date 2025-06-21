# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the Claude Code repository - an agentic coding tool that runs in the terminal and helps with development tasks. The project is primarily documentation-based with GitHub Actions for CI/CD.

## Key Files and Structure

- **README.md**: Main documentation with installation instructions and overview
- **CHANGELOG.md**: Detailed version history and feature updates
- **.devcontainer/**: Development container configuration for consistent dev environment
- **.github/workflows/**: GitHub Actions including claude.yml for @claude mentions
- **.claude/settings.local.json**: Local Claude Code permissions and settings

## Development Environment

This repository uses a devcontainer setup with:
- Ubuntu-based container with Node.js
- Zsh as default shell
- VSCode extensions: ESLint, Prettier, GitLens
- Format on save enabled with Prettier
- Network capabilities for testing (NET_ADMIN, NET_RAW caps)

## GitHub Integration

The repository has Claude Code GitHub Actions integration:
- Responds to @claude mentions in issues, PRs, and comments
- Uses anthropics/claude-code-action@beta
- Requires ANTHROPIC_API_KEY secret

## Permissions

Local settings allow find commands via Bash tool. This is a documentation repository without traditional build/test commands.

## Working with this Repository

- This is primarily a documentation repository for Claude Code
- Changes are typically to README.md, CHANGELOG.md, or configuration files
- The devcontainer provides a consistent environment for development
- GitHub Actions handle CI/CD and Claude integration