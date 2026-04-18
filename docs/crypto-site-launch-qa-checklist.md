# Crypto Site Launch QA Checklist

This document is also available in [Chinese](./crypto-site-launch-qa-checklist-zh.md).

## When To Use

Use this checklist before the first public launch, before publishing a batch of 5 or more pages, after template changes, and after any monetization or schema rollout.

## Release Gate

- [ ] Launch inventory is frozen for this batch.
- [ ] Owners are assigned for engineering, content, review, and monitoring.
- [ ] Homepage, article template, comparison template, tool template, and trust pages are all included in scope.
- [ ] Rollback owner and rollback trigger are documented.

## Trust And Policy Checks

- [ ] Privacy policy is live.
- [ ] Terms of service are live.
- [ ] Editorial policy is live.
- [ ] Correction and update policy is live.
- [ ] Contact page has at least two contact methods.
- [ ] Market-risk disclaimer is live.
- [ ] Affiliate disclosure is visible above or at the first monetized link.
- [ ] Affiliate links use `rel="sponsored nofollow"`.
- [ ] Every commercial page shows last verified date and reviewer.

## Staging Or Preview Checks

- [ ] `robots.txt` for production is reviewed and does not block important paths.
- [ ] `sitemap.xml` exists and lists indexable URLs only.
- [ ] No important template ships with `noindex`.
- [ ] Canonical tags are correct for homepage, article, comparison, tool, and trust templates.
- [ ] Titles, meta descriptions, `H1`, and schema are present for every template family.
- [ ] Breadcrumbs and internal links render correctly.
- [ ] Mobile rendering is checked on representative pages.
- [ ] Core Web Vitals are reviewed for each template family.
- [ ] Structured data passes validation on representative pages.
- [ ] Disclosure and risk modules render on first load.

## Content And Evidence Checks

- [ ] Every volatile factual claim has a row in the evidence ledger.
- [ ] Screenshots match the live product flow.
- [ ] Fee, rebate, bonus, KYC, and withdrawal statements have current review timestamps.
- [ ] Comparison tables and tool outputs match the verified claims.
- [ ] Page-level last verified dates match the evidence ledger.

## Entity And Brand Checks

- [ ] About page uses the same brand description as CMS defaults and schema.
- [ ] Author pages exist for launch authors.
- [ ] Organization schema is present and current.
- [ ] Person schema is present where author identity matters.
- [ ] Logo, brand name, and social links are consistent across key pages.
- [ ] Brand disambiguation copy exists if the site could be confused with another entity.

## Launch-Day Checks

- [ ] Production deploy completed without template regressions.
- [ ] No accidental blocking directive exists in production.
- [ ] Sitemap is submitted or resubmitted.
- [ ] Representative URLs are manually inspected after deploy.
- [ ] `404` and `5xx` rates are monitored during the first hours after launch.
- [ ] CTA links, rebate links, and tool forms are manually tested.
- [ ] Disclosure, disclaimer, and reviewer metadata render correctly in production.

## Post-Launch Checks

### T+1

- [ ] Check indexability of representative URLs.
- [ ] Check crawl errors and server errors.
- [ ] Confirm pages are loading with correct canonicals and schema.
- [ ] Confirm alerts are active for rankings, traffic, Core Web Vitals, and security.

### T+7

- [ ] Review impressions, clicks, and initial keyword movement.
- [ ] Review tool CTA clicks and rebate link clicks.
- [ ] Recheck top commercial pages for disclosure, freshness, and screenshot match.
- [ ] Recheck evidence rows that had `review-needed` status.

### T+30

- [ ] Review index coverage and URL health at batch level.
- [ ] Review performance by template family.
- [ ] Refresh or rewrite pages whose claims, screenshots, or search fit are already stale.
- [ ] Decide whether the batch is safe to scale into the next launch wave.

## Rollback Triggers

- [ ] Important pages are blocked by `robots.txt` or `noindex`.
- [ ] Canonicals point to the wrong URLs.
- [ ] Disclosure or risk modules fail to render.
- [ ] Schema disappears from commercial templates.
- [ ] `404` or `5xx` rates spike above the agreed threshold.
- [ ] Critical CTA, rebate, or tool flows fail in production.

## Suggested Skill Sequence

1. Run `/seo:check-technical` on staging or the production domain.
2. Run `/seo:audit-page` on the homepage and top commercial pages.
3. Run `/seo:generate-schema` if template schema is missing or invalid.
4. Run `entity-optimizer` if brand, author, or organization data drift is visible.
5. Run `/seo:setup-alert` before launch closes.
6. Run `/seo:report` at T+7 and T+30.

## Companion Documents

- [crypto-site-evidence-ledger-template.md](./crypto-site-evidence-ledger-template.md)
- [chinese-beginner-crypto-site-launch-playbook.md](./chinese-beginner-crypto-site-launch-playbook.md)
