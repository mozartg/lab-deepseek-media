# Contributing to DeepSeek Harness Media Lab

Thank you for helping push the DSH media generation ecosystem forward!

## How to Contribute

### 1. Report Your Experiments

The fastest way to contribute is to **try a project and report what happened**:

- What worked?
- What broke?
- What plugins needed tweaks?
- What prompts worked best?

Open an issue with the label `experiment-report`.

### 2. Add Project Variations

Have an idea for a 4th project? Fork and add it:

```bash
git clone https://github.com/mozartg/deepseek-harness-media-lab.git
cd deepseek-harness-media-lab

# Create your project
cp -r projects/01-agentic-media-pipeline projects/04-your-idea
# Edit, test, commit

git checkout -b project-4-your-idea
git add .
git commit -m "Add Project 4: [Your Idea]"
git push origin project-4-your-idea
```

Then open a Pull Request.

### 3. Improve Existing Projects

- Better prompt templates
- More efficient workflows
- Additional plugin integrations
- Cost optimization strategies
- Demo videos / screenshots

### 4. Update Plugin Info

The DSH ecosystem moves fast. If a plugin link breaks or a better alternative emerges, update the docs:

- `README.md` — Community Plugin Ecosystem table
- Individual project READMEs — Plugin Stack tables
- `QUICKSTART.md` — Setup instructions

## Project Template

When adding a new project, follow this structure:

```
projects/XX-project-name/
├── README.md          # Main project spec (required)
├── cordis.yml         # Cordis config for the project (if applicable)
├── skills/            # Custom SKILL.md files
│   └── skill-name/
│       └── SKILL.md
├── templates/         # Templates (Remotion, image prompts, etc.)
└── demos/             # Demo outputs, screenshots, videos
```

### README.md Template

See any existing project README for the format. Must include:

- One-liner description
- Architecture diagram
- Plugin stack table
- Skill definitions
- Example conversations
- Cost estimates
- Implementation checklist
- Traceability fields (source, expected gain, risk, confidence)

## Code of Conduct

- Be respectful in issues and PRs
- Credit original plugin authors
- Share failures as openly as successes — that's where the learning is
- Keep claims evidence-based ("I tested this" > "This should work")

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
