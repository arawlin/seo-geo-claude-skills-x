---
name: audit-domain
description: Run a full CITE domain authority audit with 40-item scoring, veto checks, and prioritized action plan
argument-hint: "<domain>"
parameters:
  - name: domain
    type: string
    required: true
    description: Domain to audit (e.g., example.com)
  - name: type
    type: string
    required: false
    description: "Domain type: Content Publisher, Product & Service, E-commerce, Community & UGC, Tool & Utility, Authority & Institutional"
  - name: competitors
    type: string
    required: false
    description: Competitor domains for comparison (space-separated)
---

# Audit Domain Command

> Domain authority scoring based on [CITE Domain Rating](https://github.com/aaron-he-zhu/cite-domain-rating). Full reference: [references/cite-domain-rating.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/cite-domain-rating.md)

A comprehensive **CITE 40-item domain authority** audit with veto checks and actionable recommendations. For page-level content quality, use `/seo:audit-page`.

## Usage

```
/seo:audit-domain example.com
/seo:audit-domain example.com type="e-commerce"
/seo:audit-domain example.com vs competitor1.com competitor2.com
```

**Arguments:** Domain (required) + optional `type="domain type"` + optional competitor domains.

## Workflow

1. **Identify Domain Type** -- If not specified, classify using the `domain-authority-auditor` decision tree. Apply dimension weights:

   > Canonical source: [references/cite-domain-rating.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/cite-domain-rating.md). This inline copy is for convenience.

   | Dim | Default | Content Publisher | Product & Service | E-commerce | Community & UGC | Tool & Utility | Authority & Institutional |
   |-----|:-------:|:-:|:-:|:-:|:-:|:-:|:-:|
   | C | 35% | **40%** | 25% | 20% | 35% | 25% | **45%** |
   | I | 20% | 15% | **30%** | 20% | 10% | **30%** | 20% |
   | T | 25% | 20% | 25% | **35%** | 25% | 25% | 20% |
   | E | 20% | 25% | 20% | 25% | **30%** | 20% | 15% |

2. **Run Full CITE Audit** -- Invoke `domain-authority-auditor`. Veto check first (failure caps at 60 per [auditor-runbook.md §2](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md)), then score all 40 items, calculate weighted CITE Score, generate Top 5 improvements.
3. **Compile Output** -- Format results below. Include comparative scoring if competitors provided.

## Output Format

```markdown
## CITE DOMAIN AUTHORITY AUDIT: [Domain]

**Domain Type**: [Type] | **CITE Score**: [X]/100 ([Rating]) | **Veto Status**: Pass / MANIPULATION ALERT

### Dimension Scores
Citation XX/100 (weight X%) | Identity XX/100 (weight X%) | Trust XX/100 (weight X%) | Eminence XX/100 (weight X%)

### Veto Check (trust-critical items)
Site Security, Legal Policies, Review Authenticity: Pass/Fail per item.
(Internal IDs emitted only in YAML handoff at `memory/audits/`, per Runbook §5.)

### Priority Action List
Top 5 Improvements by weighted impact: [Issue] -- [action] (potential: +X weighted pts)
(Internal IDs in handoff summary only, suppressed from user-facing view per Runbook §5.)

### Action Plan
CRITICAL / IMPORTANT / MINOR items with checklist.

### Detailed Per-Item Scores
Full 40-item score table with notes.

NOTE: For page-level content quality, run `/seo:audit-page`. For combined 120-item assessment, run both.
```

## Tips

Provide domain type for accurate weights. Include competitors for benchmarking. Run alongside `/seo:audit-page` for full 120-item assessment. Re-audit quarterly.

## Related Skills

- [domain-authority-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/domain-authority-auditor/SKILL.md) | [backlink-analyzer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/backlink-analyzer/SKILL.md)
