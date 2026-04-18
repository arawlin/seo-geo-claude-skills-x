# Chinese Beginner Crypto Site — First Batch Brief Audit

This document is also available in [Chinese](./chinese-beginner-crypto-first-batch-brief-audit-zh.md).

## Scope

This audit reviews the recommended launch batch for a Chinese beginner crypto site: 12 articles and 3 tool pages built around onboarding, fee transparency, safety, and rebate monetization.

If a working title changes later, keep the same page role, evidence standard, and launch gate.

## What Is Fixed vs Flexible

These 12 topics are not permanently locked titles. They are the current recommended launch batch.

Treat the following as fixed for the MVP:

- The site must cover beginner onboarding, exchange selection, fee transparency, security basics, and rebate explanation.
- The launch batch must include a mix of how-to pages, explanation pages, comparison pages, and high-utility tool pages.
- Commercial pages must remain later in the launch order than trust-building educational pages.

Treat the following as flexible until keyword and SERP validation is complete:

- The exact title wording.
- The exact primary keyword.
- Whether one exchange-specific rebate page is swapped for a high-demand beginner topic.
- Whether one tool page becomes a checklist, calculator, or comparison helper.

Recommended locking rule:

- The 12-article launch list is now fixed in its conservative version.
- Exchange-specific rebate pages move to phase 2, after the trust template, disclosure standard, and evidence workflow are proven.
- The three conservative replacements are deposit/withdraw guidance, stablecoin basics, and phishing-avoidance guidance.

## Final Conservative 12-Article Decision

1. A1 Crypto for Beginners: From Zero to the First Spot Trade
2. A2 Binance vs OKX vs Bybit for Beginners: Which Exchange Fits You First
3. A3 Sign-Up and KYC Walkthrough: What You Need, How Long It Takes, Common Failure Reasons
4. A4 How to Buy Your First BTC or USDT: 7-Step Beginner Walkthrough
5. A5 Spot vs Futures vs Margin: What Beginners Should Use First and Avoid First
6. A6 How Crypto Exchange Fees Work: Spot, Futures, Withdrawal, Funding, Hidden Costs
7. A7 What Rebates Really Are and How They Change Your Real Trading Cost
8. A8 Beginner Crypto Security Checklist: 2FA, Anti-Phishing Code, Withdrawal Whitelist
9. A9 Common Beginner Mistakes: Chasing Pumps, Over-Leverage, All-In Entries, Blind Copy Trading
10. A10 How to Deposit and Withdraw on a Crypto Exchange Without Common Errors
11. A11 Stablecoins for Beginners: USDT vs USDC vs FDUSD
12. A12 How to Avoid Fake Exchange Links and Phishing Pages

## Phase 2 Hold List

- Binance Rebate Guide: Link, Rebate Rate, Real Cost, Who It Fits
- OKX Rebate Guide: Registration, Rebate Rules, Suitable User Type
- Bybit Rebate Guide: Rebate Mechanics, Fee Structure, Important Caveats

These three pages stay out of launch 1. Promote them only after the site-wide disclosure system, evidence ledger, and review-method page are already live.

## Portfolio Verdict

- `GO` on education and safety pages once screenshots, update dates, and internal links are present.
- `GO WITH CONCERNS` on operational pages if KYC, deposit, and withdrawal steps are tested and dated.
- `BLOCKED` on exchange comparison and rebate pages until disclosure, methodology, and evidence-ledger rows are complete.
- `BLOCKED` on tool pages until formulas, assumptions, rounding rules, and last-updated timestamps are visible near the main input area.

## Page Audit Matrix

| ID | Recommended Page | Type | Status | Main Risk | Required Before Publish |
| --- | --- | --- | --- | --- | --- |
| A1 | Crypto for Beginners: From Zero to the First Spot Trade | how-to guide | GO WITH CONCERNS | Too generic without product screenshots or account-state caveats | Add 2026 screenshots, first-trade checklist, and clear risk disclaimer |
| A2 | Binance vs OKX vs Bybit for Beginners: Which Exchange Fits You First | comparison | BLOCKED | High affiliate-bias risk and title-overpromise risk | Add scoring method, audience segments, disclosure above fold, and review date |
| A3 | Sign-Up and KYC Walkthrough: What You Need, How Long It Takes, Common Failure Reasons | how-to guide | GO WITH CONCERNS | Flow drift by region and account type | Test steps, record last-verified date, and list region/payment exceptions |
| A4 | How to Buy Your First BTC or USDT: 7-Step Beginner Walkthrough | how-to guide | GO WITH CONCERNS | Payment assumptions may not match reader location | Separate card/P2P/balance methods and explain spread, fees, and slippage |
| A5 | Spot vs Futures vs Margin: What Beginners Should Use First and Avoid First | explainer | GO | Beginners may jump to leverage too early | Put the "who should not use this" section before any exchange CTA |
| A6 | How Crypto Exchange Fees Work: Spot, Futures, Withdrawal, Funding, Hidden Costs | guide | GO WITH CONCERNS | Numbers decay fast and contradictions are easy | Back every fee example with an evidence row and a refresh trigger |
| A7 | What Rebates Really Are and How They Change Your Real Trading Cost | commercial explainer | BLOCKED | Monetization conflict is visible to readers and auditors | Add disclosure, formula examples, and a plain-English review method |
| A8 | Beginner Crypto Security Checklist: 2FA, Anti-Phishing Code, Withdrawal Whitelist | checklist guide | GO | Can sound absolute if it promises safety | Add breach-response steps and avoid guarantee language |
| A9 | Common Beginner Mistakes: Chasing Pumps, Over-Leverage, All-In Entries, Blind Copy Trading | listicle | GO | Risks sounding generic or preachy | Add real scenarios, numeric examples, and next-step links |
| A10 | How to Deposit and Withdraw on a Crypto Exchange Without Common Errors | how-to guide | GO WITH CONCERNS | Wrong chain or wrong network instructions can cause irreversible mistakes | Test deposit and withdrawal flows on at least 2 exchanges and include memo/tag warnings |
| A11 | Stablecoins for Beginners: USDT vs USDC vs FDUSD | explainer/comparison | GO WITH CONCERNS | Issuer, reserve, and availability claims decay fast | Cite issuer docs, mark update date, and separate risk from convenience |
| A12 | How to Avoid Fake Exchange Links and Phishing Pages | security guide | GO | Can overlap with generic safety advice unless the threat model is concrete | Add real scam patterns, bookmark rules, and reporting steps |
| T1 | Fee and Rebate Calculator | tool page | BLOCKED | Readers cannot trust outputs if formulas are hidden | Show formula, rate source, rounding rule, and "last updated" timestamp |
| T2 | Position Size and Stop-Loss Calculator | tool page | BLOCKED | Can imply false precision or guaranteed outcomes | Add risk note, leverage warning, and assumption summary near inputs |
| T3 | KYC and Account Setup Readiness Checklist | tool page | GO WITH CONCERNS | Must not look like a data-collection form | Keep it no-login and no-PII, or state storage behavior clearly |

## Highest-Priority Fix Queue

### P0 — Must Fix Before Any Commercial Page Ships

- Put affiliate disclosure above the first outbound exchange link.
- Publish a short "How we review exchanges and fee pages" methodology page.
- Create evidence-ledger rows for every rebate percentage, fee number, KYC rule, payment method, and region-specific claim.
- Add editor identity, contact path, and update policy to the page template.

### P1 — Must Fix Before Tool Pages Ship

- Show formulas, assumptions, and rounding behavior in plain language.
- Add a non-advisory risk note near results, not only in the footer.
- Mark whether calculations run client-side only and whether anything is stored.

### P2 — Quality Lift After the First Publish Gate

- Add answer-first summary blocks near the top of every guide.
- Add FAQ sections to pages that target beginner questions.
- Add 3-5 internal links per page into the onboarding cluster and the safety cluster.

## Recommended Skill Sequence By Page Group

| Page Group | Suggested Sequence |
| --- | --- |
| Foundation guides (A1, A3, A4, A5, A8, A9, A10, A12) | `keyword-research` -> `serp-analysis` -> `seo-content-writer` -> `geo-content-optimizer` -> `schema-markup-generator` -> `meta-tags-optimizer` -> `content-quality-auditor` |
| Comparison and fee pages (A2, A6, A7, A11) | `keyword-research` -> `competitor-analysis` -> `serp-analysis` -> `seo-content-writer` -> `geo-content-optimizer` -> `schema-markup-generator` -> `content-quality-auditor` |
| Phase 2 rebate pages (deferred) | `competitor-analysis` -> `domain-authority-auditor` -> `seo-content-writer` -> `geo-content-optimizer` -> `schema-markup-generator` -> `content-quality-auditor` |
| Tool pages (T1, T2, T3) | `keyword-research` -> `seo-content-writer` for supporting copy -> `technical-seo-checker` -> `schema-markup-generator` -> `meta-tags-optimizer` -> `content-quality-auditor` |

## Launch Order After Audit

1. Ship A1, A3, A4, A5, A8, and A9 first.
2. Ship A6, A10, A11, A12, and T3 after evidence rows, update dates, and no-storage messaging are ready.
3. Ship A2 and A7 only after the comparison method and disclosure standard are live site-wide.
4. Ship T1 and T2 only after formula transparency and risk notes are visible.
5. Move the exchange-specific rebate guides to phase 2, after the trust template is proven on earlier pages.

## Companion Docs

- [crypto-site-evidence-ledger-template.md](./crypto-site-evidence-ledger-template.md)
- [crypto-site-launch-qa-checklist.md](./crypto-site-launch-qa-checklist.md)
- [chinese-beginner-crypto-site-launch-playbook.md](./chinese-beginner-crypto-site-launch-playbook.md)
