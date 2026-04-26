---
name: write-content
description: Write SEO and GEO optimized content from a topic and target keyword
argument-hint: "<topic> keyword=\"<target keyword>\" type=\"<content type>\""
parameters:
  - name: topic
    type: string
    required: true
    description: Content topic
  - name: keyword
    type: string
    required: true
    description: Primary SEO target keyword
  - name: type
    type: string
    required: false
    description: "Content type (default: blog post). Options: blog post, how-to guide, comparison, listicle, landing page, ultimate guide"
---

# Write Content Command

Writes search-engine-optimized content, then applies a GEO optimization pass for AI citability. Delivers final content with SEO metadata and quality scores.

## Usage

```
/seo:write-content "email marketing for SaaS" keyword="saas email marketing" type="how-to guide"
/seo:write-content "cloud hosting comparison" keyword="best cloud hosting"
```

**Arguments:** Topic (required) + `keyword=` (required) + optional `type=` (default: blog post; options: blog post, how-to guide, comparison, listicle, landing page, ultimate guide).

## Workflow

1. **Run SEO Content Writer** -- Invoke `seo-content-writer`: SERP analysis, keyword map, title options, meta description, SEO headers, full draft, featured snippet optimization, link recommendations, SEO review, CORE-EEAT self-check.
2. **Run GEO Content Optimizer** -- Pass draft to `geo-content-optimizer`: clear definitions, quotable statements with data, authority signals, AI-friendly structure, factual density, schema-ready FAQ.
3. **Compile Final Output**.

## Output Format

```markdown
# [Final Optimized Title]

**Meta Description**: "[description]" ([X] chars)
**Primary Keyword**: [keyword] | **Content Type**: [type]

---
[Full written content with GEO enhancements]
---

## SEO Metadata
| Element | Value |
Title Tag, Meta Description, URL Slug, Keywords, Word Count.

## CORE Self-Check Scores
| Dimension | Score | Key Notes |
C / O / R / E dimensions with GEO Score avg.

## GEO Optimization Notes
| GEO Factor | Score (1-10) | Notes |
Definitions, Quotable statements, Factual density, Citations, Q&A, Authority.
**GEO Readiness**: X/10
```

## Tips

Specify content type explicitly (affects CORE-EEAT weights). Run `/seo:keyword-research` first for competitive keywords. After publishing, run `/seo:audit-page` to verify.

## Related Skills

- [seo-content-writer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/seo-content-writer/SKILL.md) | [geo-content-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/geo-content-optimizer/SKILL.md) | [keyword-research](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/research/keyword-research/SKILL.md) | [content-quality-auditor](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/content-quality-auditor/SKILL.md)
