#!/usr/bin/env bash
# DeepSeek Harness Media Lab — Quick Setup Script
# Run this after cloning the repo to install all dependencies

set -e

echo "🚀 DeepSeek Harness Media Lab — Setup"
echo "======================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Install Node.js 22+ first: https://nodejs.org"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo "❌ Node.js version too old. Need 22+, found $(node --version)"
    exit 1
fi
echo "✅ Node.js $(node --version)"

if ! command -v pnpm &> /dev/null; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi
echo "✅ pnpm $(pnpm --version)"

if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Install Git first: https://git-scm.com"
    exit 1
fi
echo "✅ Git $(git --version | head -n1)"

# Check API key
if [ -z "$DEEPSEEK_API_KEY" ]; then
    echo ""
    echo "⚠️  DEEPSEEK_API_KEY not set."
    echo "   Get your key at: https://platform.deepseek.com"
    echo "   Then run: export DEEPSEEK_API_KEY='sk-...'"
    echo ""
fi

echo ""
echo "📥 Installing DeepSeek Harness..."

# Option 1: Use npx (quickest)
echo "Option 1: Using npx (recommended for quick start)"
echo "   Run: npx @deepseek-ai/dsh web"
echo ""

# Option 2: Clone from source
echo "Option 2: Clone from source (for development)"
if [ ! -d "deepseek-harness" ]; then
    git clone https://github.com/deepseek-ai/deepseek-harness.git
    cd deepseek-harness
    pnpm install
    pnpm run build
    echo "✅ DeepSeek Harness built from source"
    cd ..
else
    echo "✅ deepseek-harness already cloned"
fi

echo ""
echo "🔌 Installing Media Generation Plugins..."
echo ""

# These commands should be run inside a DSH profile directory
# For now, just print the commands

cat << 'EOF'
Run these commands to install the plugins:

# 1. Image Generation (most popular — 133 stars)
dsh plugin --profile web add github:shanliuling/dsh-image-gen

# 2. Video Generation (Remotion-based)
dsh plugin --profile web add github:chenjie1129/remotion-video-plugin#v0.4.0

# 3. Vision / QA Bridge
dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy

# 4. Browser Automation
dsh plugin --profile web add github:xu1132/dsh-plugin-browser

# 5. Task Scheduling (for Content Factory)
dsh plugin --profile web add github:titanwings/dsh-automation

# 6. Background Agents (for parallel work)
dsh plugin --profile web add github:PerryLink/dsh-background-agents

# Verify everything is mounted:
dsh doctor
dsh --profile web --dump-config
EOF

echo ""
echo "✅ Setup complete! Next steps:"
echo "   1. Set DEEPSEEK_API_KEY"
echo "   2. Run: npx @deepseek-ai/dsh web"
echo "   3. Install plugins (commands above)"
echo "   4. Start with Project 1: Agentic Media Pipeline"
echo ""
echo "📖 Full docs: https://github.com/mozartg/deepseek-harness-media-lab"
