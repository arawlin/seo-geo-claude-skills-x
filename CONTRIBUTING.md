# Contributing

Thanks for your interest in contributing! This guide covers adding skills, improving existing ones, and submitting changes.

## Requesting a Skill

[Open a Skill Request issue](https://github.com/aaron-he-zhu/seo-geo-claude-skills/issues/new?template=skill-request.yml) if you have an idea but don't want to build it yourself.

## Adding a New Skill

### 1. Choose the correct category

| Category | Directory | Use when the skill... |
|----------|-----------|----------------------|
| Research | `research/` | Gathers market data before content creation |
| Build | `build/` | Creates new content or markup |
| Optimize | `optimize/` | Improves existing content or site health |
| Monitor | `monitor/` | Tracks performance over time |
| Cross-cutting | `cross-cutting/` | Spans multiple phases (quality frameworks, entity, memory) |

### 2. Create the skill directory

```bash
mkdir -p <category>/<skill-name>
```

Directory name: 1-64 chars, lowercase `a-z`, numbers, hyphens only. No leading/trailing/consecutive hyphens.

### 3. Create `SKILL.md` with required frontmatter

```yaml
---
name: your-skill-name
version: "1.0.0"
description: 'Use when the user asks to "[trigger]". [What it does]. For [related task], see [other-skill].'
license: Apache-2.0
compatibility: "Claude Code ≥1.0, skills.sh marketplace, ClawHub marketplace, Vercel Labs skills ecosystem."
metadata:
  author: your-github-username
  version: "1.0.0"
  geo-relevance: "high|medium|low"
  tags: [seo, your-tags]
  triggers: ["trigger phrase 1", "trigger phrase 2"]
---
```

The `name` field must match the directory name exactly.

### 4. Write effective instructions

Include: When to Use, What It Does, How to Use, Data Sources (`~~placeholders`), Instructions, Validation Checkpoints, Example, Related Skills. Keep under 350 lines; put detailed references in `references/` subdirectory.

### 5. Validate

```bash
./scripts/validate-skill.sh <category>/<skill-name>
```

### 6. Update tracking files

After adding or updating a skill, keep these 5 files in sync:
- `VERSIONS.md` — version and date
- `.claude-plugin/plugin.json` — skills array
- `marketplace.json` (repo root) — must match plugin.json; copy to `.claude-plugin/marketplace.json` afterward
- `README.md` — skills table
- `CLAUDE.md` — category table

## Improving Existing Skills

Keep changes focused. Bump `metadata.version`. Update `VERSIONS.md`. Put new reference docs in the skill's `references/` subdirectory.

## Quality Checklist

Before submitting a PR:

- [ ] `name` matches directory name (satisfies ClawHub slug `^[a-z0-9][a-z0-9-]*$`)
- [ ] `description` includes trigger phrases AND scope boundaries (≤1024 chars)
- [ ] SKILL.md body under 350 lines; detail in `references/`
- [ ] Validator passes: `./scripts/validate-skill.sh <category>/<skill-name>`
- [ ] Uses `~~placeholder` pattern for tool references
- [ ] `allowed-tools: WebFetch` added if skill fetches live URLs
- [ ] Includes validation checkpoints and at least one example
- [ ] All 5 tracking files updated; plugin.json and marketplace.json arrays identical
- [ ] `.claude-plugin/marketplace.json` byte-identical to repo-root copy

## Submitting

1. Fork, create `feature/your-skill-name` branch, submit PR
2. After merge, publish to ClawHub: `clawhub publish` or `clawhub sync`

## Code of Conduct

Be respectful, constructive, and focused on making the library better for everyone.
