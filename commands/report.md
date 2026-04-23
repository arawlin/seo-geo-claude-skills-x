---
name: report
description: Generate a comprehensive SEO and GEO performance report for a single domain, a named project, or across all projects in memory.
argument-hint: "<domain|project=slug|project=all> <time period>"
parameters:
  - name: domain
    type: string
    required: false
    description: "Single domain to report on (e.g., example.com). Mutually exclusive with --project."
  - name: project
    type: string
    required: false
    description: "Project slug (e.g., acme-q2) to load from memory/wiki/<slug>/index.md. Use `all` to aggregate every project registered in memory/wiki/*/index.md (agency cross-client mode). Mutually exclusive with domain."
  - name: period
    type: string
    required: true
    description: "Time period: last-month, last-quarter, Q[N]-[YYYY], [YYYY-MM-DD] to [YYYY-MM-DD], last-30-days, last-90-days"
  - name: comparison
    type: string
    required: false
    description: "Comparison period: vs previous-quarter, vs last-year, vs previous-period"
  - name: format
    type: string
    required: false
    description: "Output format: detailed (default) or executive (condensed for stakeholders)"
---

# Report Command

A comprehensive **SEO and GEO performance report** that aggregates data across all channels, identifies trends, and delivers actionable recommendations prioritized by impact.

## Usage

```
/seo:report example.com last-month
/seo:report example.com last-quarter vs previous-quarter
/seo:report example.com last-90-days format=executive
/seo:report project=acme-q2 last-month
/seo:report project=all last-month format=executive
```

**Arguments:** Either `domain` OR `project=<slug>` OR `project=all` (exactly one) + time period (required) + optional `vs <comparison>` + optional `format=executive`.

## Workflow

### Single-domain or single-project mode

1. **Resolve scope** -- If `domain=X`, use X. If `project=<slug>`, read `memory/wiki/<slug>/index.md` for registered domain(s).
2. **Generate Performance Report** -- Invoke `performance-reporter` with resolved domain(s), period, and comparison.
3. **Include CITE/CORE-EEAT Context** (optional) -- If auditors have been run previously, include latest scores.
4. **Compile Output** -- For `format=executive`, include only Executive Summary and Prioritized Action Plan.

### Cross-project mode (`project=all`)

1. **Enumerate projects** -- List every `memory/wiki/<slug>/index.md`. Extract project name + domain(s).
2. **Per-project loop** -- Run single-project steps 2-3 for each project.
3. **Aggregate** -- Cross-project executive summary: total traffic, aggregate rank movement, P0/P1 issues per project, cross-project patterns.
4. **Output** -- Use cross-project format. `format=executive` collapses to aggregate summary + per-project one-liners.

## Output Format

Output uses the following structure (single-domain or cross-project, parameterized):

```markdown
## SEO & GEO PERFORMANCE REPORT (or CROSS-PROJECT PERFORMANCE REPORT)

**Scope**: [domain] or [N projects: slug1, slug2, ...]
**Period**: [date range] | **Comparison**: [vs period]

### Executive Summary
Performance snapshot: key metrics with period-over-period changes.
Key wins / critical concerns / strategic recommendations.

### Aggregate Summary (cross-project only)
Total organic sessions (vs prev, delta%). Rank winners/losers.
P0 issues across portfolio (by project). Cross-project patterns (1-3 bullets).

### Detailed Findings (7 sections)
1. Organic Traffic  2. Keyword Rankings  3. Domain Authority (CITE)
4. Backlinks  5. Technical SEO  6. GEO Performance  7. Content Performance
(Cross-project: per-project detail with same 7 sections, condensed, labeled by slug.)

### Prioritized Action Plan
P0 Critical / P1 High / P2 Medium / P3 Low.
(Cross-project: grouped by theme, not by project.)

### Appendix
Data Sources, Methodology, Historical Trends, Competitor Benchmarking.
```

## Tips

Compare to same period last year for seasonality. Use `format=executive` for stakeholders. For `project=all`, ensure each project has `memory/wiki/<slug>/index.md` first (run `/seo:wiki-lint` to check).

## Related Skills

- [performance-reporter](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/performance-reporter/SKILL.md) | [domain-authority-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/domain-authority-auditor/SKILL.md) | [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)
