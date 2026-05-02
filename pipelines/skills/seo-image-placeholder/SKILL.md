---
name: seo-image-placeholder
description: 'Use when the user asks to "insert image placeholders", "add screenshot placeholders", or "预留图片位". Inserts screenshot/image placeholder blocks into drafts at the right sections so later SEO/GEO optimization stays structured. Scope: placeholder planning only, not full drafting or image generation. 图片占位符/截图占位/视觉证据插槽'
version: "9.9.5"
license: Apache-2.0
compatibility: "Claude Code, skills.sh, ClawHub, Vercel Labs, Cursor, Windsurf, Codex CLI, Amp, Gemini CLI, Kimi Code, Qwen Code, CodeBuddy"
homepage: "https://github.com/aaron-he-zhu/seo-geo-claude-skills"
when_to_use: "Use when a draft, outline, or landing page needs screenshot or image placeholders inserted before later optimization. Also for requests like insert image placeholders, add screenshot slots, reserve visual proof sections, 图片占位符, 截图占位符, 预留截图位置, 视觉证据占位, or screenshot placeholder."
argument-hint: "<content or outline> [goal]"
metadata:
  author: aaron-he-zhu
  version: "9.9.5"
  geo-relevance: "medium"
  tags:
    - seo
    - content-structure
    - screenshot-placeholders
    - image-placeholders
    - visual-proof
    - screenshots
    - 图片占位符
    - 截图占位符
    - 视觉证据
    - 版位规划
  triggers:
    - "insert image placeholders"
    - "add screenshot placeholders"
    - "screenshot placeholder"
    - "reserve image slots"
    - "visual proof blocks"
    - "where should images go"
    - "add visual placeholders"
    - "图片占位符"
    - "截图占位符"
    - "预留截图位置"
    - "插入图片占位"
    - "视觉证据占位"
---

# SEO Image Placeholder

Adds reusable screenshot and image placeholder blocks to a draft so visual evidence, trust signals, and UI proof have explicit slots before the next optimization pass.

## Quick Start

```text
Insert screenshot placeholders into this draft where visuals would improve trust and clarity: [draft]
```

```text
Add image placeholders to this landing page outline so later edits know exactly what to capture
```

## Skill Contract

**Expected output**: an updated draft or outline with placeholder blocks inserted, plus the standard handoff summary for follow-on optimization.

- **Reads**: the draft or outline, target keyword, entity/brand context, trust-sensitive claims, and prior decisions from [CLAUDE.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/CLAUDE.md) and the shared [State Model](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/state-model.md) when available.
- **Writes**: user-facing content with explicit image or screenshot placeholder blocks and a short visual to-do list.
- **Promotes**: approved visual proof ideas, evidence gaps, and unresolved capture needs to `memory/hot-cache.md`, `memory/decisions.md`, and `memory/open-loops.md`.
- **Primary next skill**: [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md) when the placeholder-aware draft is ready for a citation and clarity pass.

### Handoff Summary

> Emit the standard shape from [skill-contract.md §Handoff Summary Format](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md).

## Data Sources

Use `~~SEO tool`, `~~analytics`, and `~~browser capture` when connected; otherwise ask for the draft, target query, entity, conversion goal, and any must-show screens or proof points. See [CONNECTORS.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/CONNECTORS.md).

## Instructions

When a user requests image placeholders, run these seven steps:

1. **Find visual-pressure points** — mark sections where a screenshot or image would reduce ambiguity, strengthen trust, or make a step easier to follow.
2. **Choose the right placeholder type** — prefer domain/brand proof, workflow/UI proof, result/evidence proof, comparison support, or source/quote proof.
3. **Insert at natural anchors** — place blocks right after the paragraph or subheading they support, not as a detached appendix.
4. **Use the standard three-line block format** — title the placeholder, describe exactly what the image should show, and state the purpose in one sentence.
5. **Keep the capture brief concrete** — mention the URL, browser chrome, product state, brand mark, metric, or highlighted UI element that must be visible.
6. **Avoid overstuffing** — default to one placeholder per short section and three to six placeholders for a long article unless the user explicitly wants heavier visual planning.
7. **Return a clean handoff** — preserve the original draft structure, then list any missing assets or screens the user still needs to capture.

> **Reference**: See [references/instructions-detail.md](./references/instructions-detail.md) for placement heuristics, block templates, and a compact self-check.

## Example

> [截图占位符：官方主域名与页面首屏]
> 建议截图内容：浏览器地址栏中的 `metamask.io`，以及页面首屏的品牌标识。
> 截图目的：让“先认域名”这一步从抽象判断变成可见信号。

## Tips for Success

Describe what must be visible, why it matters, and where the placeholder belongs. Prefer evidence-carrying visuals over decorative images.

### Save Results

On user confirmation, save the updated draft summary to `memory/content/YYYY-MM-DD-<topic>.md` and promote unresolved capture needs to `memory/open-loops.md`.

## Reference Materials

- [Instructions Detail](./references/instructions-detail.md) — Placement rules, placeholder templates, and self-check

## Next Best Skill

- **Primary**: [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md) — tighten the surrounding copy, evidence density, and AI-citation readiness around the planned visuals.
