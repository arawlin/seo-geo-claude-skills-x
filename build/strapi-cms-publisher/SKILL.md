---
name: strapi-cms-publisher
description: 'Use when the user asks to "publish a markdown article to Strapi", "upload content to Strapi CMS", or "sync SEO content, schema, tags, categories, and media into Strapi draft". Maps local article bundles into a fixed Strapi Article/SEO/slug/source model, rewrites internal links and image URLs, and creates or updates draft entries only after a single explicit review and confirmation step. Use seo-content-writer, meta-tags-optimizer, or schema-markup-generator to generate the content itself.'
version: "9.2.0"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when publishing finalized markdown articles, inline or sidecar JSON-LD schema, tags, categories, and media into a fixed Strapi CMS model as draft entries. Also when the user asks to sync article updates, rewrite internal links, or upload article images before saving a draft."
argument-hint: "<article path> [optional schema path or directory]"
metadata:
  author: arawlin
  version: "1.0.0"
  geo-relevance: "medium"
  tags:
    - strapi
    - cms-publishing
    - markdown-sync
    - draft-publishing
    - content-operations
    - media-upload
    - json-ld
    - internal-links
    - 分类管理
    - 标签管理
    - CMS发布
    - 草稿同步
  triggers:
    - "publish markdown to Strapi"
    - "upload article to Strapi"
    - "sync content to Strapi CMS"
    - "create draft in Strapi"
    - "update Strapi article draft"
    - "upload schema and media to Strapi"
    - "发布到 Strapi"
    - "上传文章到 Strapi"
    - "同步到 Strapi CMS"
    - "创建 Strapi 草稿"
    - "更新 Strapi 文章"
    - "上传 schema 到 Strapi"
---

# Strapi CMS Publisher

This skill publishes finalized Markdown article bundles into a fixed Strapi draft model. It extracts inline and sidecar JSON-LD, resolves taxonomy and article state, uploads linked images, rewrites internal article links, and stages all writes behind a single confirmation step.

## What This Skill Does

Converts local Markdown, JSON-LD, and image assets into Strapi `Article`, `shared.seo`, `shared.slug`, `shared.source`, `category`, and `tag` records with draft-only saves and read-back verification.

## Quick Start

Start with one of these prompts. Finish with a short handoff summary using the repository format in [Skill Contract](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md).

### Single Article Draft Sync

```text
Publish build-ready article vendors/cms-server-1/example.md to Strapi draft
```

### Article + Sidecar Schema

```text
Upload this markdown article and its JSON-LD sidecar to Strapi CMS draft,
create missing tags only after review
```

### Update Existing Draft

```text
Sync this article update to Strapi draft, rewrite local links, upload images,
and ask before updating the existing entry
```

## Skill Contract

**Expected output**: a ready-to-run draft publish plan or a confirmed draft write summary plus a short handoff summary ready for `memory/content/`.

- **Reads**: article Markdown, optional sidecar JSON-LD files, linked local or remote images, fixed CMS mapping rules, and prior decisions from [CLAUDE.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/CLAUDE.md) and [State Model](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/state-model.md) when available.
- **Writes**: Strapi draft entries, media uploads, category and tag relations, and a reusable publish summary.
- **Promotes**: missing taxonomy inputs, unresolved internal links, image upload blockers, and update confirmations to `memory/hot-cache.md`, `memory/decisions.md`, and `memory/open-loops.md`.
- **Next handoff**: use the `Next Best Skill` below when the draft needs rendered-page review.

### Handoff Summary

> Emit the standard shape from [skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md).

## Preconditions

- The Strapi content model is fixed; do not spend runtime budget re-introspecting content types unless the user says the model changed.
- Keep writes **draft only**. Never publish automatically.
- Rewrite local article links as `/article/{articleSlug}`. Do not prepend a base URL or keep category segments in rewritten internal links.
- If the connected runtime lacks Strapi write access, still produce the dry-run plan and confirmation summary.
- Parse article frontmatter using the fixed field names in [references/frontmatter-contract.md](./references/frontmatter-contract.md).

## Instructions

When a user requests Strapi publishing, run these eight steps in order:

1. **Confirm Publish Scope** — gather article path(s), optional sidecar schema path(s), Strapi server alias, batch vs. single-entry mode, and whether updates or taxonomy creation are allowed after review.
2. **Parse the Article Bundle** — read frontmatter using the fixed contract, read Markdown body, extract every `<script type="application/ld+json">` block, load any sidecar JSON-LD files, and remove extracted script blocks from the Markdown that will be sent to `Article.content`.
3. **Normalize CMS Fields** — map the content bundle into the fixed Article payload (`title`, `description`, `content`, `slug.label`, `seo`, `source`). Leave `canonicalURL` and `openGraph.ogUrl` empty when only relative paths are available. Do not set `source.releaseAt`.
4. **Rewrite Internal Links and Images** — convert local article links into `/article/{articleSlug}` form directly from the linked filename, preserve anchors, upload local and remote images to Strapi media, and replace Markdown image URLs with the returned media URLs. Do not spend runtime budget checking whether the linked article already exists in Strapi before rewriting the URL.
5. **Resolve Taxonomy and Article State** — look up category, tags, and article records before writing. Stage missing categories and tags for creation, and stage article writes as `create` or `update` based on `slug.label`. If a missing category only has a slug and no clear display name, stop and ask before confirmation.
6. **Present a Single Confirmation Summary** — show article creates, article updates, pending category creates, pending tag creates, media uploads, and unresolved references. No write operation is allowed before explicit user approval.
7. **Execute Draft Writes** — after approval, create missing categories and tags first, remember their `documentId` values, then create or update the draft article entry and attach the resolved relations and media-backed Markdown.
8. **Read Back and Emit Handoff** — fetch the saved draft, verify core fields (`title`, `slug`, `content`, `seo.structuredData`, taxonomy, image URLs), and output a handoff summary plus any remaining blockers.

> **Reference**: See [references/publish-workflow.md](./references/publish-workflow.md) for the full field map, schema merge rules, internal-link algorithm, image handling notes, and confirmation matrix.

## Example

**User**: "Publish `vendors/cms-server-1/heyue-he-xianhuo-nage-fengxian-da.md` to Strapi draft and create missing tags only after review"

**Output** (abbreviated):
- Dry-run summary: 1 article update or create candidate, 1 category lookup, 5 tag lookups, 0-1 tag creates, N image uploads, 2 internal link rewrites
- Payload plan: `title`, `description`, Markdown `content`, merged `seo.structuredData`, `slug.label`, `source.contentHash`, taxonomy document IDs
- Confirmation gate: one approval covering tag/category creates, article write, and media uploads
- Read-back result: saved draft `documentId`, preserved Markdown, uploaded media URLs substituted, unresolved links listed if any

## Decision Rules

- **Schema merge**: combine inline JSON-LD blocks with sidecar JSON-LD, de-duplicate by semantic identity, and prefer sidecar values on direct conflicts.
- **Article updates**: always ask before overwriting an existing article matched by `slug.label`.
- **Taxonomy creation**: batch all missing categories and tags into one approval prompt before creating them.
- **Image handling**: remote image URLs are downloaded to temporary local storage before upload; local images are uploaded directly; temporary downloads are deleted after upload.

### Save Results

On user confirmation, save a dated summary to `memory/content/YYYY-MM-DD-<topic>.md` and promote key publish decisions or blockers to `memory/hot-cache.md`.

## Reference Materials

- [Publish Workflow](./references/publish-workflow.md) — Field mapping, schema merge rules, internal-link algorithm, media upload notes, and confirmation matrix
- [Frontmatter Contract](./references/frontmatter-contract.md) — Fixed field names for category, tags, image inputs, and SEO overrides

## Next Best Skill

- **Primary**: [on-page-seo-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/optimize/on-page-seo-auditor/SKILL.md) — audit the rendered draft once the CMS exposes a preview or published URL.