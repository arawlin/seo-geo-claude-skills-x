---
name: article-batch-generator
description: 'Use when the user asks to "generate a full article series", "draft every article from a series plan", or "batch write articles into a directory". Produces article files from a normalized series plan by chaining writing, GEO optimization, metadata, schema, internal linking, and final content audit. For one article only, see seo-content-writer. 批量文章生成/系列文章批处理'
version: "9.2.0"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when turning a completed series plan into drafted article files. Also when the user wants all article assets written to a directory with shared internal links and final quality checks."
argument-hint: "<series-plan.json> [output_dir=\"...\"]"
metadata:
  author: aaron-he-zhu
  version: "9.2.0"
  geo-relevance: "high"
  tags:
    - seo
    - geo
    - batch-writing
    - content-series
    - internal-linking
    - content-audit
    - 批量写作
    - 系列文章
  triggers:
    - "generate a full article series"
    - "batch write articles"
    - "draft every article from a series plan"
    - "article batch generator"
    - "批量生成文章"
    - "系列文章批处理"
    - "批量写作"
---

# Article Batch Generator

This skill turns a completed series plan into a finished article set. It drafts
each article, runs shared post-draft optimization, applies series-level
internal linking, and finishes with per-article quality gates.

## When This Must Trigger

Use this skill after research is complete and a series plan already exists:

- The article list is approved and drafting should start
- All article files need to land in one output directory
- Internal links must be planned across the full set, not one article at a time
- Each article needs a final `content-quality-auditor` pass before handoff

## Quick Start

Start with one of these prompts:

```text
Generate all articles from ./content/topic/00-series-plan.json
```

```text
Draft a 5-article series into ./content/topic/articles
```

Expected output:

- `articles/NN-slug.md` for each planned article
- updated internal links across the batch
- one batch summary for `series-finalizer`

## Skill Contract

**Expected output**: a batch of article files with metadata, schema,
cross-links, and final audit status.

- **Reads**: `00-series-plan.json`, article requirements, stage blockers, and
  any existing draft files in the target directory.
- **Writes**: `articles/NN-slug.md`, a batch status summary, and any draft audit
  notes required by the finalizer.
- **Promotes**: validated cross-link relationships, final audit states, and
  missing assets into batch outputs, not memory.
- **Next handoff**: use `series-finalizer` when all article files and audits are
  complete.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Articles Written**: count of generated files
- **Audit Failures**: list of any files still marked `DONE_WITH_CONCERNS`

## Instructions

Run this phase in three blocks.

### Block A — Per-article drafting

For each article in `00-series-plan.json`:

1. Invoke `seo-content-writer`.
2. Invoke `geo-content-optimizer`.
3. Invoke `meta-tags-optimizer`.
4. Invoke `schema-markup-generator`.
5. Save the result as `articles/NN-slug.md`.

Each article file must include:

- frontmatter with title, slug, keywords, meta fields, audit placeholders
- full article body
- FAQ when the plan or source skills call for it
- `JSON-LD`
- a section for internal link updates
- a section for audit summary

### Block B — Batch-level linking

After all article drafts exist:

1. Invoke `internal-linking-optimizer` once across the full set.
2. Update each article's internal links using the full inventory, not partial
   inventory.
3. Record which source article links to which target article and which anchor
   text was chosen.

Do not run `internal-linking-optimizer` inside the per-article drafting loop.

### Block C — Final per-article audit

For each article after linking updates:

1. Invoke `content-quality-auditor`.
2. If the verdict is `FIX` and the issue is resolvable in one pass, revise once
   and rerun the audit.
3. If the article still fails after one revision, mark the file
   `DONE_WITH_CONCERNS` and surface the blocker in the batch summary.

## Validation Checkpoints

- [ ] Every article in `00-series-plan.json` has a corresponding `articles/NN-slug.md`
- [ ] `internal-linking-optimizer` ran after all drafts existed
- [ ] Every article includes title, meta description, schema, and audit summary
- [ ] Final status for each article is `DONE` or `DONE_WITH_CONCERNS`
- [ ] Batch summary lists any unresolved blockers clearly

## Reference Materials

- [seo-content-writer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/seo-content-writer/SKILL.md)
- [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md)
- [meta-tags-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/meta-tags-optimizer/SKILL.md)
- [schema-markup-generator](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/schema-markup-generator/SKILL.md)
- [internal-linking-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/optimize/internal-linking-optimizer/SKILL.md)
- [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)

## Next Best Skill

Primary: [series-finalizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/series-finalizer/SKILL.md)
— use when all article files exist and the batch summary is complete. Stop if
article generation is still `BLOCKED` or the plan is incomplete.
