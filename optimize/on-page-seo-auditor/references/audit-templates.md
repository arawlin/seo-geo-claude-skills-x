# On-Page SEO Auditor -- Compact Output Templates

Use the same reporting shape across the audit: **evidence -> checks -> issues -> fix -> score**. Keep only the sections that match the page type.

## Shared Conventions

| Item | Rule |
|------|------|
| Status | `✅` pass, `⚠️` partial risk, `❌` fail |
| Severity | `P0` blocks ranking/indexing, `P1` suppresses performance, `P2` hygiene |
| Evidence | Cite the page state, crawl date, competitor set, and any inferred keyword |
| Scores | Use `/10` for sections; final report rolls up to `/100` |

## Step Map

| Step | Focus | Must Capture |
|------|-------|--------------|
| 1 | Setup | URL, keyword, page type, goal |
| 2 | Title | length, keyword position, clickability |
| 3 | Meta description | length, CTA, match to intent |
| 4 | Headers | single H1, hierarchy, keyword coverage |
| 5 | Content quality | depth, readability, proof, freshness |
| 6 | Keyword usage | placement, related terms, overuse |
| 7 | Internal links | count, anchor quality, gaps |
| 8 | Images | alt text, file names, size, format |
| 9 | Technical on-page | URL, canonical, speed, mobile, schema |
| 10 | CORE-EEAT quick scan | 17 page-level checks |
| 11 | Summary | priorities, quick wins, checklist |

## Step 1: Gather Page Information

```markdown
### Audit Setup
**Page URL**: [URL]
**Target Keyword**: [primary keyword or inferred keyword]
**Secondary Keywords**: [2-3 supporting terms]
**Page Type**: [blog/product/landing/service]
**Business Goal**: [traffic/conversions/authority]
**Competitor Set**: [top pages compared]
```

## Step 2: Audit Title Tag

```markdown
## Title Tag
**Current Title**: [title]
**Character Count**: [X]

| Check | Status | Notes | Fix |
|-------|--------|-------|-----|
| Length 50-60 chars | ✅/⚠️/❌ | [notes] | [fix] |
| Primary keyword included | ✅/⚠️/❌ | [notes] | [fix] |
| Front-loaded if possible | ✅/⚠️/❌ | [notes] | [fix] |
| Matches intent and earns clicks | ✅/⚠️/❌ | [notes] | [fix] |

**Recommended Title**: "[optimized title]"
**Score**: [X]/10
```

## Step 3: Audit Meta Description

```markdown
## Meta Description
**Current Description**: [description]
**Character Count**: [X]

| Check | Status | Notes | Fix |
|-------|--------|-------|-----|
| Length 150-160 chars | ✅/⚠️/❌ | [notes] | [fix] |
| Keyword present naturally | ✅/⚠️/❌ | [notes] | [fix] |
| CTA or next step included | ✅/⚠️/❌ | [notes] | [fix] |
| Matches page promise | ✅/⚠️/❌ | [notes] | [fix] |

**Recommended Description**: "[optimized description]"
**Score**: [X]/10
```

## Step 4: Audit Header Structure

```markdown
## Headers
**Current Hierarchy**:
- H1: [text]
- H2: [texts]
- H3: [texts]

| Check | Status | Notes | Fix |
|-------|--------|-------|-----|
| Single H1 | ✅/⚠️/❌ | [notes] | [fix] |
| H1 covers target keyword | ✅/⚠️/❌ | [notes] | [fix] |
| Hierarchy is logical | ✅/⚠️/❌ | [notes] | [fix] |
| H2/H3s cover subtopics | ✅/⚠️/❌ | [notes] | [fix] |

**Score**: [X]/10
```

## Step 5: Audit Content Quality

```markdown
## Content Quality
**Word Count**: [X]
**Read Time**: [X] min

| Check | Status | Notes |
|-------|--------|-------|
| Depth vs ranking pages | ✅/⚠️/❌ | [notes] |
| Unique value or original proof | ✅/⚠️/❌ | [notes] |
| Freshness / update status | ✅/⚠️/❌ | [notes] |
| Readability and formatting | ✅/⚠️/❌ | [notes] |
| E-E-A-T signals present | ✅/⚠️/❌ | [notes] |

**Checklist**
- [ ] Intro answers the query early
- [ ] Sections are clearly chunked
- [ ] Examples, stats, or proof blocks exist
- [ ] FAQ / conclusion / CTA exists where relevant

**Score**: [X]/10
```

## Step 6: Audit Keyword Usage

```markdown
## Keyword Usage
**Primary Keyword**: [keyword]
**Density**: [X]%

| Location | Status | Notes |
|----------|--------|-------|
| Title tag | ✅/⚠️/❌ | [notes] |
| Meta description | ✅/⚠️/❌ | [notes] |
| H1 / first 100 words | ✅/⚠️/❌ | [notes] |
| H2/H3s | ✅/⚠️/❌ | [notes] |
| URL slug / image alt text | ✅/⚠️/❌ | [notes] |

**Related terms present**: [list]
**Missing terms**: [list]
**Score**: [X]/10
```

## Step 7: Audit Internal Links

```markdown
## Internal Links
**Total internal links**: [X]

| Check | Status | Notes | Fix |
|-------|--------|-------|-----|
| Sufficient internal links | ✅/⚠️/❌ | [notes] | [fix] |
| Anchor text is descriptive | ✅/⚠️/❌ | [notes] | [fix] |
| Links support topic depth | ✅/⚠️/❌ | [notes] | [fix] |
| No broken or misdirected links | ✅/⚠️/❌ | [notes] | [fix] |

**Recommended additions**
- "[anchor]" -> [destination]

**Score**: [X]/10
```

## Step 8: Audit Images

```markdown
## Images
**Total images**: [X]

| Image | Alt Text | File Name | Size/Format | Lazy Load | Status | Fix |
|-------|----------|-----------|-------------|-----------|--------|-----|
| [image] | [alt or missing] | [filename] | [KB/WebP/JPG] | [yes/no] | ✅/⚠️/❌ | [fix] |

| Image check | Status | Notes | Fix |
|-------------|--------|-------|-----|
| File names are descriptive | ✅/⚠️/❌ | [notes] | [fix] |
| Lazy loading enabled where appropriate | ✅/⚠️/❌ | [notes] | [fix] |

**Score**: [X]/10
```

## Step 9: Audit Technical On-Page Elements

```markdown
## Technical On-Page

| Element | Current Value | Status | Recommendation |
|---------|---------------|--------|----------------|
| URL / slug | [value] | ✅/⚠️/❌ | [notes] |
| Canonical tag | [value] | ✅/⚠️/❌ | [notes] |
| Mobile-friendly | [yes/no] | ✅/⚠️/❌ | [notes] |
| Page speed | [value] | ✅/⚠️/❌ | [notes] |
| HTTPS | [yes/no] | ✅/⚠️/❌ | [notes] |
| Schema markup | [types or none] | ✅/⚠️/❌ | [notes] |

**Score**: [X]/10
```

## Step 10: CORE-EEAT Quick Scan

Reference: [CORE-EEAT Benchmark](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/core-eeat-benchmark.md)

```markdown
## CORE-EEAT Quick Scan

| ID | Check | Status | Notes |
|----|-------|--------|-------|
| C01 | Intent alignment | ✅/⚠️/❌ | [notes] |
| C02 | Direct answer early | ✅/⚠️/❌ | [notes] |
| C09 | FAQ coverage | ✅/⚠️/❌ | [notes] |
| C10 | Semantic closure | ✅/⚠️/❌ | [notes] |
| O01 | Heading hierarchy | ✅/⚠️/❌ | [notes] |
| O02 | Summary box / takeaways | ✅/⚠️/❌ | [notes] |
| O03 | Data tables where needed | ✅/⚠️/❌ | [notes] |
| O05 | Schema markup | ✅/⚠️/❌ | [notes] |
| O06 | Section chunking | ✅/⚠️/❌ | [notes] |
| R01 | Data precision | ✅/⚠️/❌ | [notes] |
| R02 | Citation density | ✅/⚠️/❌ | [notes] |
| R06 | Timestamp freshness | ✅/⚠️/❌ | [notes] |
| R08 | Internal link graph | ✅/⚠️/❌ | [notes] |
| R10 | Content consistency | ✅/⚠️/❌ | [notes] |
| Exp01 | First-person experience | ✅/⚠️/❌ | [notes] |
| Ept01 | Author identity | ✅/⚠️/❌ | [notes] |
| T04 | Disclosure statements | ✅/⚠️/❌ | [notes] |

**Quick Score**: [X]/17 passing
```

## Step 11: Generate Audit Summary

```markdown
# On-Page SEO Audit Report
**Page**: [URL]
**Target Keyword**: [keyword]
**Audit Date**: [YYYY-MM-DD]

| Area | Score | Top Issue | First Fix |
|------|:-----:|-----------|-----------|
| Title | [X]/10 | [issue] | [fix] |
| Meta | [X]/10 | [issue] | [fix] |
| Headers | [X]/10 | [issue] | [fix] |
| Content | [X]/10 | [issue] | [fix] |
| Keywords | [X]/10 | [issue] | [fix] |
| Links | [X]/10 | [issue] | [fix] |
| Images | [X]/10 | [issue] | [fix] |
| Technical | [X]/10 | [issue] | [fix] |
| CORE-EEAT quick scan (scaled) | [scaled score]/20 | [issue] | [fix] |

**Scaling rule**: convert the raw quick-scan result with `scaled score = round(passed_checks / 17 * 20)`.

## Priority Issues
- **P0** [Issue] — [fix]
- **P1** [Issue] — [fix]
- **P2** [Issue] — [fix]

## Quick Wins
- [Change 1]
- [Change 2]

## Competitor Gap Snapshot
| Element | Your Page | Competitor | Gap |
|---------|-----------|------------|-----|
| Word count | [X] | [Y] | [+/-Z] |
| Internal links | [X] | [Y] | [+/-Z] |

## Action Checklist
- [ ] Update title tag
- [ ] Rewrite meta description
- [ ] Improve heading coverage
- [ ] Add internal links / image fixes / schema as needed
```
