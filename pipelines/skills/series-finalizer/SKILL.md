---
name: series-finalizer
description: 'Use when the user asks to "wrap up a content series", "compile the final delivery files", or "summarize a generated article batch". Produces series-level delivery artifacts such as the article index, publish checklist, and audit summary without rewriting article bodies. For content optimization, see article-batch-generator. 系列收尾/交付汇总'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when article generation is finished and the user needs final delivery artifacts. Also when a batch exists but there is no single series index, publish checklist, or audit rollup yet."
argument-hint: "<topic_dir> [series_plan_path=\"...\"]"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
  geo-relevance: "low"
  tags:
    - seo
    - geo
    - delivery
    - publishing
    - series-index
    - audit-summary
    - 系列收尾
    - 交付汇总
  triggers:
    - "wrap up a content series"
    - "compile final delivery files"
    - "summarize a generated article batch"
    - "series finalizer"
    - "系列收尾"
    - "交付汇总"
---

# Series Finalizer

This skill compiles the delivery layer for a generated article series. It
creates the files a human publisher or downstream automation needs, while
leaving article bodies untouched.

## When This Must Trigger

Use this skill after drafting, linking, and audits are done:

- The user needs one file that lists every article and its status
- Publishing needs a checklist or review queue
- Audit outcomes must be visible without opening each article file
- The workflow needs a clean endpoint before orchestration reports success

## Quick Start

Start with one of these prompts:

```text
Finalize the series in ./topics/my-topic
```

```text
Create the publish checklist and audit summary for this article batch
```

Expected output:

- `<topic_dir>/delivery/99-series-index.md`
- `<topic_dir>/delivery/99-publish-checklist.md`
- `<topic_dir>/delivery/99-audit-summary.json`

## Skill Contract

**Expected output**: delivery-facing summary files for the full series.

- **Reads**: `<topic_dir>/research/00-series-plan.json`, `<topic_dir>/articles/`,
  `<topic_dir>/delivery/internal-links/`, `<topic_dir>/delivery/audits/`, and
  `<topic_dir>/delivery/50-batch-summary.md`.
- **Writes**: `<topic_dir>/delivery/99-series-index.md`,
  `<topic_dir>/delivery/99-publish-checklist.md`,
  `<topic_dir>/delivery/99-audit-summary.json`, plus a short completion
  summary.
- **Promotes**: final delivery status, unresolved blockers, and article order
  into delivery artifacts only.
- **Next handoff**: if the series is already published, use
  `performance-reporter`; otherwise stop because the workflow is complete.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Final Output Paths**: list of the three generated summary files
- **Ready to Publish**: yes/no

## Data Sources

Use the series plan, article files, and delivery-side sidecars as the primary
sources of truth. When connected, use `~~analytics` or `~~CMS data` only to
verify readiness or enrich a publish queue; do not replace the batch-generated
artifacts as the canonical workflow record.

## Instructions

1. **Load the batch inventory**
    - Read `<topic_dir>/research/00-series-plan.json`, `<topic_dir>/articles/`,
     `<topic_dir>/delivery/internal-links/`,
     `<topic_dir>/delivery/audits/`, and
     `<topic_dir>/delivery/50-batch-summary.md`.
    - Build the expected article inventory from each plan entry's canonical
      `<zero-padded order>-<slug>` filename, using `slug` as the primary
      identifier and `order` only as verification.
    - Confirm the expected article count matches the number of article files, or
      record any gaps as unresolved blockers without stopping the finalizer.

2. **Build `<topic_dir>/delivery/99-series-index.md`**
   - List each article in order with:
     - title
     - slug
     - canonical article path
     - primary keyword
     - status
     - recommended next action
   - Include a short series overview and publish order.

3. **Build `<topic_dir>/delivery/99-publish-checklist.md`**
    - Add one row per article with:
  - canonical file path
      - file present
      - metadata present
      - schema present
      - internal link sidecar present
      - audit complete
      - blockers present
    - End with a series-level go/no-go note that tolerates per-article
      `DONE_WITH_CONCERNS` outcomes while surfacing them clearly.

4. **Build `<topic_dir>/delivery/99-audit-summary.json`**
    - Include:
      - total article count
      - `DONE` count
      - `DONE_WITH_CONCERNS` count
      - unresolved blockers
      - article-level verdicts from `delivery/audits/*.audit.json`
      - any planned articles that never produced a publishable file or audit
        sidecar

5. **Do not rewrite article bodies**
    - If a content issue is found here, report it in the checklist or the audit
      rollup.
    - Do not rerun writing or optimization skills from this phase.
    - Do not expect workflow-only sections such as internal-link notes or audit
      summaries to live inside the article body.

## Validation Checkpoints

- [ ] `<topic_dir>/delivery/99-series-index.md` lists every article exactly once
- [ ] Every expected article file is checked against the plan's canonical `<zero-padded order>-<slug>` naming pattern
- [ ] `<topic_dir>/delivery/99-publish-checklist.md` reflects actual file presence and audit state
- [ ] `<topic_dir>/delivery/99-audit-summary.json` matches article-level statuses
- [ ] Finalizer reads workflow sidecars from `delivery/`, not from article-body sections
- [ ] This phase does not change article bodies
- [ ] Ready-to-publish verdict is explicit

## Reference Materials

- [article-batch-generator](../article-batch-generator/SKILL.md)
- [performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

Primary only when the series is already published:
[performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md).
Otherwise stop and report the workflow complete.
