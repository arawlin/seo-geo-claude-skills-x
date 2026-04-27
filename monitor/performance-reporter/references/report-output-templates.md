# Performance Report Output Templates

Compact starter blocks for SEO/GEO reporting. Use the same shape throughout the report: **metric table -> what changed -> why it matters -> next action**.

## Shared Conventions

| Item | Rule |
|------|------|
| Status | `On track`, `Watch`, `Off track`, or `N/A` |
| Delta | Show both absolute and percentage change when possible |
| Audience | Executive = trends + actions; Technical = causes + owners |
| Missing inputs | Mark the section `Not yet evaluated` and point to the next-best skill |

## 1. Report Configuration

```markdown
## Report Configuration
**Domain**: [domain]
**Period**: [start] to [end]
**Comparison**: [previous period]
**Data Freshness**: [timestamp or source date for each imported data set]
**Type**: [Monthly/Quarterly/Annual]
**Audience**: [Executive/Technical/Client]
**Focus**: [Traffic/Rankings/Content/Backlinks/GEO]
```

## 2. Executive Summary

```markdown
# SEO & GEO Performance Report
**Domain**: [domain] | **Period**: [date range] | **Prepared**: [date]

## Executive Summary
**Overall performance**: [Excellent/Good/Needs Attention/Critical]

**Wins**
- [win]
- [win]

**Watch areas**
- [risk]

**Action required**
- [action]

| Metric | Current | Previous | Change | Target | Status |
|--------|---------|----------|--------|--------|--------|
| Organic Traffic | [X] | [Y] | [+/-Z%] | [T] | [status] |
| Keywords Top 10 | [X] | [Y] | [+/-Z] | [T] | [status] |
| Organic Conversions | [X] | [Y] | [+/-Z%] | [T] | [status] |
| Domain Authority / CITE | [X] | [Y] | [+/-Z] | [T] | [status] |
| AI Citations | [X] | [Y] | [+/-Z%] | [T] | [status] |

**SEO ROI**: $[investment] -> $[organic revenue] -> [ROI]%
```

## 3. Organic Traffic Analysis

```markdown
## Organic Traffic

| Metric | Current | vs Last Period | vs Last Year |
|--------|---------|----------------|--------------|
| Sessions | [X] | [+/-Y%] | [+/-Z%] |
| Users | [X] | [+/-Y%] | [+/-Z%] |
| Pageviews | [X] | [+/-Y%] | [+/-Z%] |
| Bounce Rate | [X]% | [+/-Y%] | [+/-Z%] |

| Slice | Value | Change | Notes |
|-------|-------|--------|-------|
| Organic search | [X] | [+/-Y%] | [notes] |
| Top pages | [X] | [+/-Y%] | [notes] |
| Device split | [desktop/mobile] | [+/-Y%] | [notes] |

**Why it moved**: [summary]
**Next action**: [action]
```

## 4. Keyword Rankings

```markdown
## Keyword Rankings

| Position Range | Keywords | Change | Traffic Impact |
|----------------|----------|--------|----------------|
| 1 | [X] | [+/-Y] | [impact] |
| 2-3 | [X] | [+/-Y] | [impact] |
| 4-10 | [X] | [+/-Y] | [impact] |
| 11-20 | [X] | [+/-Y] | [impact] |

**Top improvements**
- [keyword] -> [previous] to [current]

**Declines**
- [keyword] -> [previous] to [current] -> [action]

**SERP feature notes**: [featured snippets / PAA / AI Overviews]
```

## 5. GEO / AI Visibility

```markdown
## GEO (AI Visibility)

| Metric | Current | Previous | Change |
|--------|---------|----------|--------|
| Queries with AI answer | [X]/[Y] | [X]/[Y] | [+/-Z] |
| Your AI citations | [X] | [Y] | [+/-Z%] |
| Citation rate | [X]% | [Y]% | [+/-Z%] |

**Wins**
- [query] -> cited page -> [impact]

**Gaps**
- [query] -> not cited -> [action]
```

## 6. Domain Authority (CITE Score)

```markdown
## Domain Authority (CITE Score)

| Metric | Current | Previous | Change |
|--------|---------|----------|--------|
| CITE Score | [X]/100 | [Y]/100 | [+/-Z] |
| C | [X] | [Y] | [+/-Z] |
| I | [X] | [Y] | [+/-Z] |
| T | [X] | [Y] | [+/-Z] |
| E | [X] | [Y] | [+/-Z] |

**Veto status**: [none / item triggered]
```

If no baseline exists, write `Not yet evaluated — run domain-authority-auditor for baseline`.

## 7. Content Quality (CORE-EEAT Score)

```markdown
## Content Quality (CORE-EEAT)

| Metric | Value |
|--------|-------|
| Pages audited | [count] |
| Average CORE-EEAT | [score]/100 |
| Average GEO Score | [score]/100 |
| Average SEO Score | [score]/100 |
| Veto items triggered | [count / IDs] |

| Dimension | Score | Trend |
|-----------|-------|-------|
| C | [score] | [trend] |
| O | [score] | [trend] |
| R | [score] | [trend] |
| E | [score] | [trend] |
| Exp | [score] | [trend] |
| Ept | [score] | [trend] |
| A | [score] | [trend] |
| T | [score] | [trend] |
```

If no audit exists, write `Not yet evaluated — run /seo:audit-page on key pages for baseline`.

## 8. Backlink Performance

```markdown
## Backlinks

| Metric | Current | Previous | Change |
|--------|---------|----------|--------|
| Total Backlinks | [X] | [Y] | [+/-Z] |
| Referring Domains | [X] | [Y] | [+/-Z] |
| Avg Authority | [X] | [Y] | [+/-Z] |

**Notable new links**
- [domain] -> [type/value]
```

## 9. Content Performance

```markdown
## Content Performance

| Metric | Current | Previous | Target |
|--------|---------|----------|--------|
| New articles | [X] | [Y] | [Z] |
| Content updates | [X] | [Y] | [Z] |

**Top performers**
- [content] -> [traffic / conversions / rankings]

**Needs attention**
- [content] -> [issue] -> [action]
```

## 10. Recommendations

```markdown
## Recommendations & Next Steps

| Horizon | Priority | Action | Expected Impact | Owner |
|---------|----------|--------|-----------------|-------|
| This week | High | [Action] | [Impact] | [Owner] |
| This month | Medium | [Action] | [Impact] | [Owner] |
| Next quarter | Medium | [Action] | [Impact] | [Owner] |

| Goal | Current | Next Target | Action |
|------|---------|-------------|--------|
| Organic Traffic | [X] | [Y] | [action] |
| Keywords Top 10 | [X] | [Y] | [action] |
| AI Citations | [X] | [Y] | [action] |
```

## 11. Full Report Structure

Compile sections 2-10 under `# [Company] SEO & GEO Performance Report — [Month/Quarter] [Year]`.

**Appendix**: data sources, methodology, glossary, and any missing-input notes.
