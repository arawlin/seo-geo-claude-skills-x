# Technical SEO Checker — Compact Output Templates

Use one reporting shape everywhere: **evidence -> checks -> issues -> fixes -> score**. Keep only the sections you actually tested.

## Shared Conventions

| Item | Rule |
|------|------|
| Status | `✅` pass, `⚠️` partial risk, `❌` fail |
| Severity | `P0` blocks indexing/revenue, `P1` materially suppresses performance, `P2` hygiene |
| Evidence | Cite source, crawl date, sample size, and representative URLs |
| Actions | Name the fix, expected impact, and owner if known |
| Score | Use `/10` per step; mark unsupported checks `N/A` |

## Step Map

| Step | Focus | Must Capture | Common Blockers |
|------|-------|--------------|-----------------|
| 1 | Crawlability | robots.txt, sitemap, crawl sample | blocked templates, crawl waste, chains, orphans |
| 2 | Indexability | coverage ratio, blockers, canonicals | noindex, canonical conflicts, 4xx/5xx |
| 3 | Performance | CWV + supporting metrics | LCP bloat, JS, fonts, server latency |
| 4 | Mobile | viewport, parity, tap targets | missing mobile content, layout overflow |
| 5 | Security | HTTPS, mixed content, headers | weak redirects, expired certs, CSP gaps |
| 6 | URL structure | patterns, redirects, consistency | parameters, uppercase, loops |
| 7 | Structured data | current schema, errors, opportunities | invalid JSON-LD, wrong type, missing required fields |
| 8 | International | hreflang, locale targeting | missing return tags, bad language codes |
| 9 | Summary | scorecard, queue, roadmap | unclear priorities, no owner, no monitoring plan |

## Step 1: Audit Crawlability

```markdown
## Crawlability

**Evidence**: robots.txt=[URL] | sitemap=[URL] | crawl sample=[X URLs/pages]

**robots.txt snapshot**
```txt
[current robots.txt directives or notable lines]
```

| robots.txt check | Status | Evidence | Action |
|------------------|--------|----------|--------|
| File exists and parses | ✅/⚠️/❌ | [notes] | [fix] |
| Sitemap declared | ✅/⚠️/❌ | [notes] | [fix] |
| Important templates not blocked | ✅/⚠️/❌ | [notes] | [fix] |
| CSS/JS/assets not unintentionally blocked | ✅/⚠️/❌ | [notes] | [fix] |

**Recommended robots.txt patch**
```txt
[updated robots.txt snippet if needed]
```

| sitemap check | Status | Evidence | Action |
|---------------|--------|----------|--------|
| Sitemap is discoverable | ✅/⚠️/❌ | [notes] | [fix] |
| XML is valid | ✅/⚠️/❌ | [notes] | [fix] |
| Only indexable URLs included | ✅/⚠️/❌ | [notes] | [fix] |
| `lastmod` is present and trustworthy | ✅/⚠️/❌ | [notes] | [fix] |

| crawl-budget check | Status | Evidence | Action |
|--------------------|--------|----------|--------|
| Important templates crawlable | ✅/⚠️/❌ | [notes] | [fix] |
| Crawl waste controlled | ✅/⚠️/❌ | [duplicates/orphans/chains] | [fix] |

**Issues**
- **P0** [Issue] — [affected URLs/pattern] — [fix]
- **P1** [Issue] — [scope] — [fix]

**Score**: [X]/10
```

## Step 2: Audit Indexability

```markdown
## Indexability

**Evidence**: sitemap pages=[X] | indexed pages=[X] | coverage=[X]%

| Check | Status | Evidence | Action |
|------|--------|----------|--------|
| Noindex/X-Robots blocks intentional | ✅/⚠️/❌ | [notes] | [fix] |
| Canonicals are self-consistent | ✅/⚠️/❌ | [notes] | [fix] |
| 4xx/5xx/loops are controlled | ✅/⚠️/❌ | [notes] | [fix] |
| Duplicate clusters resolved | ✅/⚠️/❌ | [notes] | [fix] |

**Issues**
- **P0** [Issue] — [scope] — [fix]
- **P1** [Issue] — [scope] — [fix]

**Score**: [X]/10
```

## Step 3: Audit Site Speed & Core Web Vitals

```markdown
## Performance

| Metric | Mobile | Desktop | Target | Status |
|--------|--------|---------|--------|--------|
| LCP | [X]s | [X]s | <2.5s | ✅/⚠️/❌ |
| INP | [X]ms | [X]ms | <200ms | ✅/⚠️/❌ |
| CLS | [X] | [X] | <0.1 | ✅/⚠️/❌ |
| TTFB | [X]ms | [X]ms | <800ms | ✅/⚠️/❌ |

| Resource | Count | Size | Main Blocker |
|----------|-------|------|--------------|
| Images | [X] | [X]MB | [notes] |
| JavaScript | [X] | [X]MB | [notes] |
| CSS/fonts | [X] | [X]KB | [notes] |

**High-impact fixes**
1. [Fix] — est. impact [metric improvement]
2. [Fix] — est. impact [metric improvement]

**Score**: [X]/10
```

## Step 4: Audit Mobile-Friendliness

```markdown
## Mobile

| Check | Status | Evidence | Action |
|------|--------|----------|--------|
| Viewport configured | ✅/⚠️/❌ | [notes] | [fix] |
| Text and tap targets usable | ✅/⚠️/❌ | [notes] | [fix] |
| No horizontal overflow | ✅/⚠️/❌ | [notes] | [fix] |
| Mobile has content/meta/schema parity | ✅/⚠️/❌ | [notes] | [fix] |

**Issues**
- **P1** [Issue] — [scope] — [fix]

**Score**: [X]/10
```

## Step 5: Audit Security & HTTPS

```markdown
## Security

| Check | Status | Evidence | Action |
|------|--------|----------|--------|
| SSL certificate valid | ✅/⚠️/❌ | [expiry/notes] | [fix] |
| HTTPS forced site-wide | ✅/⚠️/❌ | [redirect notes] | [fix] |
| Mixed content resolved | ✅/⚠️/❌ | [count/examples] | [fix] |
| HSTS configured appropriately | ✅/⚠️/❌ | [header/max-age/preload notes] | [fix] |
| Security headers reasonable | ✅/⚠️/❌ | [missing headers] | [fix] |

**Issues**
- **P0** [Issue] — [scope] — [fix]
- **P2** [Issue] — [scope] — [fix]

**Score**: [X]/10
```

## Step 6: Audit URL Structure

```markdown
## URL Structure

| Check | Status | Evidence | Action |
|------|--------|----------|--------|
| Canonical host/protocol enforced | ✅/⚠️/❌ | [notes] | [fix] |
| URL format readable and stable | ✅/⚠️/❌ | [notes] | [fix] |
| Parameters/sessions controlled | ✅/⚠️/❌ | [notes] | [fix] |
| Redirect chains and loops minimized | ✅/⚠️/❌ | [notes] | [fix] |

**Issues**
- **P1** [Issue] — [scope] — [fix]

**Score**: [X]/10
```

## Step 7: Audit Structured Data

Schema quality aligns to CORE-EEAT `O05`, so report both implementation correctness and missing opportunities.

```markdown
## Structured Data

| Schema Type | Pages | Valid | Errors/Warnings |
|-------------|-------|-------|-----------------|
| [Type] | [X] | ✅/⚠️/❌ | [notes] |
| [Type] | [X] | ✅/⚠️/❌ | [notes] |

| Opportunity | Current | Recommended | Why |
|-------------|---------|-------------|-----|
| Blog/article | [current] | Article + FAQ | [reason] |
| Product | [current] | Product + Review | [reason] |
| Homepage | [current] | Organization | [reason] |

**Issues**
- **P1** [Validation error] — [scope] — [fix]

**Score**: [X]/10
```

## Step 8: Audit International SEO

```markdown
## International SEO

| Check | Status | Evidence | Action |
|------|--------|----------|--------|
| Hreflang tags present where needed | ✅/⚠️/❌ | [notes] | [fix] |
| Return tags and self-references valid | ✅/⚠️/❌ | [notes] | [fix] |
| Language/region codes valid | ✅/⚠️/❌ | [notes] | [fix] |
| x-default / locale targeting sensible | ✅/⚠️/❌ | [notes] | [fix] |

**Examples**
- `[locale]` -> `[URL]` -> [status]

**Score**: [X]/10
```

## Step 9: Generate Technical Audit Summary

```markdown
# Technical SEO Audit Report

**Domain**: [domain]
**Audit date**: [YYYY-MM-DD]
**Pages analyzed**: [X]

| Area | Score | Top Blocker | First Fix |
|------|:-----:|-------------|-----------|
| Crawlability | [X]/10 | [issue] | [fix] |
| Indexability | [X]/10 | [issue] | [fix] |
| Performance | [X]/10 | [issue] | [fix] |
| Mobile | [X]/10 | [issue] | [fix] |
| Security | [X]/10 | [issue] | [fix] |
| URL structure | [X]/10 | [issue] | [fix] |
| Structured data | [X]/10 | [issue] | [fix] |
| International (optional) | [X]/10 | [issue] | [fix] |

## Priority Queue

| Priority | Issue | Scope | Fix | ETA |
|----------|-------|-------|-----|-----|
| P0 | [Issue] | [scope] | [fix] | [time] |
| P1 | [Issue] | [scope] | [fix] | [time] |
| P2 | [Issue] | [scope] | [fix] | [time] |

## Quick Wins

- [Quick win 1]
- [Quick win 2]
- [Quick win 3]

## 30-Day Roadmap

- **Week 1**: [critical fixes]
- **Week 2-3**: [high-priority fixes]
- **Week 4+**: [optimization and monitoring]

## Monitoring

- Core Web Vitals drops
- Crawl error spikes
- Index coverage changes
- Security regressions
```
