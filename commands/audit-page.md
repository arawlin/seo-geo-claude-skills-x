---
name: audit-page
description: Run a comprehensive on-page SEO + CORE-EEAT content quality audit for a given URL or content
argument-hint: "<URL or paste content>"
allowed-tools: ["WebFetch"]
parameters:
  - name: source
    type: string
    required: true
    description: URL to audit or pasted content
  - name: keyword
    type: string
    required: false
    description: Target keyword for relevance scoring
---

# Audit Page Command

> Content quality scoring based on [CORE-EEAT Content Benchmark](https://github.com/aaron-he-zhu/core-eeat-content-benchmark). Full reference: [references/core-eeat-benchmark.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/core-eeat-benchmark.md)

A combined **on-page SEO** + **CORE-EEAT content quality** audit. For full site-wide technical SEO, use `/seo:check-technical`.

## Usage

```
/seo:audit-page https://example.com/blog-post
/seo:audit-page [paste content here] targeting "keyword"
/seo:audit-page https://example.com/landing-page keyword="primary keyword"
```

**Arguments:** URL or pasted content (required) + optional `keyword="target keyword"` (recommended for relevance scoring).

## Workflow

1. **Run On-Page SEO Audit** -- Invoke `on-page-seo-auditor`. Scores 8 areas (Title, Meta Description, Headers, Content, Keywords, Links, Images, Technical).
2. **Run CORE-EEAT Content Quality Audit** -- Invoke `content-quality-auditor`. Veto check first, then score all 80 items across 8 dimensions. Calculate GEO Score (CORE) and SEO Score (EEAT).
3. **Compile Output** -- Merge both results. Generate priority-ranked action list by severity.

## Output Format

```markdown
## ON-PAGE SEO AUDIT: [Page Title or URL]

**Overall Score**: XX/100

### Section Scores
8 area scores with bar charts.

### Priority Action List
CRITICAL / IMPORTANT / MINOR items with specific fixes.

### Concrete Action Checklist
[ ] Action items.

## CORE-EEAT CONTENT QUALITY

**Content Type**: [type] | **Veto Status**: Pass/Fail | **Weighted Score**: XX/100 ([rating])
**GEO Score (CORE)**: XX/100 | **SEO Score (EEAT)**: XX/100

Dimension Scores: Contextual Clarity, Organization, Referenceability, Exclusivity, Experience, Expertise, Authority, Trust -- each XX/100.

Top 5 Content Quality Improvements: [Issue] -- [specific action].

### Detailed Findings
Section-by-section breakdown in plain language. Internal item IDs emitted only in YAML handoff at `memory/audits/` per Runbook §5.

NOTE: For technical SEO (speed, crawl, HTTPS), run `/seo:check-technical`.
```

## Tips

Provide target keyword for relevance scoring. Some EEAT items (A01, A05, A07) require site-level data -- mark "N/A" if not observable. Run monthly on key pages.

## Related Skills

- [on-page-seo-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/optimize/on-page-seo-auditor/SKILL.md) | [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)
