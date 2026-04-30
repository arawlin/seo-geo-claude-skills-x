---
name: article-batch-generator
description: 'Use when the user asks to "generate a full article series", "draft every article from a series plan", or "batch write articles into a directory". Produces article files from a normalized series plan by chaining per-article workers, shared internal linking, and final content audit. For standalone one-off article writing, see seo-content-writer. For a single article rerun from an existing series plan, see article-draft-worker. 批量文章生成/系列文章批处理'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when turning a completed series plan into drafted article files. Also when the user wants all article assets written to a directory with shared internal links and final quality checks."
argument-hint: "<topic_dir/research/00-series-plan.json>"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
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

This skill turns a completed series plan into a finished article set. It stays
thin at the batch level by delegating each article draft and each final audit to
dedicated per-article worker skills, then applies series-level internal linking
and batch summary reporting.

## When This Must Trigger

Use this skill after research is complete and a series plan already exists:

- The article list is approved and drafting should start
- All article files need to land under one topic directory
- Internal links must be planned across the full set, not one article at a time
- Each article needs a final `content-quality-auditor` pass before handoff

If the user needs only one standalone article, use `seo-content-writer`. If the
user needs to rerun one article from an existing series plan, use
`article-draft-worker`.

## Quick Start

Start with one of these prompts:

```text
Generate all articles from ./topics/my-topic/research/00-series-plan.json
```

```text
Draft a 5-article series from ./topics/my-topic/research/00-series-plan.json
```

Expected output:

- `<topic_dir>/articles/NN-slug.md` for each successfully drafted article
- `<topic_dir>/delivery/internal-links/NN-slug.links.md` for each linked article
- `<topic_dir>/delivery/audits/NN-slug.audit.json` for each audited article
- updated internal links across the batch
- `<topic_dir>/delivery/50-batch-summary.md`

## Skill Contract

**Expected output**: a batch of article files with screenshot placeholders,
metadata, schema, cross-links, and final audit status.

- **Reads**: `<topic_dir>/research/00-series-plan.json`, article requirements,
   stage blockers, and any existing draft files in `<topic_dir>/articles/`.
- **Writes**: `<topic_dir>/articles/NN-slug.md`,
  `<topic_dir>/delivery/internal-links/NN-slug.links.md`,
  `<topic_dir>/delivery/audits/NN-slug.audit.json`, and
  `<topic_dir>/delivery/50-batch-summary.md`.
- **Promotes**: validated cross-link relationships, final audit states, and
  missing assets into batch outputs, not memory.
- **Execution model**: one per-article draft worker call and one per-article
   audit worker call for each article, with batch-only state kept in this skill.
- **Memory rule**: this workflow writes only article files, delivery sidecars,
  and batch summaries. Downstream skills invoked by the workers must not write
  to `memory/`, `memory/content/`, `memory/audits/`, `memory/hot-cache.md`,
  `memory/decisions.md`, or `memory/open-loops.md`.
- **Failure model**: article-local worker blockers downgrade only that article
   to `DONE_WITH_CONCERNS`; they must not stop the batch after shared inputs are
   loaded.
- **Next handoff**: use `series-finalizer` when all article files and audits are
  complete.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Articles Written**: count of generated files
- **Audit Failures**: list of any files still marked `DONE_WITH_CONCERNS`

## Data Sources

Use the normalized series plan, any topic-level research artifacts, and the
current article directory as the primary inputs. When connected, use `~~SEO tool`
or `~~analytics` only to fill gaps that materially affect the batch; otherwise
stay anchored to `<topic_dir>/research/00-series-plan.json` and user-provided
requirements.

## Instructions

Run this phase in four blocks.

### Block A — Per-article drafting attempts and placeholder insertion

For each article in the series plan:

1. Invoke `article-draft-worker` once for the current article.
2. Pass the series plan path plus the current article's canonical `slug`
   selector and `order` as verification or fallback.
3. Require the worker to run `seo-content-writer`,
   `seo-image-placeholder`, `geo-content-optimizer`,
   `meta-tags-optimizer`, and `schema-markup-generator` inside its own
   dedicated context.
   - Require the worker to suppress all downstream `Save Results` steps and any
     default memory-promotion behavior from those skills.
4. Require the worker to derive the canonical article path from the matched plan
   entry's `order` and `slug`, then save the result as that exact
   `<topic_dir>/articles/NN-slug.md` path.
5. Collect only the returned article path, status, and missing-input blockers in
   the batch context.
6. If the worker cannot produce a publishable draft for one article, mark that
   article `DONE_WITH_CONCERNS`, carry its blockers into the batch summary, and
   continue with the remaining articles.

Each article file must include:

- frontmatter with title, slug, keywords, meta fields, audit placeholders
- full article body
- screenshot placeholders in suitable sections when the article would benefit
  from visual proof or step clarity
- FAQ when the plan or source skills call for it
- `JSON-LD`

`<topic_dir>/articles/NN-slug.md` must stay publishable. Do not place workflow
logs, internal-link change notes, or audit summaries inside the article body.
Do not inline the downstream writing workflow in this skill; the worker owns it.

### Block B — Batch-level linking

After all article draft attempts complete:

1. Invoke `internal-linking-optimizer` once across the successfully drafted
   article set.
2. Update each article's internal links in the publishable body using the full
   inventory, not partial inventory.
3. Write `<topic_dir>/delivery/internal-links/NN-slug.links.md` for each
   linked article with the outbound links added, inbound targets, and chosen
   anchor text.
4. Record the final link inventory and any missing draft files in
   `<topic_dir>/delivery/50-batch-summary.md`.

Do not run `internal-linking-optimizer` inside the per-article drafting loop.
Do not add an internal-link changelog section inside the article body.
Do not stop the batch because one planned article is missing a publishable draft.

### Block C — Final per-article audit

For each article that has a publishable file after linking updates:

1. Invoke `article-audit-worker` once for the current article.
2. Pass the current article path, the series plan path, and the current
   article's canonical `slug` selector with `order` as verification or
   fallback.
3. Require the worker to run `content-quality-auditor`, apply at most one
   publishable-body revision pass when the verdict is `FIX`, and rerun the audit
   once.
   - Require the worker to suppress all downstream audit-memory writes and any
     default `Save Results` behavior from `content-quality-auditor`.
4. Require the worker to write
   the canonical `<topic_dir>/delivery/audits/NN-slug.audit.json` sidecar
   derived from the matched plan entry's `order` and `slug`, with the final
   verdict, blockers, and recommended next action for that article.
5. If the worker still returns unresolved blockers after one revision, mark the
   article `DONE_WITH_CONCERNS` and surface the blocker in the batch summary.
6. If an article never produced a publishable draft, skip the audit worker for
   that article, keep it `DONE_WITH_CONCERNS`, and continue with the remaining
   audits.

Do not add an audit summary section inside the article body.
Do not stop the batch because one article fails its final audit.

### Block D — Batch summary

After all article audits are complete:

1. Write `<topic_dir>/delivery/50-batch-summary.md`.
2. Include article paths, audit statuses, unresolved blockers, the final
   link inventory, any missing article files or skipped audits, and the sidecar
   paths under `delivery/internal-links/` and `delivery/audits/`.

## Validation Checkpoints

- [ ] Every planned article was attempted once and either has a corresponding `<topic_dir>/articles/NN-slug.md` or an explicit blocker in the batch summary
- [ ] Every article draft ran through one `article-draft-worker` call in its own dedicated context
- [ ] `seo-image-placeholder` ran after each successful article draft and added screenshot placeholders where useful
- [ ] Every linked article has a matching `delivery/internal-links/NN-slug.links.md`, or the missing link sidecar is explained in the batch summary
- [ ] Every audited article has a matching `delivery/audits/NN-slug.audit.json`, or the skipped audit is explained in the batch summary
- [ ] Every final audit ran through one `article-audit-worker` call in its own dedicated context
- [ ] `internal-linking-optimizer` ran after all drafts existed
- [ ] Every draft and audit path follows the matched plan entry's canonical `<zero-padded order>-<slug>` naming pattern
- [ ] Every article includes title, meta description, schema, and publishable reader-facing content only
- [ ] Final status for each article is `DONE` or `DONE_WITH_CONCERNS`
- [ ] No worker-invoked downstream skill wrote process summaries into `memory/` or related memory files
- [ ] `<topic_dir>/delivery/50-batch-summary.md` lists any unresolved blockers and skipped article outputs clearly

## Reference Materials

- [article-draft-worker](../article-draft-worker/SKILL.md)
- [article-audit-worker](../article-audit-worker/SKILL.md)
- [seo-content-writer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/seo-content-writer/SKILL.md)
- [seo-image-placeholder](../seo-image-placeholder/SKILL.md)
- [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md)
- [meta-tags-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/meta-tags-optimizer/SKILL.md)
- [schema-markup-generator](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/schema-markup-generator/SKILL.md)
- [internal-linking-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/optimize/internal-linking-optimizer/SKILL.md)
- [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)

## Next Best Skill

Primary: `series-finalizer`
— use when all article files exist and the batch summary is complete. Stop if
article generation is still `BLOCKED` or the plan is incomplete.
