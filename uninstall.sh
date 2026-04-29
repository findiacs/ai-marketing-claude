#!/bin/bash
# AI Marketing Suite — Universal Agent Skills Uninstaller

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}Uninstalling AI Marketing Suite Skills...${NC}"
echo ""

# Global Universal Locations
TARGET_DIRS=(
    "$HOME/.claude/skills"
    "$HOME/.gemini/antigravity/skills"
    "$HOME/.gemini/skills"
    "$HOME/.codex/skills"
    "$HOME/.qwen/skills"
    "$HOME/.cursor/skills"
    "$HOME/.jules/skills"
    "$HOME/.opencode/skills"
    "$HOME/.config/goose/skills"
    "$HOME/.agent/skills"
    "$PWD/.agent/skills"
    "$PWD/.claude/skills"
    "$PWD/.gemini/skills"
)

AGENT_DIRS=(
    "$HOME/.claude/agents"
    "$HOME/.gemini/agents"
    "$HOME/.qwen/agents"
    "$PWD/.agent/agents"
    "$PWD/.claude/agents"
)

SKILLS=(
    "market"
    "market-audit"
    "market-copy"
    "market-emails"
    "market-social"
    "market-ads"
    "market-funnel"
    "market-competitors"
    "market-landing"
    "market-launch"
    "market-proposal"
    "market-report"
    "market-report-pdf"
    "market-seo"
    "market-brand"
)

AGENTS=(
    "market-content.md"
    "market-conversion.md"
    "market-competitive.md"
    "market-technical.md"
    "market-strategy.md"
)

REMOVED_COUNT=0

# Remove Skills
for dir in "${TARGET_DIRS[@]}"; do
    for skill in "${SKILLS[@]}"; do
        if [ -d "$dir/$skill" ]; then
            rm -rf "$dir/$skill"
            echo -e "  ${RED}✗${NC} Removed skill: $dir/$skill"
            REMOVED_COUNT=$((REMOVED_COUNT + 1))
        fi
    done
done

# Remove Agents
for dir in "${AGENT_DIRS[@]}"; do
    for agent in "${AGENTS[@]}"; do
        if [ -f "$dir/$agent" ]; then
            rm -f "$dir/$agent"
            echo -e "  ${RED}✗${NC} Removed agent: $dir/$agent"
            REMOVED_COUNT=$((REMOVED_COUNT + 1))
        fi
    done
done

echo ""
if [ $REMOVED_COUNT -gt 0 ]; then
    echo -e "${GREEN}Successfully uninstalled AI Marketing Suite.${NC}"
else
    echo -e "${YELLOW}No AI Marketing Suite files found. Already uninstalled?${NC}"
fi
echo ""
