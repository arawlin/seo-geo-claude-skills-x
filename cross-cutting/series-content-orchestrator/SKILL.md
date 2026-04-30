---
name: series-content-orchestrator
description: 'Use when the user asks to "run the full content series workflow", "generate a multi-article series from one topic", or "orchestrate the whole article pipeline". Coordinates the research planner, article batch generator, and finalizer while keeping stage inputs and outputs aligned. For individual stages, see series-research-planner, article-batch-generator, and series-finalizer. 系列编排/总控工作流'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when the user wants a one-entry workflow from topic to finished article batch. Also when teams want one orchestration layer that drives the planner, batch generator, and finalizer in sequence."
argument-hint: "<topic> [articles=\"6\"] [language=\"en\"] [topics_root=\"./topics\"]"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
  geo-relevance: "high"
  tags:
    - seo
    - geo
    - orchestration
    - content-series
    - workflow
    - pipeline
    - 系列编排
    - 总控工作流
  triggers:
    - "run the full content series workflow"
    - "generate a multi-article series from one topic"
    - "orchestrate the whole article pipeline"
    - "series content orchestrator"
    - "一键生成系列文章"
    - "系列编排"
---

# Series Content Orchestrator

This skill is the thin top-level workflow wrapper for multi-article series
generation. It does not replace specialist skills. It only coordinates the
three workflow stages and reports success or failure at the series level. In
the batch stage, per-article drafting and final audits are delegated to
dedicated worker contexts owned by `article-batch-generator`.

## When This Must Trigger

Use this skill when the user wants one command-like workflow from topic to
finished delivery files:

- One topic should become a researched, drafted, finalized article set
- A teammate wants one stable entrypoint rather than stage-by-stage prompts
- The workflow must enforce stage order and artifact parity

## Quick Start

Start with one of these prompts:

```text
Run the full series workflow for [topic] under ./topics
```

```text
Generate a 6-article series about [topic] in [language]
```

Expected output:

- `<topic_dir>/research/00-series-research.md`
- `<topic_dir>/research/00-series-plan.json`
- `<topic_dir>/articles/*.md`
- `<topic_dir>/delivery/internal-links/*.links.md`
- `<topic_dir>/delivery/audits/*.audit.json`
- `<topic_dir>/delivery/50-batch-summary.md`
- `<topic_dir>/delivery/99-series-index.md`
- `<topic_dir>/delivery/99-publish-checklist.md`
- `<topic_dir>/delivery/99-audit-summary.json`

## Skill Contract

**Expected output**: a complete multi-stage series workflow with one final
status summary and delivery paths.

- **Reads**: topic, audience, language, topics root directory, optional
  competitor or site inputs, plus stage artifacts as they are generated.
- **Writes**: the stage artifacts from planner, batch generator, and finalizer
  plus one orchestration summary.
- **Promotes**: validated stage statuses and delivery paths across stage
  handoffs; no persistent memory writes in v1.
- **Next handoff**: none by default. Stop when the workflow succeeds or report
  the first blocking stage.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Stages Completed**: planner / batch / finalizer
- **Topic Directory**: final resolved topic root path

## Data Sources

Use user-provided topic, language, and optional competitor/site inputs as the
top-level inputs. All workflow evidence after startup should come from the
downstream stage artifacts generated under `research/`, `articles/`, and
`delivery/`, not from duplicated orchestration logic.

## Instructions

1. **Validate top-level input**
   - Confirm `topic`, `language`, article count, and `topics_root`.
   - Default `topics_root` to `./topics` when it is not provided.
   - Stop with `NEEDS_INPUT` if `topic` is missing.
   - Expect the resolved output layout to be
     `<topics_root>/<topic-slug>/research|articles|delivery`.

2. **Run the planner**
   - Invoke `series-research-planner`.
   - Stop immediately if the planner returns `BLOCKED` or `NEEDS_INPUT`.

3. **Run the batch generator**
    - Pass through the planner's `topic_dir` and
      `<topic_dir>/research/00-series-plan.json` path.
    - Expect the batch stage to invoke one dedicated draft worker and one
      dedicated audit worker per article, while keeping series-level linking and
      summary logic in the batch orchestrator.
    - Treat article-local worker blockers as per-article `DONE_WITH_CONCERNS`
      outcomes that must not stop the full series workflow.
    - Expect publishable article bodies under `articles/` and workflow-only
      sidecars under `delivery/internal-links/` and `delivery/audits/`.
    - Stop immediately only if the batch stage cannot load shared inputs or
      cannot produce its batch summary and sidecars.

4. **Run the finalizer**
   - Invoke `series-finalizer` after the batch stage completes, including when
     some articles are marked `DONE_WITH_CONCERNS`.

5. **Return one orchestration summary**
    - Report what completed, where the topic directory was created, and which
      article files still need human review.
    - Keep article-body outputs distinct from delivery-side workflow artifacts.
    - Never duplicate the full logic of the downstream skills inside this file.

## Validation Checkpoints

- [ ] The planner, batch generator, and finalizer run in order
- [ ] Stage outputs become inputs for the next stage without guessing
- [ ] Workflow-only artifacts stay under `delivery/`, not in publishable article bodies
- [ ] Failure in an earlier stage stops later stages
- [ ] Article-local worker blockers degrade only the affected article and do not stop the overall workflow
- [ ] Final summary lists the topic directory, delivery files, and unresolved concerns
- [ ] This skill stays thin and defers specialist work to downstream skills

## Reference Materials

- `series-research-planner`
- `article-batch-generator`
- `series-finalizer`
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

None by default. If the user needs post-publication monitoring after the series
is live, recommend
[performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md).
