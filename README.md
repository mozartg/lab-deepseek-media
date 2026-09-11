> Role is defined by .portfolio/repo-manifest.json. Name is descriptive only.
> Machine-readable state is the single source of truth.

# DeepSeek Harness Media Lab

> Research-driven project incubator for DeepSeek Harness media generation & automation capabilities.  
> **Created:** 2026-08-22 | **Status:** Active research → implementation pipeline

---

## Table of Contents

1. [What is DeepSeek Harness?](#what-is-deepseek-harness)
2. [What is Better DeepSeek?](#what-is-better-deepseek)
3. [How They Connect](#how-they-connect)
4. [Community Plugin Ecosystem (Sourced from GitHub/Reddit/HN)](#community-plugin-ecosystem)
5. [Research Findings](#research-findings)
6. [Project 1: Agentic Media Pipeline](#project-1-agentic-media-pipeline--image--video-generation)
7. [Project 2: Content Automation Factory](#project-2-content-automation-factory--scheduled-social-assets)
8. [Project 3: Interactive Brand Studio](#project-3-interactive-brand-studio--real-time-visual-iteration)
9. [Local Setup Guide](#local-setup-guide)
10. [References & Sources](#references--sources)

---

## What is DeepSeek Harness?

**DeepSeek Harness (`dsh`)** is DeepSeek AI's official open-source agent framework, released August 13, 2026 alongside DeepSeek V4-Pro. It uses a **"everything is a plugin"** architecture powered by [Cordis](https://github.com/cordiverse/cordis).

| Attribute | Detail |
|-----------|--------|
| **Repo** | [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) |
| **Language** | TypeScript / Node.js (official), Python SDK available |
| **Install** | `npx @deepseek-ai/dsh web` |
| **Status** | Developer preview (rapid iteration, breaking changes expected) |
| **Core Idea** | Plugin-based agent harness where every capability is a Cordis plugin |
| **Key Features** | Web UI, headless agent, JSON-RPC SDK, MCP client, subagent delegation, session persistence |

### Official Examples
- `jsonrpc-agent` — Unattended coding agent via Python SDK
- `headless-agent` — Non-interactive single-task agent
- `web-cordis` — Self-referential plugin inspection agent
- `web-schedule` — Session-local reminders & scheduling
- `acp-agent` — Agent Client Protocol automation server
- `mcp-memory` — Third-party memory servers via MCP

### Official Docs
- [Quickstart](https://github.com/deepseek-ai/deepseek-harness#run)
- [Architecture](https://github.com/deepseek-ai/deepseek-harness/blob/main/docs/architecture.md)
- [Development Guide](https://github.com/deepseek-ai/deepseek-harness/blob/main/docs/development.md)
- [AGENTS.md](https://github.com/deepseek-ai/deepseek-harness/blob/main/AGENTS.md) — Agent documentation standard

---

## What is Better DeepSeek?

**Better DeepSeek (BDS)** is a popular browser extension (10K+ Chrome Web Store users) that enhances the DeepSeek chat web interface with tools, persistent memory, and custom system prompts. It is **unofficial/community-driven** and NOT affiliated with DeepSeek AI.

| Attribute | Detail |
|-----------|--------|
| **Repo** | [EdgeTypE/better-deepseek](https://github.com/EdgeTypE/better-deepseek) |
| **Install** | Chrome Web Store, Edge Add-ons, Firefox Add-ons |
| **Status** | Active (v0.1.12 as of 2026-08-15) |
| **Key Features** | Tool tags (`<BDS:...>`), persistent memory, custom prompts, PPTX/Excel/DOCX generation, code execution, folder upload, GitHub repo import, MCP server support |

### Recent Features (v0.1.12)
- **DeepCode** — Collaborative coding mode that works alongside DeepSeek Harness
- **DeepCode Auto Tools** — `SEARCH_IN_DIRECTORY`, `LIST_DIR`, `FILE_READ`
- **Queued Prompts** — Auto-queue messages while generation is active
- **MCP Server Support** — Connect remote MCP servers for external tools
- **Dynamic Tables** — Sortable/reorderable data tables

### Better DeepSeek Harness Plugin
There is ALSO a DSH plugin called `better-deepseek-harness` ([silencieuxzero/Better_Deepseek_Harness](https://github.com/silencieuxzero/Better_Deepseek_Harness)) that adds skill/plugin management directly into the DSH Web UI settings.

---

## How They Connect

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEEPSEEK HARNESS (dsh)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │  Web UI     │  │ Headless    │  │  JSON-RPC Agent         │  │
│  │  (local)    │  │ Agent       │  │  (Python SDK)           │  │
│  └──────┬──────┘  └──────┬──────┘  └───────────┬─────────────┘  │
│         │                │                     │                │
│         └────────────────┴─────────────────────┘                │
│                          │                                      │
│              ┌───────────┴───────────┐                          │
│              │   Cordis Plugin Tree   │                          │
│              │  ┌─────────────────┐   │                          │
│              │  │ dsh-image-gen   │   │ ← Image generation       │
│              │  │ remotion-video  │   │ ← Video generation       │
│              │  │ dsh-automation    │   │ ← Scheduled tasks        │
│              │  │ dsh-browser     │   │ ← Web scraping           │
│              │  │ dsh-vision      │   │ ← Vision bridge          │
│              │  │ ...             │   │                          │
│              │  └─────────────────┘   │                          │
│              └────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 BETTER DEEPSEEK (Browser Ext)                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │ Tool Tags   │  │ Memory      │  │  MCP Servers            │  │
│  │ <BDS:...>   │  │ Storage     │  │  (External Tools)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘  │
│                                                                 │
│  • Injects system prompt into chat.deepseek.com                 │
│  • Renders tool cards (HTML, Python, PPTX, etc.)                │
│  • DeepCode mode → plans tasks → transfers to DSH               │
│  • dsh-better-deepseek plugin bridges the two                  │
└─────────────────────────────────────────────────────────────────┘
```

**Integration Pattern:** Better DeepSeek's new "DeepCode" mode can plan complex tasks and then seamlessly transfer execution to DeepSeek Harness via the `dsh-better-deepseek` plugin.

---

## Community Plugin Ecosystem

The `dsh-plugin` topic on GitHub has exploded since the August 13 release. Below are the **most relevant plugins for media generation and automation**, sourced from GitHub discussions, awesome-lists, and community directories.

### 🎨 Image & Video Generation

| Plugin | Stars | Description | Source |
|--------|-------|-------------|--------|
| **dsh-image-gen** (shanliuling) | ⭐ 133 | Multi-provider image gen: Gemini, OpenAI Images, Seedream, OpenAI-compatible APIs | [GitHub](https://github.com/shanliuling/dsh-image-gen) |
| **remotion-video-plugin** | ⭐ 1 | Programmatic video generation with Remotion + React. 5 tools: doctor, list compositions, render still/video, probe output | [GitHub](https://github.com/chenjie1129/remotion-video-plugin) |
| **dsh-plugin-grok2api-media-tool** | — | Image & video generation via grok2api | [GitHub](https://github.com/lsjspl/dsh-plugin-grok2api-media-tool) |
| **weshop-dsh-plugin** | — | E-commerce image/video generation on infinite canvas | [GitHub](https://github.com/weshop-dsh-plugin) |
| **dsh-draw** (PerryLink) | — | Static image generation router with health-aware fallback | [GitHub](https://github.com/PerryLink/dsh-draw) |

### 🤖 Automation & Orchestration

| Plugin | Stars | Description | Source |
|--------|-------|-------------|--------|
| **dsh-automation** (titanwings) | ⭐ 67 | Run coding tasks in fresh Agent sessions on schedule. Cron-like task manager | [GitHub](https://github.com/titanwings/dsh-automation) |
| **dsh-automation-center** | — | Root-level automation: scheduled tasks, Result Sessions, cross-workspace history | [GitHub](https://github.com/usersx/dsh-automation-center) |
| **dsh-background-agents** (PerryLink) | — | Durable background child agents with persistent team rooms, message bus, task board | [GitHub](https://github.com/PerryLink/dsh-background-agents) |
| **dsh-taskswarm** | — | Dependency-ordered parallel task waves with git-worktree lanes | [GitHub](https://github.com/february2015/dsh-taskswarm) |
| **dsh-self-evolving** | — | Evidence-first self-evolution engine: generates plugin candidates, evaluates, journals | [GitHub](https://github.com/timwhitez/dsh-self-evolving) |

### 👁️ Vision & Multimodal

| Plugin | Description |
|--------|-------------|
| **dsh-vision** | Zero-cost vision for text-only DeepSeek via Chrome CDP bridge |
| **dsh-vision-proxy** | Auto-transcribe images to text for text-only DeepSeek via VLM |
| **dsh-free-vision** | Free-tier vision bridge (Qwen3-VL-Flash, Doubao, DeepSeek-OCR) |
| **Gemini-Eyes** | MCP bridge to gemini.google.com for vision + Imagen/Veo generation |

### 🛠️ Development & Tooling

| Plugin | Description |
|--------|-------------|
| **dsh-plugin-browser** | Playwright-driven headless browser: navigate, click, type, screenshot |
| **dsh-gitflow** | Approval-gated Git operations |
| **dsh-specflow** | Specification artifacts, goal-backed implementation |
| **dsh-code-intel** | Tree-sitter symbol indexing with embedding search |
| **dsh-vscode** | VS Code sidebar running official JSON-RPC SDK |

### 📚 Awesome Lists
- [Anil-matcha/awesome-dsh-plugin](https://github.com/Anil-matcha/awesome-dsh-plugin)
- [0xsline/awesome-deepseek-harness](https://github.com/0xsline/awesome-deepseek-harness)
- [ywsldxk/dsh-plugin-stars](https://github.com/ywsldxk/dsh-plugin-stars) — Plugin leaderboard by stars

---

## Research Findings

### Key Discovery: DeepSeek Has NO Native Media Generation

DeepSeek's models (V4-Pro, V4-Flash, V3.2, etc.) are **text-only LLMs**. They do NOT natively generate images, video, or audio. However, the Harness plugin architecture enables the agent to:

1. **Call external APIs** (OpenAI Images, Gemini, Seedream, etc.) via plugins
2. **Generate code** that produces media (Remotion videos, PIL images, FFmpeg pipelines)
3. **Orchestrate multi-step workflows** combining vision, generation, and editing

This is actually a **strength** for automation: the agent reasons in text, then delegates media creation to specialized tools.

### Community Experiment Patterns (from GitHub Discussions)

1. **Plugin chaining** — Vision plugin describes an image → image-gen plugin creates variations → Remotion plugin animates
2. **Scheduled content pipelines** — Automation plugin triggers at intervals → agent generates assets → uploads to CMS
3. **E-commerce workflows** — Agent takes product descriptions → generates images → creates marketing videos → updates store
4. **Self-evolving agents** — Agent generates its own plugin code, tests it, and promotes working solutions to skills

### Reddit / HN Sentiment (Aug 2026)

- Early adopters are impressed by the Cordis plugin architecture but note the rapid breaking changes
- The most active experimentation is around: (1) vision bridges, (2) image generation plugins, (3) browser automation
- Several developers are building "agent teams" using background-agents and taskswarm plugins
- Concern: no official Python distribution yet (only Node/TypeScript)

---

## Project 1: Agentic Media Pipeline — Image + Video Generation

### Overview
Build a DeepSeek Harness plugin bundle that gives the agent a complete media creation workflow: generate images, create videos from them, and verify output quality — all through natural language commands.

### Architecture

```
User Prompt → DSH Agent → Media Orchestrator Skill
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        ┌─────────┐    ┌──────────┐    ┌──────────┐
        │dsh-image│    │remotion- │    │dsh-vision│
        │  -gen   │    │  video   │    │  (QA)    │
        └────┬────┘    └────┬─────┘    └────┬─────┘
             │              │               │
             ▼              ▼               ▼
        [PNG/JPG]     [MP4/WebM]      [Quality Report]
```

### Components

| Component | Plugin | Purpose |
|-----------|--------|---------|
| Image Generation | `dsh-image-gen` | Multi-provider image generation (Gemini, OpenAI, Seedream) |
| Video Generation | `remotion-video-plugin` | Programmatic React-based video rendering |
| Vision QA | `dsh-vision-proxy` | Verify generated media quality via VLM |
| Orchestrator | Custom skill | Chain the tools: concept → storyboard → assets → render → verify |

### Example Prompts

```
"Create a 30-second product launch video for a cold brew coffee brand. 
Generate 5 product images first, then animate them into a video with 
text overlays and background music."
```

```
"Make a vertical TikTok-style video (9:16) about productivity tips. 
Generate each scene as an image, then combine with captions and 
transitions using Remotion."
```

### Implementation Steps

1. **Install base plugins:**
   ```bash
   dsh plugin --profile web add github:shanliuling/dsh-image-gen
   dsh plugin --profile web add github:chenjie1129/remotion-video-plugin#v0.4.0
   dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy
   ```

2. **Create orchestrator skill** (`skills/media-orchestrator/SKILL.md`):
   - Define workflow phases: concept → storyboard → image generation → video composition → QA
   - Each phase calls the appropriate tool and passes artifacts forward
   - Include fallback chains (if one image provider fails, try next)

3. **Create Remotion project template** with:
   - Composition presets: product-launch, social-vertical, data-story
   - Dynamic prop injection from agent
   - Asset loading from workspace-relative paths

4. **Verification pipeline**:
   - Use `dsh-vision-proxy` to describe the rendered video
   - Compare against original prompt intent
   - Flag quality issues (blur, text readability, color consistency)

### Expected Gain
- **Direct:** Automated video production pipeline ($50-500/video on Fiverr)
- **Confidence:** High — community plugins already proven
- **Risk:** Breaking changes in DSH rc versions; Remotion licensing

---

## Project 2: Content Automation Factory — Scheduled Social Assets

### Overview
A fully autonomous content generation system that runs on a schedule (daily/weekly), generates social media assets (images, carousels, short videos), and outputs them ready for upload — complete with captions, hashtags, and posting schedules.

### Architecture

```
Cron Trigger → dsh-automation → Content Agent Session
                  │
                  ▼
        ┌─────────────────┐
        │ Content Planner │  ← Reads topic calendar, trends
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    ▼            ▼            ▼
┌───────┐  ┌─────────┐  ┌──────────┐
│Image  │  │Caption  │  │Hashtag   │
│Gen    │  │Writer   │  │Optimizer │
└───┬───┘  └────┬────┘  └────┬─────┘
    │           │            │
    └───────────┴────────────┘
                │
                ▼
        ┌───────────────┐
        │ Asset Package │  ← Zipped folder with all assets + metadata
        └───────────────┘
```

### Components

| Component | Plugin / Tool | Purpose |
|-----------|--------------|---------|
| Scheduler | `dsh-automation` | Cron-like task scheduling |
| Image Gen | `dsh-image-gen` | Generate social media images |
| Video Gen | `remotion-video-plugin` | Generate short-form videos |
| Research | `dsh-plugin-browser` | Scrape trends, news, competitor content |
| Output | Custom skill | Package assets with metadata JSON |

### Content Types

1. **Instagram Carousels** — 5-10 slides with consistent design system
2. **YouTube Shorts / TikTok** — 15-60 second vertical videos
3. **Twitter/X Threads** — Text + generated header images
4. **LinkedIn Posts** — Professional graphics with data visualizations

### Example Schedule

```yaml
# automation-config.yml
content_factory:
  instagram_carousel:
    schedule: "0 9 * * 1"  # Every Monday 9am
    topic_source: "trending_tech_news"
    slides: 7
    style: "dark_minimal"
  
  youtube_short:
    schedule: "0 14 * * 3,5"  # Wed/Fri 2pm
    duration: 30
    topic_source: "productivity_tips"
    format: "vertical_captioned"
  
  linkedin_post:
    schedule: "0 8 * * 2"  # Tuesday 8am
    topic_source: "industry_analysis"
    include_chart: true
```

### Implementation Steps

1. **Install automation plugin:**
   ```bash
   dsh plugin --profile web add github:titanwings/dsh-automation
   ```

2. **Create content calendar skill** that:
   - Reads a topic database (JSON/YAML)
   - Uses `dsh-plugin-browser` to scrape trending topics
   - Generates content briefs with target audience, key message, CTA

3. **Create design system skill** with:
   - Brand colors, fonts, layout templates
   - Remotion composition presets for each platform
   - Asset naming conventions

4. **Create packaging skill** that:
   - Collects all generated assets
   - Writes `metadata.json` with captions, hashtags, suggested posting time
   - Creates ZIP for manual review or direct upload

### Integration with Better DeepSeek

Use Better DeepSeek's **DeepCode mode** to:
1. Plan the content strategy (topics, angles, posting schedule)
2. Transfer the plan to DSH via `dsh-better-deepseek` plugin
3. DSH executes the full pipeline autonomously

### Expected Gain
- **Direct:** Automated social media management service ($500-2000/month per client)
- **Confidence:** High — all components exist; integration is the work
- **Risk:** Content quality requires tuning; platform API changes

---

## Project 3: Interactive Brand Studio — Real-Time Visual Iteration

### Overview
A DSH-powered creative studio where you describe a brand concept in natural language, and the agent iteratively generates logo variations, color palettes, mockups, and brand guidelines — with you approving or rejecting each iteration until it's perfect.

### Architecture

```
User: "Create a brand for a sustainable coffee shop called 'Grounded'"

DSH Agent → Brand Concept Skill
    │
    ▼
┌─────────────────┐
│ Mood Board Gen  │ ← 5-10 inspirational images
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Logo Iteration  │ ← 6 variations, user picks 2
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Color Palette   │ ← Extracted + generated harmonics
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Mockup Render   │ ← Business cards, packaging, storefront
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Brand Guidelines│ ← PDF with all specs
└─────────────────┘
```

### Components

| Component | Plugin / Tool | Purpose |
|-----------|--------------|---------|
| Image Gen | `dsh-image-gen` | Logo concepts, mood boards, mockups |
| Vision QA | `dsh-vision-proxy` | Describe and critique generated images |
| Browser | `dsh-plugin-browser` | Reference competitor brands, trend research |
| Document | Better DeepSeek native | Generate PPTX/DOCX brand guidelines |
| Versioning | Custom skill | Track iterations, branching concepts |

### Interactive Workflow

```
[User] "Create a brand for 'Grounded' — sustainable coffee, earthy tones"
    │
    ▼
[Agent] Generates 6 logo concepts + mood board
    │
    ▼
[User] "I like concepts 2 and 4. Make 4 more variations of each."
    │
    ▼
[Agent] Generates 8 new variations + color palettes for each direction
    │
    ▼
[User] "Direction 2-B is best. Now create mockups: packaging, storefront, menu."
    │
    ▼
[Agent] Generates mockups + writes brand guidelines document
```

### Implementation Steps

1. **Install required plugins:**
   ```bash
   dsh plugin --profile web add github:shanliuling/dsh-image-gen
   dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy
   dsh plugin --profile web add github:xu1132/dsh-plugin-browser
   ```

2. **Create brand iteration skill** with:
   - `brand_concept_generate` — Generate initial concepts from brief
   - `brand_iterate` — Take user feedback, generate variations
   - `brand_critique` — Use vision proxy to self-evaluate against brief
   - `brand_package` — Compile final assets + guidelines

3. **Create feedback loop protocol**:
   - Each generation includes a `critique` call (vision proxy describes the image)
   - Agent compares critique against original brief
   - If mismatch > threshold, auto-retry with adjusted prompt

4. **Guidelines generator** using Better DeepSeek's PPTX tool:
   - Brand story, mission, vision
   - Color specs (hex, RGB, CMYK, Pantone)
   - Typography rules
   - Logo usage do's and don'ts
   - Voice and tone guidelines

### Expected Gain
- **Direct:** Brand design service ($1000-5000 per brand package)
- **Confidence:** Medium-High — image gen proven; iteration UX needs design
- **Risk:** Logo generation quality varies; may need manual refinement

---

## Local Setup Guide

### Prerequisites
- Node.js 22+ (check with `node --version`)
- pnpm (`npm install -g pnpm`)
- Git
- DeepSeek API key ([platform.deepseek.com](https://platform.deepseek.com))

### Step 1: Install DeepSeek Harness

```bash
# Option A: Run from npm (quickest)
npx @deepseek-ai/dsh web

# Option B: Run from source
git clone https://github.com/deepseek-ai/deepseek-harness.git
cd deepseek-harness
pnpm install
pnpm run build
pnpm dsh web
```

The Web UI starts at `http://127.0.0.1:3080` by default.

### Step 2: Configure API Key

Create `.env` in the repo root or export:
```bash
export DEEPSEEK_API_KEY="sk-..."
```

### Step 3: Install Better DeepSeek Plugin for DSH

```bash
dsh plugin --profile web add git+https://github.com/silencieuxzero/Better_Deepseek_Harness.git
```

Or install Better DeepSeek browser extension from Chrome Web Store for the chat interface.

### Step 4: Install Media Generation Plugins

```bash
# Image generation (most popular, 133 stars)
dsh plugin --profile web add github:shanliuling/dsh-image-gen

# Video generation (Remotion-based)
dsh plugin --profile web add github:chenjie1129/remotion-video-plugin#v0.4.0

# Vision bridge (for QA)
dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy

# Browser automation
dsh plugin --profile web add github:xu1132/dsh-plugin-browser

# Scheduling
dsh plugin --profile web add github:titanwings/dsh-automation
```

### Step 5: Verify Installation

```bash
dsh doctor
dsh --profile web --dump-config
```

You should see all plugins mounted in the Cordis config dump.

### Step 6: Test with a Media Prompt

Start a session in the Web UI and try:
```
"Generate an image of a futuristic coffee shop interior, 
then describe what you see to verify it rendered correctly."
```

---

## References & Sources

### Official
- [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) — Official repo
- [DeepSeek API Docs](https://platform.deepseek.com)
- [Cordis Framework](https://github.com/cordiverse/cordis)

### Community Plugins (Primary Sources)
- [shanliuling/dsh-image-gen](https://github.com/shanliuling/dsh-image-gen) — 133⭐ image generation
- [chenjie1129/remotion-video-plugin](https://github.com/chenjie1129/remotion-video-plugin) — Video generation
- [titanwings/dsh-automation](https://github.com/titanwings/dsh-automation) — Task scheduling
- [PerryLink/dsh-background-agents](https://github.com/PerryLink/dsh-background-agents) — Background agents
- [xu1132/dsh-plugin-browser](https://github.com/xu1132/dsh-plugin-browser) — Browser automation
- [Flyvhidbwo/dsh-vision-proxy](https://github.com/Flyvhidbwo/dsh-vision-proxy) — Vision bridge

### Better DeepSeek
- [EdgeTypE/better-deepseek](https://github.com/EdgeTypE/better-deepseek) — Browser extension
- [silencieuxzero/Better_Deepseek_Harness](https://github.com/silencieuxzero/Better_Deepseek_Harness) — DSH plugin

### Awesome Lists & Directories
- [Anil-matcha/awesome-dsh-plugin](https://github.com/Anil-matcha/awesome-dsh-plugin)
- [0xsline/awesome-deepseek-harness](https://github.com/0xsline/awesome-deepseek-harness)
- [ywsldxk/dsh-plugin-stars](https://github.com/ywsldxk/dsh-plugin-stars) — Star leaderboard
- [Zhiyuan-Fan/Awesome-DeepSeek-Harness-Plugins](https://github.com/Zhiyuan-Fan/Awesome-DeepSeek-Harness-Plugins)

### Community Discussions
- [Remotion Video Plugin Discussion #3861](https://github.com/deepseek-ai/deepseek-harness/discussions/3861)
- [Five Community Projects Discussion #655](https://github.com/deepseek-ai/deepseek-harness/discussions/655)
- [dsh-plugin-hello & dsh-plugin-browser Discussion #714](https://github.com/deepseek-ai/deepseek-harness/discussions/714)

### Related Research
- [HenryZ838978/deepseek-harness](https://github.com/HenryZ838978/deepseek-harness) — Community protocol harness (pre-official)
- [Pace: Agentic Capability Evaluation](https://arxiv.org/html/2607.02032v1) — Academic benchmark including DeepSeek V4

---

## Contributing

This is a living document. As the DSH ecosystem evolves, projects will be updated:

1. Fork this repo
2. Create a project branch
3. Update specs with new plugin versions
4. Submit a PR with evidence (screenshots, test outputs, demo videos)

---

## License

MIT — Same as DeepSeek Harness

---

> **Last Updated:** 2026-08-22  
> **DSH Version Targeted:** 0.1.0-rc.6+  
> **Better DeepSeek Version:** 0.1.12+
