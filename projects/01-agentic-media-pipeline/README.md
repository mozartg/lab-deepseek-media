# Project 1: Agentic Media Pipeline

## Status: 🟡 Spec Complete → Ready for Implementation

---

## One-Liner
Give DeepSeek Harness a complete media creation workflow: generate images, animate them into videos, and verify quality — all through natural language.

## Why This Project

**Market gap:** Video production is expensive ($50-500 per video on Fiverr). AI can automate the pipeline but current tools require technical setup. DSH + plugins makes it conversational.

**Technical feasibility:** HIGH. All core plugins exist and are verified.

## Architecture

```
User Prompt
    │
    ▼
┌─────────────────────────────────────┐
│  Media Orchestrator Skill           │
│  (Custom SKILL.md + Cordis config)  │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┐
    ▼          ▼          ▼
┌───────┐ ┌─────────┐ ┌──────────┐
│Concept│ │Storyboard│ │  Asset   │
│ Phase │ │  Phase   │ │  Phase   │
└───┬───┘ └────┬────┘ └────┬─────┘
    │          │           │
    ▼          ▼           ▼
┌─────────────────────────────────────┐
│         TOOL EXECUTION LAYER        │
│  ┌─────────┐ ┌──────────┐ ┌──────┐ │
│  │dsh-image│ │ remotion │ │dsh-  │ │
│  │  -gen   │ │ -video   │ │vision│ │
│  └────┬────┘ └────┬─────┘ └──┬───┘ │
│       │           │          │     │
│       ▼           ▼          ▼     │
│    [PNG]      [MP4]      [Report]  │
└─────────────────────────────────────┘
```

## Plugin Stack

| # | Plugin | Install Command | Role |
|---|--------|----------------|------|
| 1 | `dsh-image-gen` | `dsh plugin --profile web add github:shanliuling/dsh-image-gen` | Generate images via Gemini/OpenAI/Seedream |
| 2 | `remotion-video-plugin` | `dsh plugin --profile web add github:chenjie1129/remotion-video-plugin#v0.4.0` | Render React-based videos |
| 3 | `dsh-vision-proxy` | `dsh plugin --profile web add github:Flyvhidbwo/dsh-vision-proxy` | Verify media quality |
| 4 | `dsh-plugin-browser` | `dsh plugin --profile web add github:xu1132/dsh-plugin-browser` | Fetch reference images, stock assets |

## Skill Definition

Create `skills/media-orchestrator/SKILL.md`:

```markdown
# Media Orchestrator

## Workflow

### Phase 1: Concept Extraction
- Parse user prompt for: topic, duration, style, platform, audience
- Output: structured brief JSON

### Phase 2: Storyboard Generation
- Generate 5-10 scene descriptions
- For each scene: call `generate_image` with detailed prompt
- Output: array of {scene_id, description, image_path}

### Phase 3: Video Composition
- Call `remotion_list_compositions` to verify project
- Call `remotion_render_video` with scene array as props
- Output: video_path, metadata

### Phase 4: Quality Verification
- Call `remotion_probe_output` for technical specs
- Call `dsh-vision-proxy` to describe rendered video
- Compare description against original brief
- Output: quality_report

## Fallback Chain
- If image provider A fails → try provider B → try provider C
- If video render fails → try lower resolution → try shorter duration
- If quality check fails → regenerate flagged scenes
```

## Remotion Project Template

```typescript
// remotion-templates/social-vertical.tsx
import {Composition, staticFile} from 'remotion';
import {SocialVertical} from './SocialVertical';

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="SocialVertical"
      component={SocialVertical}
      durationInFrames={900} // 30s at 30fps
      fps={30}
      width={1080}
      height={1920}
      defaultProps={{
        scenes: [], // injected by agent
        captions: [],
        musicUrl: '',
      }}
    />
  );
};
```

## Example Conversations

### Example 1: Product Video
```
User: Create a 30-second product launch video for a cold brew 
      coffee brand called "Dark Roast".

Agent: I'll create a product launch video for Dark Roast. Let me 
       start by generating the visual assets and storyboard.
       
       [Phase 1] Concept: Premium cold brew, target: millennials, 
       style: dark & moody, platform: Instagram Reels
       
       [Phase 2] Generating 6 scene images...
       ✓ Scene 1: Hero shot of bottle (generated)
       ✓ Scene 2: Pouring shot (generated)
       ✓ Scene 3: Coffee beans close-up (generated)
       ...
       
       [Phase 3] Rendering video via Remotion...
       ✓ Video rendered: workspace/dark-roast-launch.mp4
       
       [Phase 4] Quality check...
       ✓ Vision analysis: "Video shows premium cold brew product 
         with dark aesthetic, text overlays are readable"
       ✓ Technical: 1080x1920, 30fps, H.264, 12MB
       
       Your video is ready! Preview: [link]
```

### Example 2: Educational Content
```
User: Make a 60-second explainer about photosynthesis for kids.

Agent: Creating an educational video about photosynthesis. 
       I'll use bright, friendly visuals and simple captions.
       
       [Generating 8 animated scenes with plant diagrams...]
       [Rendering at 720p for faster turnaround...]
       
       Your explainer video is ready: workspace/photosynthesis-kids.mp4
```

## Cost Estimates

| Component | Cost Per Run |
|-----------|-------------|
| DeepSeek V4-Pro (reasoning + tool calls) | ~$0.02-0.10 |
| Image generation (6 images @ Gemini) | ~$0.06-0.30 |
| Video rendering (Remotion, self-hosted) | ~$0 (compute only) |
| **Total per 30s video** | **~$0.10-0.50** |

Compare to: Fiverr video editor $50-500 per video

## Implementation Checklist

- [ ] Install all 4 plugins and verify with `dsh doctor`
- [ ] Create `skills/media-orchestrator/` directory and SKILL.md
- [ ] Create Remotion template project with 3 presets
- [ ] Write orchestrator Cordis config (`cordis.yml`)
- [ ] Test with 5 different prompt types
- [ ] Add quality verification thresholds
- [ ] Document fallback chain behavior
- [ ] Create demo video of the workflow

## Next Steps

1. **Start here:** Install plugins and run a simple "generate image → describe image" test
2. **Then:** Add Remotion and render a single-scene video
3. **Finally:** Wire the full orchestrator skill with all 4 phases

## Traceability

| Field | Value |
|-------|-------|
| **Source** | GitHub community plugins + official DSH examples |
| **Expected Gain** | $50-500/video production at ~$0.50 cost |
| **Risk** | DSH breaking changes; Remotion licensing for commercial use |
| **Confidence** | HIGH — all plugins verified by community |
