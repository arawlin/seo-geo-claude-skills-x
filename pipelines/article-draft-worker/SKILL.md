---
name: article-draft-worker
description: 'Use when article-batch-generator needs to draft one article from a normalized series plan entry in its own dedicated context. Runs writing, screenshot placeholder insertion, GEO optimization, metadata, and schema, then saves one publishable article file. 单篇文章生成worker/独立子上下文'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
context: fork
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when one article from a completed series plan needs to be drafted in isolation from the rest of the batch. Also when article-batch-generator needs one per-article worker invocation that does not crowd the batch context."
argument-hint: "<topic_dir/research/00-series-plan.json> <article_slug_or_order>"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
  geo-relevance: "high"
  tags:
    - seo
    - geo
    - article-worker
    - content-series
    - batch-writing
    - draft-generation
    - 单篇生成
    - 独立上下文
  triggers:
    - "draft one article from a series plan"
    - "article draft worker"
    - "single article worker"
    - "generate one planned article"
    - "单篇文章生成"
    - "单篇写作worker"
---

# Article Draft Worker

This skill is the per-article execution unit for `article-batch-generator`. It
drafts one article in a dedicated worker context so long-form writing and
post-draft optimization do not crowd the batch-level orchestration context.

## When This Must Trigger

Use this skill only for one article at a time:

- `article-batch-generator` is looping through a completed series plan
- One article needs to be rerun without reopening the rest of the batch context
- The workflow needs a publishable article file before batch-level linking begins

## Quick Start

Start with one of these prompts:

```text
Draft the article with slug [slug] from ./topics/my-topic/research/00-series-plan.json
```

```text
Generate article order [N] from ./topics/my-topic/research/00-series-plan.json
```

Expected output:

- `<topic_dir>/articles/NN-slug.md`
- one short completion summary for `article-batch-generator`

## Skill Contract

**Expected output**: one publishable article file with metadata, placeholders,
and schema when drafting succeeds, or one article-local concern summary when it
does not.

- **Reads**: `<topic_dir>/research/00-series-plan.json`, the selected article's
  plan entry, topic-level research artifacts, and any existing
  `<topic_dir>/articles/NN-slug.md` draft for recovery or revision context.
- **Writes**: one `<topic_dir>/articles/NN-slug.md` file and one short worker
  summary with the resolved article path and blockers.
- **Promotes**: article-level missing inputs, draft status, and output path back
  to `article-batch-generator`; do not write project memory.
- **Memory override**: when invoking downstream skills, suppress their default
  `Save Results` behavior and do not allow writes to `memory/`,
  `memory/content/`, `memory/hot-cache.md`, `memory/decisions.md`, or
  `memory/open-loops.md`.
- **Status model**: return `DONE` when the article file is written and
  `DONE_WITH_CONCERNS` when article-local blockers remain; never request a
  batch-level stop.
- **Next handoff**: return control to `article-batch-generator` for batch-level
  linking and later audit.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Article Path**: resolved `<topic_dir>/articles/NN-slug.md` path
- **Article Selector**: canonical `slug`, with `order` used only as fallback or verification

## Data Sources

Use the selected article entry from the normalized series plan and any topic-
level research artifacts as the primary inputs. When connected, use `~~SEO tool`
or `~~analytics` only to fill material gaps for this one article; do not expand
scope to unrelated articles in the batch.

## Instructions

Run this worker for exactly one article.

1. **Resolve the target article**
   - Read `<topic_dir>/research/00-series-plan.json`.
   - Resolve one article by canonical `slug` first. Use `order` only as
     fallback or verification when `slug` is missing or mismatched.
   - Derive the canonical article path from the matched entry's `order` and
     `slug` as `<topic_dir>/articles/<zero-padded order>-<slug>.md`.
   - If the selector is ambiguous, missing, article-local inputs are
     insufficient, or the worker cannot determine one canonical path, return
     `DONE_WITH_CONCERNS` with blocker details and do not escalate to a
     batch-level stop.

2. **Draft the article body**
   - Invoke `seo-content-writer` for the selected article's title, angle,
     keyword set, intent, and target word count.
   - Override `seo-content-writer`'s memory promotion and `Save Results`
     behavior for this worker run.

3. **Insert screenshot placeholders**
   - Invoke `seo-image-placeholder` and add screenshot placeholders only in the
     sections where UI proof, workflow clarity, trust signals, or result evidence
     materially improve the draft.
   - Override `seo-image-placeholder`'s memory promotion and `Save Results`
     behavior for this worker run.

4. **Run post-draft optimization**
   - Invoke `geo-content-optimizer`.
   - Invoke `meta-tags-optimizer`.
   - Invoke `schema-markup-generator`.
  - Override all default memory promotion and `Save Results` behavior from
    those skills for this worker run.

5. **Write the publishable article file**
   - Save the final result to the canonical article path derived from the
     matched plan entry.
   - Include frontmatter, reader-facing article content, FAQ when needed, and
     `JSON-LD`.
   - Do not include workflow logs, audit notes, or internal-link changelogs in
     the article body.
   - Do not invent alternate filenames from the title or from directory scans.
   - If article-local blockers prevent a publishable draft, leave the batch to
     record the missing file in its summary instead of stopping the full run.

6. **Return a minimal worker summary**
   - Return only the article path, `DONE` or `DONE_WITH_CONCERNS`, and any
     blockers that the batch orchestrator must surface.
   - Keep all intermediate summaries inside the worker context; do not save them
     to repository memory.

## Validation Checkpoints

- [ ] Exactly one series-plan article entry was selected
- [ ] The selected article resolves to exactly one canonical `<zero-padded order>-<slug>.md` path
- [ ] `<topic_dir>/articles/NN-slug.md` exists for the selected article
- [ ] `seo-image-placeholder` ran where visual proof or step clarity helps
- [ ] The article includes frontmatter, publishable body content, and `JSON-LD`
- [ ] No workflow-only notes were added inside the article body
- [ ] The worker returned only `DONE` or `DONE_WITH_CONCERNS` plus article-local blockers
- [ ] No downstream draft-stage skill wrote summaries or decisions into repository memory

## Reference Materials

- [seo-content-writer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/seo-content-writer/SKILL.md)
- [seo-image-placeholder](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/pipelines/seo-image-placeholder/SKILL.md)
- [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md)
- [meta-tags-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/meta-tags-optimizer/SKILL.md)
- [schema-markup-generator](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/schema-markup-generator/SKILL.md)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

Primary: `article-batch-generator`
— return when the single article file is written or when a blocker must be
surfaced to the batch summary.