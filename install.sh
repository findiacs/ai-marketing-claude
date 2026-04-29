#!/bin/bash
# AI Marketing Suite — Universal Agent Skills Installer
# Installs marketing skills, agents, and scripts for Claude Code, Antigravity, Gemini, Codex, Qwen Code, Cursor, and Goose.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   AI Marketing Suite — Agent Skills          ║${NC}"
echo -e "${CYAN}║   15 Skills · 5 Agents · 4 Scripts · PDF     ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Detect script directory
if [ -n "$BASH_SOURCE" ] && [ "$BASH_SOURCE" != "bash" ] && [ -f "$BASH_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$BASH_SOURCE")" && pwd)"
else
    # Running via curl | bash — need to clone
    echo -e "${YELLOW}Running remote install — cloning repository...${NC}"
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/zubair-trabzada/ai-marketing-claude.git "$TEMP_DIR/ai-marketing-claude" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to clone repository.${NC}"
        # We use return instead of exit so it doesn't break source
        return 1 2>/dev/null || true
    fi
    SCRIPT_DIR="$TEMP_DIR/ai-marketing-claude"
fi

echo -e "${BLUE}Source:${NC}  $SCRIPT_DIR"

# Determine target directories
LOCAL_INSTALL=false
if [ "$1" == "--local" ]; then
    LOCAL_INSTALL=true
    echo -e "${BLUE}Mode:${NC}    Local Workspace Install"
else
    echo -e "${BLUE}Mode:${NC}    Global Universal Install"
fi
echo ""

# Array of target directories
TARGET_DIRS=()

if [ "$LOCAL_INSTALL" = true ]; then
    TARGET_DIRS=("$PWD/.agent/skills" "$PWD/.claude/skills" "$PWD/.gemini/skills")
else
    # Standard Agent Skills Global Locations
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
    )
fi

# We only copy the agents to specific clients that use a separate agents folder
AGENT_DIRS=()
if [ "$LOCAL_INSTALL" = true ]; then
    AGENT_DIRS=("$PWD/.agent/agents" "$PWD/.claude/agents")
else
    AGENT_DIRS=(
        "$HOME/.claude/agents"
        "$HOME/.gemini/agents"
        "$HOME/.qwen/agents"
    )
fi

# Define the installation function
install_to_dir() {
    local TARGET_SKILLS_DIR=$1
    echo -e "${BLUE}Installing to:${NC} $TARGET_SKILLS_DIR"

    mkdir -p "$TARGET_SKILLS_DIR"

    # Install main skill orchestrator
    mkdir -p "$TARGET_SKILLS_DIR/market"
    cp "$SCRIPT_DIR/market/SKILL.md" "$TARGET_SKILLS_DIR/market/SKILL.md"

    # Install sub-skills
    SKILLS=(
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

    for skill in "${SKILLS[@]}"; do
        if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
            mkdir -p "$TARGET_SKILLS_DIR/$skill"
            cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$TARGET_SKILLS_DIR/$skill/SKILL.md"
        fi
    done

    # Install scripts
    SCRIPTS_TARGET="$TARGET_SKILLS_DIR/market/scripts"
    mkdir -p "$SCRIPTS_TARGET"

    SCRIPT_FILES=(
        "analyze_page.py"
        "competitor_scanner.py"
        "social_calendar.py"
        "generate_pdf_report.py"
    )

    for script in "${SCRIPT_FILES[@]}"; do
        if [ -f "$SCRIPT_DIR/scripts/$script" ]; then
            cp "$SCRIPT_DIR/scripts/$script" "$SCRIPTS_TARGET/$script"
            chmod +x "$SCRIPTS_TARGET/$script"
        fi
    done

    # Install templates
    TEMPLATES_TARGET="$TARGET_SKILLS_DIR/market/templates"
    mkdir -p "$TEMPLATES_TARGET"

    if [ -d "$SCRIPT_DIR/templates" ]; then
        for template in "$SCRIPT_DIR/templates"/*.md; do
            if [ -f "$template" ]; then
                cp "$template" "$TEMPLATES_TARGET/$(basename "$template")"
            fi
        done
    fi
}

install_agents_to_dir() {
    local TARGET_AGENTS_DIR=$1
    mkdir -p "$TARGET_AGENTS_DIR"

    AGENTS=(
        "market-content"
        "market-conversion"
        "market-competitive"
        "market-technical"
        "market-strategy"
    )

    for agent in "${AGENTS[@]}"; do
        if [ -f "$SCRIPT_DIR/agents/$agent.md" ]; then
            cp "$SCRIPT_DIR/agents/$agent.md" "$TARGET_AGENTS_DIR/$agent.md"
        fi
    done
}

echo -e "\n${BLUE}Copying files...${NC}"

# Iterate over all target skill directories
for dir in "${TARGET_DIRS[@]}"; do
    install_to_dir "$dir"
done

# Iterate over all target agent directories
for dir in "${AGENT_DIRS[@]}"; do
    install_agents_to_dir "$dir"
done

# Install Python dependencies
echo -e "\n${BLUE}Checking Python dependencies...${NC}"
if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
    echo -e "  ${GREEN}✓${NC} Python $PYTHON_VERSION detected"

    # Check for reportlab (needed for PDF reports)
    if python3 -c "import reportlab" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} reportlab installed (PDF reports ready)"
    else
        echo -e "  ${YELLOW}⚠${NC} reportlab not installed (needed for PDF reports)"
        echo -e "    Install with: ${CYAN}pip install reportlab${NC}"
    fi

    # Check for requests (optional, scripts use urllib as fallback)
    if python3 -c "import requests" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} requests installed"
    fi
else
    echo -e "  ${YELLOW}⚠${NC} Python 3 not found — scripts won't work"
    echo -e "    Install Python: ${CYAN}https://python.org${NC}"
fi

# Cleanup temp directory if used
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# Summary
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Installation Complete!              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Skills successfully installed across supported platforms."
echo ""
echo -e "${CYAN}Available Commands:${NC}"
echo "  /market audit <url>        Full marketing audit (5 parallel agents)"
echo "  /market quick <url>        60-second marketing snapshot"
echo "  /market copy <url>         Generate optimized copy"
echo "  /market emails <topic>     Generate email sequences"
echo "  /market social <topic>     Social media content calendar"
echo "  /market ads <url>          Ad creative and copy"
echo "  /market funnel <url>       Sales funnel analysis"
echo "  /market competitors <url>  Competitive intelligence"
echo "  /market landing <url>      Landing page CRO"
echo "  /market launch <product>   Launch playbook"
echo "  /market proposal <client>  Client proposal generator"
echo "  /market report <url>       Marketing report (Markdown)"
echo "  /market report-pdf <url>   Marketing report (PDF)"
echo "  /market seo <url>          SEO content audit"
echo "  /market brand <url>        Brand voice analysis"
echo ""
echo -e "  ${YELLOW}Restart your AI Agent CLI or IDE to use the skills.${NC}"
echo ""
