---
name: series-research-planner
description: 'Use when the user asks to "plan a content series", "turn one topic into many articles", or "map a topic cluster before writing". Creates a normalized series research brief and article plan by chaining keyword research, SERP review, competitor review, and content gap analysis. For single-keyword research, see keyword-research. 系列研究规划/专题选题规划'
version: "9.2.1"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when planning a multi-article topic cluster from one seed topic. Also when the user wants a pillar-plus-cluster plan, article backlog, or reusable series brief before drafting."
argument-hint: "<topic> [articles=\"6\"] [language=\"en\"] [audience=\"...\"] [topics_root=\"./topics\"]"
metadata:
  author: aaron-he-zhu
  version: "9.2.1"
  geo-relevance: "medium"
  tags:
    - seo
    - geo
    - content-series
    - topic-cluster
    - editorial-planning
    - content-brief
    - series-planning
    - 系列规划
    - 选题规划
  triggers:
    - "plan a content series"
    - "turn one topic into many articles"
    - "topic cluster plan"
    - "series research planner"
    - "pillar cluster workflow"
    - "内容系列规划"
    - "专题选题规划"
    - "系列研究"
---

# Series Research Planner

This skill creates the research package for a multi-article series. It runs one
series-level pass across demand, SERP shape, competitor coverage, and content
gaps, then outputs a normalized plan the drafting stage can consume without
guesswork.

## When This Must Trigger

Use this skill when the user needs a reusable plan for more than one article:

- One topic needs to become a pillar page plus supporting articles
- The user wants article ideas grounded in keyword and competitor evidence
- The workflow needs a stable `series plan` file before drafting starts
- A team needs one research brief that many writers can use

## Quick Start

Start with one of these prompts:

```text
Plan a 6-article series about [topic]
```

```text
Create a pillar-and-cluster research plan for [topic] targeting [audience]
```

Expected output:

- `<topic_dir>/research/00-series-research.md`
- `<topic_dir>/research/00-series-plan.json`
- one short handoff summary for `article-batch-generator`

## Skill Contract

**Expected output**: a series-level research brief, a normalized article plan,
and a short handoff summary ready for the drafting stage.

- **Reads**: topic, market, language, audience, business goals, competitor
  inputs, and available tool data.
- **Writes**: `<topic_dir>/research/00-series-research.md`,
  `<topic_dir>/research/00-series-plan.json`, and a brief stage summary with
  blockers and assumptions.
- **Promotes**: validated keyword clusters, article priorities, and unresolved
  research gaps into the series plan artifacts, not into project memory.
- **Next handoff**: use `article-batch-generator` when the series plan is
  complete.

### Handoff Summary

Emit the standard shape from
[skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)
and add:

- **Series Plan Path**: path to `<topic_dir>/research/00-series-plan.json`
- **Topic Directory**: path to the resolved topic root
- **Article Count**: number of planned articles

## Instructions

Run this phase once per series.

1. **Normalize scope**
   - Confirm topic, language, market, audience, article count, and the topics
     root directory.
   - Default `topics_root` to `./topics` when the user does not specify one.
   - Normalize `topic` into `topic_slug` and derive:
     - `topic_dir = <topics_root>/<topic-slug>/`
     - `research_dir = <topic_dir>/research/`
     - `articles_dir = <topic_dir>/articles/`
     - `delivery_dir = <topic_dir>/delivery/`
   - When `topics_root` stays at the default `./topics`, the resolved layout is
     `topics/<topic-slug>/research|articles|delivery`.

2. **Run keyword and intent discovery**
   - Invoke `keyword-research` for the seed topic.
   - Extract one pillar keyword plus supporting keyword clusters.
   - Carry forward only evidence-backed opportunities with at least one number
     attached.

3. **Review the live search landscape**
   - Invoke `serp-analysis` for the pillar topic and 2-4 high-value clusters.
   - Capture format patterns, query intent, AI-answerable opportunities, and
     weak spots in the current results.

4. **Review competitor coverage**
   - Invoke `competitor-analysis` for the same topic set.
   - Record which competitors dominate, what angles they own, and where their
     coverage is thin or stale.

5. **Map gaps into a series plan**
   - Invoke `content-gap-analysis`.
   - Convert keyword, SERP, and competitor signals into a final article list.
   - Keep the list ordered by priority, not by brainstorm order.

6. **Write `<topic_dir>/research/00-series-research.md`**
   - Include: executive summary, pillar topic, top clusters, competitor notes,
      and the logic behind the chosen article order.

7. **Write `<topic_dir>/research/00-series-plan.json`**
   - Use a stable shape with these fields:
      - `topic`
      - `topic_slug`
      - `language`
      - `audience`
      - `site_url`
      - `topic_dir`
      - `research_dir`
      - `articles_dir`
      - `delivery_dir`
      - `pillar`
      - `articles[]`
   - Each article must include:
     - `order`
     - `slug`
     - `title`
     - `primary_keyword`
     - `secondary_keywords`
     - `intent`
     - `angle`
     - `target_words`
     - `geo_notes`
     - `suggested_internal_links`

8. **Stop cleanly**
   - If research confidence is low, mark `DONE_WITH_CONCERNS`.
   - If the plan is complete, recommend `article-batch-generator`.

## Validation Checkpoints

- [ ] `<topic_dir>/research/00-series-plan.json` exists and every article has a unique `slug`
- [ ] The plan contains one pillar topic and at least one supporting article
- [ ] Every article includes a primary keyword, angle, and target word count
- [ ] The plan names data sources or states clearly when inputs were user-provided
- [ ] Output does not require the next stage to infer missing fields

## Reference Materials

- [keyword-research](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/research/keyword-research/SKILL.md)
- [serp-analysis](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/research/serp-analysis/SKILL.md)
- [competitor-analysis](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/research/competitor-analysis/SKILL.md)
- [content-gap-analysis](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/research/content-gap-analysis/SKILL.md)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)

## Next Best Skill

Primary: [article-batch-generator](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/article-batch-generator/SKILL.md)
— use when `<topic_dir>/research/00-series-plan.json` is complete. Stop if the
plan status is `NEEDS_INPUT` or `BLOCKED`.
