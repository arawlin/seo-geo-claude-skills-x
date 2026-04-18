# Chinese Beginner Crypto Site Launch Playbook

This document is also available in [Chinese](./chinese-beginner-crypto-site-launch-playbook-zh.md).

## Mandatory Operating Addenda

Use this section as the launch gate for the MVP batch. If any lighter checklist language elsewhere conflicts with the rules below, this section wins.

### 1. Trust And Disclosure Standard

- Any page with affiliate or rebate links must place a disclosure above or at the first monetized link, visible on first render, using explicit wording such as `affiliate`, `paid`, or `earn a commission`.
- Affiliate links should use `rel="sponsored nofollow"` unless a stricter site-wide policy already exists.
- The first public launch must include a privacy policy, terms of service, editorial policy, correction and update policy, contact page with at least two contact methods, and a market-risk disclaimer page.
- Every exchange, fee, bonus, rebate, KYC, or withdrawal page must show a last verified date, verification scope, and reviewer name or role.
- Treat missing disclosure, missing trust pages, or stale high-risk claims as publish blockers.

### 2. Evidence Logging Standard

- Every factual claim that can change quickly needs a matching evidence row before publication. This includes trading fees, rebate rates, signup bonuses, identity verification rules, withdrawal limits, supported countries, and screenshots of product flows.
- Minimum record fields: claim ID, page slug, claim text, source URL, source type, checked at, checked by, screenshot or archive path, publish status, and next review trigger.
- Separate automated collection from manual verification. If a number is estimated, label it as estimated and do not present it as verified.
- Keep the evidence log next to the editorial workflow and save dated summaries into memory when you use the skills.
- Use [crypto-site-evidence-ledger-template.md](./crypto-site-evidence-ledger-template.md) as the default format.

### 3. Entity And Brand Foundation

- Before scaling commercial pages, finalize one canonical brand profile: organization name, short description, long description, logo, founder or editor names, author bios, and social or account links.
- Publish an About page and author pages that use the same brand facts as Organization and Person schema.
- Run `entity-optimizer` for the brand, then use the output to align About copy, author boxes, schema, and CMS defaults.
- If the brand can be confused with another trading site, add an explicit disambiguation line on the About page, author pages, and key landing pages.
- Treat entity drift between site copy, schema, and third-party profiles as a launch issue, not a later polish task.

### 4. Site-Wide Launch QA And Rollback Rules

- Run a site-wide technical check on staging or preview before launch across the homepage, article template, comparison template, tool template, and all trust pages.
- Verify robots, sitemap, canonicals, `noindex` state, metadata parity, `H1`, schema validity, internal links, breadcrumbs, mobile rendering, and Core Web Vitals for each template family.
- On launch day, confirm there is no accidental blocking directive, resubmit the sitemap, inspect representative URLs, and watch `5xx` and `404` spikes.
- Define rollback triggers in advance: blocked crawling, broken canonicals, disclosure rendering failure, schema loss on commercial pages, or abnormal `404` or `5xx` rates.
- Use [crypto-site-launch-qa-checklist.md](./crypto-site-launch-qa-checklist.md) as the release checklist.

### 5. Post-Launch Monitoring And Refresh Loop

- Every launch wave needs an owner, baseline, threshold, and review date for indexation, impressions, clicks, keyword movement, tool CTA clicks, rebate link clicks, Core Web Vitals, and security alerts.
- Review the first launch batch weekly for the first 4 weeks, then shift to a monthly cadence.
- Trigger an immediate refresh when fees, rebates, bonus rules, KYC flow, supported regions, screenshots, or legal wording change.
- Use `/seo:setup-alert` and `/seo:report` after publication. Use `content-refresher` when a page loses freshness, trust, or ranking fit.
- Record the next review date in the page brief and in the evidence ledger so volatile pages do not become stale silently.

### Supporting Appendices

- [crypto-site-evidence-ledger-template.md](./crypto-site-evidence-ledger-template.md)
- [crypto-site-launch-qa-checklist.md](./crypto-site-launch-qa-checklist.md)
- [chinese-beginner-crypto-first-batch-brief-audit.md](./chinese-beginner-crypto-first-batch-brief-audit.md)

## Purpose

This playbook turns the earlier strategy into an execution plan for a
Chinese-first beginner crypto website built on Next.js and Strapi.

The launch scope is intentionally narrow:

- 12 launch content pages
- 3 tool pages
- 1 repeatable workflow for research, writing, review, and publishing

This is a how-to guide for operators who already have the site framework
running and now need to ship the first useful version.

## Audience And Positioning

- Audience: Chinese-speaking beginners entering crypto for the first time
- Site promise: help readers complete their first safe trade, reduce avoidable
  mistakes, and understand fee rebates clearly
- Monetization: exchange rebate links and related conversion pages
- Tone: calm, plain language, risk-aware, beginner-friendly

## MVP Boundaries

Include these in the launch MVP:

- onboarding tutorials
- exchange choice and fee-saving pages
- first-trade workflow pages
- risk and scam prevention pages
- lightweight decision tools

Do not include these in the initial launch wave:

- daily market analysis as a core acquisition channel
- advanced leverage or derivatives education beyond warnings and basic
  explanation
- large token libraries
- heavy community operations or paid membership flows
- complex dashboards that require a lot of real-time infrastructure

## Success Criteria

The MVP is ready when all of the following are true:

- 12 content pages are live
- 3 tool pages are live
- About, Disclaimer, Privacy, and Update Policy pages are live
- each content page links to exactly one next-step page
- every page has title, meta description, FAQ section when useful, and matching
  schema markup
- every page passes content audit and technical pre-publish check
- each page has a visible risk note, last verified date, and disclosure when
  affiliate links are present

## How This Repository Fits The Workflow

Use this repository as the content operating system, not as the whole business
stack.

- Next.js handles templates, routing, and tool interactions
- Strapi stores content models, SEO fields, FAQs, update dates, and tool copy
- this skills library handles research, drafting, metadata, schema, auditing,
  and memory of decisions

Use commands first. Drop to individual skills only when you need tighter
control.

| Layer | Use It For | Primary Entry |
| ------ | ------------ | --------------- |
| Research | keyword discovery, competitor review, content gaps | [keyword-research](../commands/keyword-research.md) |
| Build | draft the page body, GEO pass, title and meta work | [write-content](../commands/write-content.md), [optimize-meta](../commands/optimize-meta.md) |
| Structured data | FAQ, Article, HowTo, Organization, Breadcrumb | [generate-schema](../commands/generate-schema.md) |
| Review | content quality, on-page quality, technical checks | [audit-page](../commands/audit-page.md), [check-technical](../commands/check-technical.md) |
| Memory | save launch progress, open loops, priority keywords | [memory-management](../cross-cutting/memory-management/SKILL.md) |

If slash commands are unavailable in your current agent, use the equivalent
skill prompt directly.

## Standard Page Workflow

Apply this workflow to every content page unless the task card says otherwise.

### Step 1: Run Keyword Research

Use [keyword-research](../commands/keyword-research.md) to confirm the main
query, the audience, and the business goal.

Example:

```text
/seo:keyword-research "新手怎么买比特币" audience="中文区新手" goal="返佣" authority="low" competitors="cryptotradingcafe.com"
```

Capture:

- primary keyword
- 3 to 5 secondary keywords
- search intent
- likely competing pages
- suggested content type

### Step 2: Review One Strong Competitor

Use [competitor-analysis](../research/competitor-analysis/SKILL.md) when you
need to understand how a competitor frames the same topic.

Example prompt:

```text
Analyze SEO strategy for https://cryptotradingcafe.com around "新手怎么买比特币". Focus on beginner onboarding, trust signals, and rebate conversion.
```

Capture:

- what the competitor covers well
- what is weak, vague, or too broad
- which trust signals they surface
- what you can do more clearly for beginners

### Step 3: Find The Gap

Use [content-gap-analysis](../research/content-gap-analysis/SKILL.md) to avoid
rewriting the same article with slightly different wording.

Example prompt:

```text
Find content gaps between my site and cryptotradingcafe.com for Chinese beginner crypto onboarding.
```

Capture:

- missing sections
- missing format types such as checklists, calculators, or comparison tables
- missing risk explanations
- missing next-step links

### Step 4: Create A Brief In Strapi

Before drafting, fill these fields in Strapi:

- working title
- slug
- primary keyword
- secondary keywords
- audience
- intent
- page type
- CTA
- disclaimer flag
- last verified date
- FAQ block
- related pages

### Step 5: Draft The Page

Use [write-content](../commands/write-content.md) first. It already chains the
SEO writer and GEO optimizer.

Example:

```text
/seo:write-content "新手如何完成第一笔比特币购买" keyword="新手怎么买比特币" type="how-to guide"
```

After the draft comes back, add your own manual edits for:

- region-specific instructions
- platform rule verification
- compliance-safe phrasing
- your brand voice and disclosure wording

### Step 6: Optimize Title And Description

Use [optimize-meta](../commands/optimize-meta.md).

Example:

```text
/seo:optimize-meta "新手如何完成第一笔比特币购买" keyword="新手怎么买比特币"
```

### Step 7: Generate Structured Data

Use [generate-schema](../commands/generate-schema.md).

Common patterns:

- Article + FAQ for tutorials and explainers
- HowTo + FAQ for step-based guides
- WebPage + FAQ for tool pages

Examples:

```text
/seo:generate-schema Article for 新手如何完成第一笔比特币购买
/seo:generate-schema FAQ for 新手如何完成第一笔比特币购买
```

### Step 8: Audit The Page Before Publish

Use [audit-page](../commands/audit-page.md).

Example:

```text
/seo:audit-page [draft text or preview URL] keyword="新手怎么买比特币"
```

Fix anything that affects:

- intent match
- unclear promises
- disclosure quality
- missing evidence or missing steps
- weak FAQ or poor internal linking

### Step 9: Run The Technical Check

Use [check-technical](../commands/check-technical.md) on the preview URL.

Example:

```text
/seo:check-technical https://preview.example.com/first-bitcoin-purchase
```

### Step 10: Save The Decision Trail

After publishing a page or finishing a wave, save what you learned using
[memory-management](../cross-cutting/memory-management/SKILL.md).

Example prompt:

```text
Save project progress for beginner crypto launch week 1. Store hero keywords, completed pages, open loops, and next priorities.
```

## Foundation Tasks Before The 12 Plus 3 Launch Scope

These tasks are required but are not counted inside the 12 content pages and
3 tool pages.

### F1: Create Strapi Content Models

Deliverables:

- Article content type
- Tool page content type
- FAQ component
- Disclosure component
- Update log component

Recommended Article fields:

- title
- slug
- summary
- primary_keyword
- secondary_keywords
- audience
- intent
- page_type
- hero_cta
- main_body
- faq_items
- seo_title
- meta_description
- og_title
- og_description
- schema_types
- last_verified_at
- risk_note
- disclosure_text
- related_articles
- next_step_article

Recommended Tool Page fields:

- title
- slug
- intro
- who_it_is_for
- who_should_not_use_it
- input_labels
- result_states
- explanation_copy
- faq_items
- seo_title
- meta_description
- schema_types
- risk_note
- disclosure_text
- last_verified_at
- related_articles

Steps:

1. Create the Article model and Tool model in Strapi.
2. Add reusable components for FAQ, disclosure, risk note, and update history.
3. Make primary keyword, intent, CTA, and last verified date required fields.
4. Add a review status field with Draft, In Review, Ready For QA, Ready To
   Publish, Published.
5. Prepare one entry template for each page type.

### F2: Publish Trust Pages

Required pages:

- About
- Disclaimer and affiliate disclosure
- Privacy policy
- Update and verification policy

Steps:

1. Draft each page manually first.
2. Use [optimize-meta](../commands/optimize-meta.md) for title and meta.
3. Use [generate-schema](../commands/generate-schema.md) for Organization or
   WebPage schema where appropriate.
4. Use [audit-page](../commands/audit-page.md) for clarity and trust checks.

### F3: Define Navigation And CTA Rules

Rules:

- homepage routes users into exactly three paths: complete beginner,
  choosing an exchange, making a first purchase
- each page must have one primary CTA and one next-step page
- exchange pages may contain rebate CTAs, but must also contain risk and rule
  verification notes

### F4: Create Reusable Content Blocks

Create blocks for:

- TL;DR summary
- who this is for
- who should not follow this page
- risk warning
- FAQ
- next-step CTA
- last verified date
- disclosure banner

### F5: Create A QA Queue

For each page, require these checks before publish:

- content draft complete
- meta complete
- schema complete
- content audit passed
- technical check passed
- internal links added
- disclosure reviewed manually

## Launch Wave 1: Shortest Conversion Path

Wave 1 must help a beginner understand the site, choose a platform, and start
registration.

### C01: Newcomer Hub

- Page type: pillar guide
- Goal: central navigation page for all beginner flows
- Primary keyword: 新手炒币入门
- CTA: choose your exchange

Steps:

1. Run keyword research for beginner onboarding.
2. Review competitor onboarding hubs.
3. Draft a long-form guide with clear step sections.
4. Add links to exchange comparison, registration guides, first purchase,
   scam prevention, and risk management.
5. Generate Article and FAQ schema.
6. Audit the page and fix clarity gaps.

### C02: Binance Vs OKX For Chinese Beginners

- Page type: comparison
- Goal: decision page with trust and fee transparency
- Primary keyword: 币安和欧易哪个好
- CTA: go to the recommended registration tutorial

Steps:

1. Run keyword research.
2. Run competitor analysis focused on trust and beginner messaging.
3. Draft a comparison table covering ease of use, app availability, product
   depth, fees, KYC friction, and support considerations.
4. Add a section on who should choose each platform.
5. Add a section on fee rebates, with disclosure.
6. Generate FAQ schema.
7. Audit and publish.

### C03: Binance Registration Tutorial For Chinese Beginners

- Page type: how-to guide
- Goal: rebate conversion page with high trust
- Primary keyword: 币安注册教程
- CTA: register through the verified link

Steps:

1. Research keyword variants.
2. Manually verify current registration steps before drafting.
3. Draft the tutorial with screenshots or screenshot placeholders.
4. Add sections for who can use it, current caveats, and common mistakes.
5. Add FAQ about referral code, app download, KYC, and troubleshooting.
6. Add Article and FAQ schema.
7. Run audit and technical checks.

### C04: OKX Registration Tutorial For Chinese Beginners

- Page type: how-to guide
- Goal: rebate conversion page with alternative path coverage
- Primary keyword: 欧易注册教程
- CTA: register through the verified link

Steps:

1. Repeat the same workflow as C03.
2. Do not reuse Binance wording without adapting platform-specific rules.
3. Verify each step manually again before publish.

### T01: Exchange Selector

- Page type: tool page
- Goal: give beginners a simple answer to which platform fits them
- CTA: go to Binance or OKX tutorial

Minimum product logic:

- user selects comfort level, trading goal, preference for simplicity,
  preference for low friction, and need for fee rebates
- result recommends one platform and explains why

Steps:

1. Draft the decision logic in plain language first.
2. Build the result states in Next.js.
3. Store tool intro, question labels, answer labels, result copy, FAQs,
   disclosure, and update date in Strapi.
4. Use [write-content](../commands/write-content.md) to draft the explanation
   copy around the tool.
5. Use [generate-schema](../commands/generate-schema.md) for WebPage and FAQ.
6. Audit the tool page copy.

## Launch Wave 2: First Transaction Path

Wave 2 must help a registered user understand money-in, first purchase, and
why rebates matter.

### C05: How To Buy USDT With CNY

- Page type: tutorial
- Goal: explain the first funding step clearly
- Primary keyword: 人民币怎么买USDT
- CTA: continue to first Bitcoin purchase

Steps:

1. Research the keyword and supporting questions.
2. Verify platform-specific funding steps manually.
3. Draft the guide with step sequence, common mistakes, and risk note.
4. Add FAQ about payment methods, delays, limits, and safety.
5. Add HowTo or Article schema plus FAQ schema.
6. Audit before publish.

### C06: How To Buy Your First Bitcoin

- Page type: how-to guide
- Goal: help the user complete the first safe purchase
- Primary keyword: 新手怎么买比特币
- CTA: read the beginner portfolio guide

Steps:

1. Run keyword research.
2. Review top ranking pages and note common sections.
3. Draft the guide with simple language and a clear warning against leverage.
4. Add a checklist box before the buy step.
5. Add FAQ and Article schema.
6. Audit and publish.

### C07: What Fee Rebates And Referral Codes Actually Mean

- Page type: explainer
- Goal: remove confusion and improve conversion trust
- Primary keyword: 返佣是什么意思
- CTA: open the fee savings calculator

Steps:

1. Run keyword research.
2. Review competitor rebate pages and note weak explanations.
3. Draft an explainer that covers automatic versus manual rebate handling,
   where savings come from, and what users should verify.
4. Add disclosure language and a verification checklist.
5. Add FAQ schema.
6. Audit before publish.

### C08: Exchange Fee Comparison And How Beginners Save Money

- Page type: comparison page
- Goal: reinforce the cost-saving position
- Primary keyword: 交易所手续费对比
- CTA: use the rebate savings calculator

Steps:

1. Run keyword research.
2. Collect current fee data manually and label the verification date.
3. Draft the page with a clear comparison table.
4. Add sections for spot, contract, and hidden cost considerations.
5. Add FAQ schema and internal links to rebate pages.
6. Audit before publish.

### T02: Rebate Savings Calculator

- Page type: tool page
- Goal: turn fee rebate into a concrete money-saving outcome
- CTA: move to the registration page that matches the user

Minimum product logic:

- inputs: monthly trading volume, fee rate, rebate percentage
- outputs: monthly savings, yearly savings, break-even explanation

Steps:

1. Define the calculator formula and edge cases.
2. Build the UI in Next.js.
3. Store labels, help text, examples, FAQs, and result explanation copy in
   Strapi.
4. Use [write-content](../commands/write-content.md) to draft the surrounding
   explanatory content.
5. Add WebPage and FAQ schema.
6. Audit the page copy and run a technical check.

## Launch Wave 3: Risk And Trust Path

Wave 3 must prove that the site is not only trying to convert, but also trying
to protect beginners from obvious mistakes.

### C09: Spot Vs Futures For Beginners

- Page type: explainer
- Goal: make beginners avoid leverage too early
- Primary keyword: 现货和合约的区别
- CTA: read the risk management guide

Steps:

1. Research keyword variants.
2. Draft an explainer with concrete examples of downside risk.
3. Keep the page balanced and avoid glamorizing leverage.
4. Add FAQ about liquidation, volatility, and why beginners should wait.
5. Audit before publish.

### C10: What Should A Beginner Buy First

- Page type: explainer
- Goal: solve the first allocation question
- Primary keyword: 新手第一笔买什么币
- CTA: read the Bitcoin purchase guide

Steps:

1. Run keyword research.
2. Draft a page that frames the choice around simplicity, volatility, and risk
   tolerance.
3. Avoid making promises about returns.
4. Add FAQ and internal links to the USDT and Bitcoin guides.
5. Audit before publish.

### C11: Beginner Scam Prevention Checklist

- Page type: checklist guide
- Goal: build trust and strong save/share value
- Primary keyword: 币圈新手防骗
- CTA: complete the first-trade readiness checklist

Steps:

1. Run keyword research.
2. Review competitor coverage and note blind spots.
3. Draft a checklist with concrete red flags and actions.
4. Add examples of fake support, fake teachers, phishing links, and fake
   exchanges.
5. Add FAQ schema.
6. Audit before publish.

### C12: Beginner Risk Management Basics

- Page type: guide
- Goal: position the brand around survival and caution
- Primary keyword: 炒币风险管理
- CTA: return to the newcomer hub

Steps:

1. Run keyword research.
2. Draft a guide covering position sizing, loss limits, no leverage, and no
   all-in behavior.
3. Use clear numbers and examples instead of vague warnings.
4. Add FAQ schema.
5. Audit before publish.

### T03: First Trade Readiness Checklist

- Page type: tool page
- Goal: tell the user if they are ready to place the first trade safely
- CTA: go to the first Bitcoin purchase guide or risk page depending on result

Minimum product logic:

- checklist items: verified account, 2FA enabled, exchange chosen, funding path
  understood, spot versus futures understood, dedicated payment method ready,
  scam basics understood
- outputs: ready, almost ready, not ready

Steps:

1. Define each readiness question and scoring rule.
2. Build the UI in Next.js.
3. Store all labels, help text, FAQs, and result copy in Strapi.
4. Draft the explanation copy using [write-content](../commands/write-content.md).
5. Add WebPage and FAQ schema.
6. Audit and run the technical check.

## Weekly Execution Plan

### Week 0

- finish foundation tasks F1 to F5
- run one full research pass for the first wave
- finalize the article and tool templates in Strapi

### Week 1

- publish C01 to C04 and T01
- review internal linking between these pages
- save launch memory after the wave

### Week 2

- publish C05 to C08 and T02
- verify all fee and rebate references again before publish
- save launch memory after the wave

### Week 3

- publish C09 to C12 and T03
- add homepage sections pointing into all three user paths
- save launch memory after the wave

### Week 4

- rerun audits on all 15 pages
- tighten internal links and next-step CTAs
- add update logs and missing disclosures
- decide whether daily market analysis is ready for phase 2

## Definition Of Done For Every Page

A page is done only if all of the following are true:

- Strapi entry is complete
- body copy is edited and not just AI output
- primary CTA is clear
- risk note is visible
- disclosure is visible when needed
- last verified date is present
- title and meta description are finalized
- schema markup matches visible content
- page passes content audit
- page passes technical check
- page links to one next-step page

## What To Save In Project Memory

After each wave, save:

- top 5 hero keywords
- pages completed this week
- pages blocked by missing verification
- unresolved competitor gaps
- next wave priority list

Good prompt:

```text
Save project progress for beginner crypto site launch. Store completed pages, hero keywords, blocked items, and next wave priorities.
```

## Quality And Compliance Notes

- always verify exchange rules, referral conditions, and region-specific steps
  manually before publish
- never publish rebate claims without a verification date
- do not publish promises of profit or guaranteed outcomes
- do not let the page tone become more aggressive than the actual brand promise
- tool pages should explain limits, not only outputs
- FAQ schema must match visible FAQ content exactly

## Phase 2 After The MVP

Only after the 12 plus 3 launch set is stable should you expand into:

- daily market commentary
- deeper coin-specific education pages
- more exchange pages
- glossary expansion
- beginner email or Telegram onboarding flows
