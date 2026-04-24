---
name: series-finalizer
description: 'Use when the user asks to "wrap up a content series", "compile the final delivery files", or "summarize a generated article batch". Produces series-level delivery artifacts such as the article index, publish checklist, and audit summary without rewriting article bodies. For content optimization, see article-batch-generator. 系列收尾/交付汇总'
version: "9.2.0"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when article generation is finished and the user needs final delivery artifacts. Also when a batch exists but there is no single series index, publish checklist, or audit rollup yet."
argument-hint: "<output_dir> [series-plan.json]"
metadata:
  author: aaron-he-zhu
  version: "9.2.0"
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
Finalize the series in ./content/topic
```

```text
Create the publish checklist and audit summary for this article batch
```

Expected output:

- `99-series-index.md`
- `99-publish-checklist.md`
- `99-audit-summary.json`

## Skill Contract

**Expected output**: delivery-facing summary files for the full series.

- **Reads**: `00-series-plan.json`, the `articles/` directory, per-article audit
  summaries, and any batch status notes.
- **Writes**: `99-series-index.md`, `99-publish-checklist.md`,
  `99-audit-summary.json`, plus a short completion summary.
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

## Instructions

1. **Load the batch inventory**
   - Read `00-series-plan.json` and all files under `articles/`.
   - Confirm the expected article count matches the number of article files.

2. **Build `99-series-index.md`**
   - List each article in order with:
     - title
     - slug
     - primary keyword
     - status
     - recommended next action
   - Include a short series overview and publish order.

3. **Build `99-publish-checklist.md`**
   - Add one row per article with:
     - file present
     - metadata present
     - schema present
     - audit complete
     - blockers present
   - End with a series-level go/no-go note.

4. **Build `99-audit-summary.json`**
   - Include:
     - total article count
     - `DONE` count
     - `DONE_WITH_CONCERNS` count
     - unresolved blockers
     - article-level verdicts

5. **Do not rewrite article bodies**
   - If a content issue is found here, report it in the checklist.
   - Do not rerun writing or optimization skills from this phase.

## Validation Checkpoints

- [ ] `99-series-index.md` lists every article exactly once
- [ ] `99-publish-checklist.md` reflects actual file presence and audit state
- [ ] `99-audit-summary.json` matches article-level statuses
- [ ] This phase does not change article bodies
- [ ] Ready-to-publish verdict is explicit

## Reference Materials

- [article-batch-generator](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/article-batch-generator/SKILL.md)
- [performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

Primary only when the series is already published:
[performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md).
Otherwise stop and report the workflow complete.
