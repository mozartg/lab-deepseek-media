# Project 3: Interactive Brand Studio

## Status: 🟡 Spec Complete → Ready for Implementation

---

## One-Liner
A conversational brand design studio: describe your brand concept, and the agent iteratively generates logos, color palettes, mockups, and brand guidelines — with you steering each iteration.

## Why This Project

**Market gap:** Brand design packages cost $1000-5000. The back-and-forth with designers takes weeks. An interactive agent can compress this to hours, with the user in full creative control.

**Technical feasibility:** MEDIUM-HIGH. Image generation works well; iteration UX requires careful skill design.

## Architecture

```
User: "Create a brand for 'Grounded' — sustainable coffee, earthy tones"
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│              BRAND CONCEPT SKILL                             │
│                                                              │
│  Extracts from prompt:                                       │
│  • Brand name: "Grounded"                                    │
│  • Industry: Coffee / Food & Beverage                        │
│  • Values: Sustainability, earthiness, community             │
│  • Mood: Warm, natural, approachable                         │
│  • Visual refs: (fetched via browser)                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              MOOD BOARD PHASE                                │
│                                                              │
│  Generate 8-10 inspirational images:                         │
│  • Coffee farm landscapes                                    │
│  • Sustainable packaging examples                            │
│  • Earthy color palettes in nature                           │
│  • Typography inspiration                                    │
│                                                              │
│  User feedback: "I love images 2, 5, and 7. More like that." │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              LOGO ITERATION PHASE                            │
│                                                              │
│  Generate 6 logo concepts:                                   │
│  • 2 wordmark-focused                                        │
│  • 2 icon + wordmark                                         │
│  • 2 abstract mark                                           │
│                                                              │
│  User: "I like concept 3 and 5. Make variations of both."    │
│                                                              │
│  Generate 8 more (4 each direction):                         │
│  • Direction A: Tree root + coffee cup (from concept 3)      │
│  • Direction B: Earth + steam (from concept 5)               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              COLOR & TYPE PHASE                              │
│                                                              │
│  Extract palette from chosen logo direction:                 │
│  • Primary: #3D2B1F (dark brown)                            │
│  • Secondary: #8B6914 (golden)                              │
│  • Accent: #4A7C59 (forest green)                           │
│  • Neutral: #F5F0E8 (cream)                                 │
│                                                              │
│  Generate color applications:                                │
│  • Light mode, dark mode, accent variations                  │
│                                                              │
│  Typography recommendations:                                 │
│  • Headline: Playfair Display (serif, warm)                 │
│  • Body: Inter (clean, readable)                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              MOCKUP PHASE                                    │
│                                                              │
│  Generate application mockups:                               │
│  • Business cards (front + back)                             │
│  • Coffee cups / packaging                                   │
│  • Storefront signage                                        │
│  • Menu design                                               │
│  • Social media profile kit                                  │
│  • Merchandise (tote bag, t-shirt)                           │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              BRAND GUIDELINES                                │
│                                                              │
│  Generate comprehensive brand guide:                         │
│  • Brand story & mission                                     │
│  • Logo usage (do's and don'ts with visual examples)         │
│  • Color system (hex, RGB, CMYK, Pantone)                    │
│  • Typography rules                                          │
│  • Photography style                                         │
│  • Voice & tone                                              │
│  • Application examples                                      │
│                                                              │
│  Output: Brand_Guidelines_Grounded.pdf (via BDS PPTX tool)   │
└─────────────────────────────────────────────────────────────┘
```

## Plugin Stack

| # | Plugin | Install Command | Role |
|---|--------|----------------|------|
| 1 | `dsh-image-gen` | `dsh plugin --profile web add github:shanliuling/dsh-image-gen` | Logo concepts, mood boards, mockups |
| 2 | `dsh-vision-proxy` | `dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy` | Self-critique, describe images |
| 3 | `dsh-plugin-browser` | `dsh plugin --profile web add github:xu1132/dsh-plugin-browser` | Competitor research, trend scraping |
| 4 | `better-deepseek` | Browser extension | PPTX/DOCX generation for guidelines |

## Skill: Brand Concept Generator

```markdown
# Brand Concept Generator

## Inputs
- brand_name (string)
- industry (string)
- values (array of strings)
- mood_keywords (array of strings)
- competitor_urls (array, optional)

## Workflow
1. If competitor_urls provided:
   - Call `browser_navigate` for each
   - Call `browser_snapshot` to extract visual identity notes
   - Agent summarizes: "Competitor X uses blue, modern, minimalist"

2. Agent generates brand concept document:
   - Positioning statement
   - Target audience personas
   - Visual direction (3 options)
   - Voice & tone guide

3. Generate mood board images:
   - For each visual direction, generate 3 inspiration images
   - Present as numbered grid

## Output
```json
{
  "brand_name": "Grounded",
  "positioning": "Sustainable coffee for conscious consumers",
  "visual_directions": [
    {
      "id": "A",
      "name": "Earthy Heritage",
      "description": "Warm browns, hand-crafted feel, natural textures",
      "mood_images": ["./mood/A-01.png", "./mood/A-02.png", "./mood/A-03.png"]
    }
  ]
}
```
```

## Skill: Logo Iterator

```markdown
# Logo Iterator

## Inputs
- direction (object): Selected visual direction
- variations (number): How many to generate (default 6)
- style_mix (string): "wordmark", "icon+wordmark", "abstract", or "all"

## Workflow
1. Generate image prompts for each variation:
   - Include brand name
   - Include style keywords from direction
   - Include negative prompts (no gradients, no clip art, etc.)

2. Call `generate_image` for each

3. Call `vision_proxy` to describe each logo:
   - "This logo features a stylized tree root forming a coffee cup..."

4. Present as numbered grid with descriptions

## Iteration Protocol
- User picks 1-2 favorites
- Agent asks: "What specifically do you like?"
- User describes: "I like the font in #2 and the icon in #4"
- Agent generates new batch combining preferred elements

## Output
Directory: `./logos/iteration-N/`
- logo-01.png through logo-06.png
- descriptions.json
```

## Skill: Mockup Generator

```markdown
# Mockup Generator

## Inputs
- logo_path (string): Final selected logo
- color_palette (object): Primary, secondary, accent, neutral
- applications (array): ["business_card", "packaging", "storefront", ...]

## Workflow
1. For each application:
   - Generate mockup image prompt:
     "A photorealistic mockup of a [application] with [logo] 
      and [color_palette], professional product photography"
   
   - Call `generate_image`

2. Collect all mockups into presentation grid

## Applications Supported
- business_card
- letterhead
- packaging (coffee bag, cup)
- storefront_signage
- menu
- social_media_kit (profile, banner, post template)
- merchandise (tote, t-shirt, sticker)
- app_icon

## Output
Directory: `./mockups/`
```

## Better DeepSeek Integration for Guidelines

Use BDS's native PPTX generation for the brand guidelines:

```
User: "Now create the brand guidelines document."

BDS: "I'll generate a comprehensive brand guidelines deck."

[BDS generates PPTX with:]
- Cover slide: "Brand Guidelines — Grounded"
- Mission & Vision
- Logo Usage (with do/don't examples as images)
- Color Palette (swatches with hex codes)
- Typography (font samples)
- Photography Style (example images)
- Voice & Tone (sample copy)
- Application Examples (mockups)

Output: Brand_Guidelines_Grounded.pptx (convertable to PDF)
```

## Iteration UX Design

The key challenge is making the iteration loop feel natural. Here's the conversation flow:

```
[ROUND 1]
Agent: "Here are 6 logo concepts for Grounded. What do you think?"
        [Grid of 6 images]

User: "I like #3 and #5. #3 has a nice font, #5's icon is cool."

[ROUND 2]
Agent: "Got it! Combining the font from #3 with the icon concept 
        from #5. Here are 8 new variations:"
        [Grid of 8 images]

User: "#7 is almost perfect. Can you make the icon bigger and 
        try a darker brown?"

[ROUND 3]
Agent: "Adjusting icon size and color. Here are 4 fine-tuned 
        versions:"
        [Grid of 4 images]

User: "#2 is the one. Let's move to colors."

[COLOR PHASE]
Agent: "Extracting the palette from your chosen logo. Here are 
        color applications:"
        [Light mode, dark mode, accent variations]
```

## Cost Estimates (Per Brand)

| Phase | Images | Est. Cost |
|-------|--------|-----------|
| Mood board | 10 | ~$0.10-0.50 |
| Logo iterations (3 rounds × 6) | 18 | ~$0.20-0.90 |
| Color applications | 6 | ~$0.06-0.30 |
| Mockups (8 applications) | 8 | ~$0.08-0.40 |
| **Total** | **~42** | **~$0.50-2.50** |

Compare to: Brand designer $1000-5000 per package

## Implementation Checklist

- [ ] Install image gen + vision + browser plugins
- [ ] Create `skills/brand-concept-generator/SKILL.md`
- [ ] Create `skills/logo-iterator/SKILL.md`
- [ ] Create `skills/mockup-generator/SKILL.md`
- [ ] Design iteration conversation flow
- [ ] Create prompt templates for each logo style
- [ ] Create negative prompt library (what to avoid)
- [ ] Test with 3 different brand types (coffee, tech, fashion)
- [ ] Document user feedback patterns that work best
- [ ] Create demo video of full brand creation session

## Next Steps

1. **Start here:** Manually test image generation with brand-related prompts
2. **Then:** Create a simple 2-round iteration (generate 6 → pick 2 → generate 4 more)
3. **Finally:** Wire the full studio with all phases and mockups

## Traceability

| Field | Value |
|-------|-------|
| **Source** | GitHub community plugins + BDS PPTX tool + design workflow research |
| **Expected Gain** | $1000-5000 brand package at ~$2.50 cost |
| **Risk** | Logo quality varies; iteration count can grow quickly |
| **Confidence** | MEDIUM-HIGH — image gen works; UX needs tuning |
