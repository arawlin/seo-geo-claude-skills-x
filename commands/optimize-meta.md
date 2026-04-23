---
name: optimize-meta
description: Optimize title tags, meta descriptions, and Open Graph tags for a page
argument-hint: "<URL or page details>"
parameters:
  - name: source
    type: string
    required: true
    description: URL or page details to optimize
  - name: keyword
    type: string
    required: false
    description: Target keyword
  - name: mode
    type: string
    required: false
    description: "Set to 'a/b-test' to generate multiple variants for testing"
---

# Optimize Meta Command

Analyzes and enhances **title tags, meta descriptions, and social media tags** to maximize click-through rates and search visibility.

## Usage

```
/seo:optimize-meta https://example.com/landing-page
/seo:optimize-meta title="Current Title" keyword="target keyword"
/seo:optimize-meta url="..." mode="a/b-test"
```

**Arguments:** URL or page details (required) + optional `keyword=` + optional `mode="a/b-test"`.

## Workflow

1. **Analyze Current Meta Tags** -- Invoke `meta-tags-optimizer`. Evaluates title, meta description, OG/Twitter Card tags for length, keyword placement, CTR appeal, completeness.
2. **Generate Optimized Variants** -- 3-5 title and 3-5 description variants with scoring.
3. **Compile Output** -- Before/after comparison, implementation code, A/B test recommendations (if mode="a/b-test").

## Output Format

```markdown
## META TAG OPTIMIZATION REPORT

**Page**: [URL or Title] | **Target Keyword**: [keyword]

### Current Meta Tags Analysis
Title Tag X/10, Meta Description X/10, Social Tags X/10 -- current values, lengths, issues.

### Optimized Title Tag Variants
Recommended + 2-3 variants with length, score, rationale.

### Optimized Meta Description Variants
Recommended + 1-2 variants with length, score.

### Implementation Code
Copy-paste HTML: title, meta description, OG tags, Twitter Card tags.

### A/B Test Recommendations (when mode="a/b-test")
Test setup, control vs variant, hypothesis.
```

## Tips

Front-load primary keyword in first half of title. Include CTA in every meta description. Add year to titles for recurring topics (+3-8% CTR). Test variants for 4+ weeks.

## Related Skills

- [meta-tags-optimizer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/meta-tags-optimizer/SKILL.md) | [seo-content-writer](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/build/seo-content-writer/SKILL.md)
