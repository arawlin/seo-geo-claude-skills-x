---
name: article-audit-worker
description: 'Use when article-batch-generator needs to audit one generated article in its own dedicated context after batch-level linking is complete. Runs content-quality-auditor, applies one resolvable revision pass, and writes one audit sidecar. 单篇文章审计worker/独立子上下文'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
context: fork
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when one generated article needs a final publish-readiness audit in isolation from the rest of the batch. Also when article-batch-generator needs one per-article audit worker invocation that does not crowd the batch context."
argument-hint: "<topic_dir/articles/NN-slug.md> <topic_dir/research/00-series-plan.json> <article_slug_or_order>"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
  geo-relevance: "high"
  tags:
    - seo
    - geo
    - article-worker
    - content-audit
    - eeat
    - audit-sidecar
    - 单篇审计
    - 独立上下文
  triggers:
    - "audit one generated article"
    - "article audit worker"
    - "single article audit worker"
    - "run one article audit"
    - "单篇文章审计"
    - "单篇审计worker"
---

# Article Audit Worker

This skill is the per-article audit unit for `article-batch-generator`. It
runs one article through the final content-quality gate in a dedicated worker
context after batch-level internal links are already in place.

## When This Must Trigger

Use this skill only for one article at a time:

- `article-batch-generator` has finished batch-level linking
- One article needs a final audit without carrying the rest of the batch context
- A failed audit needs one local rerun for the same article only

## Quick Start

Start with one of these prompts:

```text
Audit ./topics/my-topic/articles/03-example.md using ./topics/my-topic/research/00-series-plan.json and selector example
```

```text
Run the final audit for article order [N] after linking is complete
```

Expected output:

- `<topic_dir>/delivery/audits/NN-slug.audit.json`
- an updated `<topic_dir>/articles/NN-slug.md` only when one publishable-body revision is needed
- one short completion summary for `article-batch-generator`

## Skill Contract

**Expected output**: one final article audit sidecar, plus one publishable-body
revision when resolvable in a single pass.

- **Reads**: `<topic_dir>/articles/NN-slug.md`,
  `<topic_dir>/research/00-series-plan.json`, the selected article's plan entry,
  and any existing `<topic_dir>/delivery/audits/NN-slug.audit.json` for retry
  context.
- **Writes**: one `<topic_dir>/delivery/audits/NN-slug.audit.json` sidecar and,
  only when needed, one updated `<topic_dir>/articles/NN-slug.md`.
- **Promotes**: final verdict, blockers, next action, and article status back to
  `article-batch-generator`; do not write project memory.
- **Memory override**: when invoking `content-quality-auditor`, suppress its
  default audit-memory writes and `Save Results` behavior. Do not allow writes
  to `memory/`, `memory/audits/`, `memory/hot-cache.md`, or
  `memory/open-loops.md` from this worker run.
- **Status model**: return `DONE` when the article passes and
  `DONE_WITH_CONCERNS` when article-local blockers remain; never request a
  batch-level stop.
- **Next handoff**: return control to `article-batch-generator` for batch
  summary rollup and finalization.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Audit Path**: resolved `<topic_dir>/delivery/audits/NN-slug.audit.json` path
- **Final Verdict**: `DONE` or `DONE_WITH_CONCERNS`

## Data Sources

Use the current linked article body and the selected series-plan entry as the
primary sources of truth. Do not reopen unrelated article files from the same
batch. Use external tools only when they materially affect the audit for this
single article.

## Instructions

Run this worker for exactly one article.

1. **Resolve the target article**
   - Read the article file and `<topic_dir>/research/00-series-plan.json`.
   - Resolve one article by canonical `slug` first. Use `order` only as
     fallback or verification when `slug` is missing or mismatched.
   - Derive the canonical article path from the matched entry's `order` and
     `slug` as `<topic_dir>/articles/<zero-padded order>-<slug>.md` and confirm
     the provided article file matches that path.
   - If the selector is ambiguous, mismatched, article-local inputs are
     insufficient, or the file does not match one canonical path, return
     `DONE_WITH_CONCERNS` with blocker details and do not escalate to a
     batch-level stop.

2. **Run the first audit pass**
   - Invoke `content-quality-auditor` on the current article body after linking
     updates are complete.
   - Override `content-quality-auditor`'s default memory promotion and
     `Save Results` behavior for this worker run.

3. **Apply one local revision pass when allowed**
   - If the verdict is `FIX` and the issues are resolvable in one pass, revise
     only the publishable article body.
   - Do not add workflow notes or audit summaries inside the article body.

4. **Rerun the audit once**
   - Invoke `content-quality-auditor` one more time after the local revision.
   - Do not loop beyond this rerun.

5. **Write the audit sidecar**
   - Save the canonical
     `<topic_dir>/delivery/audits/<zero-padded order>-<slug>.audit.json`
     sidecar with the final verdict, blockers, and recommended next action.
   - Do not invent alternate sidecar names from the title or from directory
     scans.
   - Use `DONE` when the article passes and `DONE_WITH_CONCERNS` when blockers
     remain after the allowed rerun or when the audit cannot complete for
     article-local reasons.

6. **Return a minimal worker summary**
   - Return only the audit path, `DONE` or `DONE_WITH_CONCERNS`, and unresolved
     blockers that the batch orchestrator must surface.
   - Keep all intermediate audit notes inside the worker context; do not save
     them to repository memory.

## Validation Checkpoints

- [ ] Exactly one article file and one series-plan entry were matched
- [ ] The article file and audit sidecar both follow one canonical `<zero-padded order>-<slug>` path pattern
- [ ] `content-quality-auditor` ran at least once for the selected article
- [ ] At most one publishable-body revision pass was applied
- [ ] `<topic_dir>/delivery/audits/NN-slug.audit.json` exists for the selected article
- [ ] The article body does not contain workflow-only audit notes
- [ ] The worker returned only `DONE` or `DONE_WITH_CONCERNS` plus article-local blockers
- [ ] `content-quality-auditor` did not write audit artifacts or open loops into repository memory for this worker run

## Reference Materials

- [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

Primary: `article-batch-generator`
— return when the audit sidecar is written or when unresolved blockers must be
surfaced to the batch summary.