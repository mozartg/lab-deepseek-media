# Project 2: Content Automation Factory

## Status: 🟡 Spec Complete → Ready for Implementation

---

## One-Liner
An autonomous content generation system that runs on a schedule, creates social media assets (images, carousels, short videos), and packages them with captions, hashtags, and posting metadata.

## Why This Project

**Market gap:** Social media management agencies charge $500-2000/month per client. Most of the work is repetitive: find topics, create visuals, write copy, schedule posts. An agent can do this autonomously.

**Technical feasibility:** HIGH. Scheduling + generation + packaging are all solved problems in the DSH ecosystem.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SCHEDULER (dsh-automation)                │
│  Cron: "0 9 * * 1" → Trigger Monday 9am                      │
│  Cron: "0 14 * * 3,5" → Trigger Wed/Fri 2pm                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              CONTENT AGENT SESSION (Fresh)                   │
│                                                              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────┐  │
│  │ Topic       │───▶│ Content     │───▶│ Asset           │  │
│  │ Research    │    │ Brief       │    │ Generation      │  │
│  │ (browser)   │    │ (agent)     │    │ (image/video)   │  │
│  └─────────────┘    └─────────────┘    └────────┬────────┘  │
│                                                  │          │
│  ┌─────────────┐    ┌─────────────┐              │          │
│  │ Caption     │◀───│ Hashtag     │◀─────────────┘          │
│  │ Writer      │    │ Optimizer   │                         │
│  └──────┬──────┘    └──────┬──────┘                         │
│         │                  │                                │
│         └──────────┬───────┘                                │
│                    ▼                                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              PACKAGING SKILL                         │   │
│  │  • Collect all assets                                │   │
│  │  • Write metadata.json (captions, hashtags, time)    │   │
│  │  • Create ZIP for review                             │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Plugin Stack

| # | Plugin | Install Command | Role |
|---|--------|----------------|------|
| 1 | `dsh-automation` | `dsh plugin --profile web add github:titanwings/dsh-automation` | Cron scheduling |
| 2 | `dsh-image-gen` | `dsh plugin --profile web add github:shanliuling/dsh-image-gen` | Generate images |
| 3 | `remotion-video-plugin` | `dsh plugin --profile web add github:chenjie1129/remotion-video-plugin#v0.4.0` | Short videos |
| 4 | `dsh-plugin-browser` | `dsh plugin --profile web add github:xu1132/dsh-plugin-browser` | Trend research |
| 5 | `dsh-background-agents` | `dsh plugin --profile web add github:PerryLink/dsh-background-agents` | Parallel tasks |

## Content Types

### 1. Instagram Carousel
```yaml
format: carousel
slides: 7
size: 1080x1080
style: dark_minimal
topics:
  - tech_news
  - productivity_hacks
  - industry_trends
```

### 2. YouTube Short / TikTok
```yaml
format: vertical_video
duration: 30s
size: 1080x1920
style: captioned_b-roll
topics:
  - quick_tips
  - myth_busting
  - behind_the_scenes
```

### 3. LinkedIn Post
```yaml
format: single_image
size: 1200x627
style: professional_data
include_chart: true
topics:
  - industry_analysis
  - company_updates
  - thought_leadership
```

### 4. Twitter/X Thread
```yaml
format: thread
posts: 5-8
header_image: true
topics:
  - hot_takes
  - explainers
  - polls
```

## Automation Config

Create `config/content-factory.yml`:

```yaml
content_factory:
  name: "Mozart's Content Machine"
  
  instagram_carousel:
    enabled: true
    schedule: "0 9 * * 1"  # Every Monday 9am ET
    topic_source: trending_tech
    slides: 7
    style: dark_minimal
    brand_colors: ["#1a1a1a", "#f5f5f5", "#00d4aa"]
    output_dir: ./output/instagram
  
  youtube_short:
    enabled: true
    schedule: "0 14 * * 3,5"  # Wed/Fri 2pm ET
    topic_source: productivity_tips
    duration: 30
    style: vertical_captioned
    output_dir: ./output/shorts
  
  linkedin_post:
    enabled: true
    schedule: "0 8 * * 2"  # Tuesday 8am ET
    topic_source: industry_analysis
    include_chart: true
    output_dir: ./output/linkedin
  
  twitter_thread:
    enabled: true
    schedule: "0 10 * * 1,4"  # Mon/Thu 10am ET
    topic_source: hot_takes
    output_dir: ./output/twitter

topic_sources:
  trending_tech:
    - rss: https://techcrunch.com/feed/
    - scrape: https://news.ycombinator.com/
    - search: "AI news this week"
  
  productivity_tips:
    - rss: https://www.producthunt.com/feed
    - curated: ./data/productivity-topics.json
  
  industry_analysis:
    - rss: https://www.cbinsights.com/research/feed
    - scrape: https://www.crunchbase.com/
```

## Skill: Content Research

```markdown
# Content Research Skill

## Inputs
- topic_source (string): Key into content-factory.yml topic_sources
- count (number): How many topics to return

## Workflow
1. Call `browser_navigate` to visit RSS feed
2. Call `browser_snapshot` to extract headlines
3. Agent ranks headlines by relevance and novelty
4. Returns top N topics with suggested angles

## Output
```json
[
  {
    "topic": "OpenAI's new model release",
    "angle": "What this means for solopreneurs",
    "source": "TechCrunch",
    "confidence": 0.92
  }
]
```
```

## Skill: Asset Packager

```markdown
# Asset Packager Skill

## Inputs
- content_type (string): instagram_carousel | youtube_short | linkedin_post | twitter_thread
- assets (array): Paths to generated files
- brief (object): Original content brief

## Workflow
1. Read all asset files
2. Generate captions using agent reasoning
3. Generate hashtags (mix of popular + niche)
4. Suggest optimal posting time
5. Write metadata.json
6. Create ZIP archive

## Output Structure
```
output/2026-08-25_instagram-carousel/
├── slide-01.png
├── slide-02.png
├── ...
├── slide-07.png
└── metadata.json
```

## metadata.json
```json
{
  "content_type": "instagram_carousel",
  "created_at": "2026-08-25T09:00:00Z",
  "topic": "AI Tools for Content Creators",
  "caption": "7 AI tools that will 10x your content output...",
  "hashtags": ["#AI", "#ContentCreation", "#Productivity"],
  "suggested_post_time": "2026-08-26T12:00:00Z",
  "slides": [
    {"file": "slide-01.png", "text": "Hook: Stop doing this manually"},
    {"file": "slide-02.png", "text": "Tool 1: ChatGPT for ideation"}
  ]
}
```
```

## Better DeepSeek Integration

Use DeepCode mode in Better DeepSeek to:

1. **Plan the content strategy** (in browser chat):
   ```
   User: "Plan a week's worth of content for my tech newsletter
          audience. Focus on AI productivity tools."
   
   BDS DeepCode: Generates a 7-day content calendar with topics,
                 angles, and platform distribution.
   ```

2. **Transfer to DSH** (via `dsh-better-deepseek` plugin):
   ```
   BDS: "Transferring plan to DeepSeek Harness for execution..."
   
   DSH: Receives the plan as a structured task, creates sessions
        for each content piece, runs them on schedule.
   ```

3. **Review outputs** (back in BDS):
   ```
   DSH: "All 7 assets generated. Preview links: [...]"
   
   BDS: Renders image previews in chat for quick review.
   ```

## Cost Estimates (Weekly)

| Component | Cost |
|-----------|------|
| DSH scheduling + agent runs (7 tasks) | ~$0.50-2.00 |
| Image generation (~20 images) | ~$0.20-1.00 |
| Video generation (~4 shorts) | ~$0 (compute) |
| **Total weekly** | **~$0.70-3.00** |

Compare to: Social media agency $500-2000/month

## Implementation Checklist

- [ ] Install `dsh-automation` and test basic scheduling
- [ ] Create `config/content-factory.yml` with your brands
- [ ] Create `skills/content-research/SKILL.md`
- [ ] Create `skills/asset-packager/SKILL.md`
- [ ] Create Remotion templates for each content type
- [ ] Test full pipeline: trigger → research → generate → package
- [ ] Verify ZIP output and metadata.json format
- [ ] Set up review workflow (manual approval before "posting")

## Next Steps

1. **Start here:** Install `dsh-automation` and schedule a simple "hello world" task
2. **Then:** Add image generation and create one carousel manually
3. **Finally:** Wire the full factory with all 4 content types

## Traceability

| Field | Value |
|-------|-------|
| **Source** | GitHub community plugins + DSH scheduling examples |
| **Expected Gain** | $500-2000/month agency work at ~$3/week cost |
| **Risk** | Content quality needs tuning; platform algorithm changes |
| **Confidence** | HIGH — scheduling + generation are proven separately |
