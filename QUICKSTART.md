# Quick Start Guide

> Get from zero to your first AI-generated video in 15 minutes.

## Prerequisites

- Node.js 22+ (`node --version`)
- pnpm (`npm install -g pnpm`)
- DeepSeek API key ([platform.deepseek.com](https://platform.deepseek.com))
- ~2GB free disk space

## Step 1: Launch DeepSeek Harness (2 min)

```bash
# Quickest way — runs from npm without cloning
npx @deepseek-ai/dsh web
```

Your browser should open to `http://127.0.0.1:3080`.

> **Pro tip:** Add `--no-open` if you're on SSH and want to forward the port manually.

## Step 2: Set Your API Key (1 min)

In a new terminal:

```bash
export DEEPSEEK_API_KEY="sk-your-key-here"
```

Or create a `.env` file in your workspace:
```
DEEPSEEK_API_KEY=sk-your-key-here
```

## Step 3: Install Your First Plugin (3 min)

In the DSH Web UI, open a terminal or use the CLI:

```bash
# Install image generation (the most popular community plugin)
dsh plugin --profile web add github:shanliuling/dsh-image-gen

# Restart the web UI to pick up the plugin
# (Ctrl+C the dsh web process, then re-run npx @deepseek-ai/dsh web)
```

## Step 4: Generate Your First Image (2 min)

In a DSH session, type:

```
Generate an image of a futuristic coffee shop interior 
with warm lighting and plants everywhere.
```

The agent should:
1. Call the `generate_image` tool
2. Return the image as an attachment
3. Describe what it sees

## Step 5: Verify with Vision (2 min)

Install the vision bridge:

```bash
dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy
```

Then ask:
```
Look at the image you just generated and tell me: 
Is the lighting warm? Are there enough plants? 
What would you change?
```

The agent should:
1. Call the vision tool on the generated image
2. Critique it against your original prompt
3. Suggest improvements

## Step 6: Try a Project (5 min)

Pick one project and follow its README:

| Project | Time | What You'll Build |
|---------|------|-------------------|
| [01 Agentic Media Pipeline](projects/01-agentic-media-pipeline/) | 2-4 hours | Image → Video pipeline |
| [02 Content Automation Factory](projects/02-content-automation-factory/) | 4-8 hours | Scheduled social content |
| [03 Interactive Brand Studio](projects/03-interactive-brand-studio/) | 3-6 hours | Conversational brand design |

## Troubleshooting

### "Plugin not found after install"
- Restart `dsh web` — plugins are loaded at boot time
- Check: `dsh --profile web --dump-config | grep your-plugin-name`

### "Image generation fails"
- Verify your API keys for the image provider (Gemini, OpenAI, etc.)
- Check `dsh doctor` for plugin health
- Some providers require separate API keys from DeepSeek

### "Remotion video render fails"
- Ensure Node.js 22+ (`node --version`)
- Install Chrome/Chromium: `npx playwright install chromium`
- Check Remotion's own doctor: `npx remotion doctor`

### "Better DeepSeek not connecting to DSH"
- Install the DSH plugin: `dsh plugin --profile web add git+https://github.com/silencieuxzero/Better_Deepseek_Harness.git`
- Enable DeepCode mode in BDS settings
- Verify both are running (BDS in browser, DSH locally)

## Next Steps

1. **Star the repo** ⭐ for updates
2. **Join the community:** [DeepSeek Harness Discord](https://discord.gg/Ycq5dCaS4)
3. **Share your projects:** Add the `dsh-plugin` topic to your repos
4. **Contribute:** Submit PRs with your experiments and learnings

---

**Questions?** Open an issue on this repo or join the Discord.
