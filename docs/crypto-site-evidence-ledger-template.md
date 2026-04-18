# Crypto Site Evidence Ledger Template

This document is also available in [Chinese](./crypto-site-evidence-ledger-template-zh.md).

## Purpose

Use this template for any page that publishes volatile exchange data, monetized recommendations, or screenshots of product flows. The ledger exists to stop unverified claims from reaching production.

## Minimum Policy

- Create an evidence row before a page moves from draft to ready for review.
- Do not publish fee, rebate, KYC, withdrawal, regional availability, or bonus claims without a source URL and a review timestamp.
- Separate automated capture from manual verification.
- If the source is ambiguous, conflicting, or estimated, mark the claim as blocked.
- Update the page's visible last verified date when a row changes from blocked or stale to verified.

## Ledger Fields

- `claim_id`
- `page_slug`
- `claim_type`
- `claim_text`
- `source_url`
- `source_type`
- `checked_at`
- `checked_by`
- `evidence_path`
- `status`
- `next_review_trigger`
- `notes`

Example rows:

```csv
claim_id,page_slug,claim_type,claim_text,source_url,source_type,checked_at,checked_by,evidence_path,status,next_review_trigger,notes
CLM-001,exchange-rebates/binance,rebate-rate,"VIP 0 rebate is 20%",https://example.com/source,official-page,2026-04-18 09:00 UTC,editor-name,/evidence/binance-rebate-2026-04-18.png,verified,"Fee table changes or 30 days","Verified against public fee table"
CLM-002,exchange-guides/kyc,kyc-rule,"Level 1 KYC required before card purchase",https://example.com/source,help-center,2026-04-18 09:20 UTC,reviewer-name,/evidence/kyc-help-center-2026-04-18.png,review-needed,"Product flow changes or 14 days","Needs manual product walk-through"
```

## Blank Working Template

```csv
claim_id,page_slug,claim_type,claim_text,source_url,source_type,checked_at,checked_by,evidence_path,status,next_review_trigger,notes
CLM-___,,,,,,,,,,,
CLM-___,,,,,,,,,,,
CLM-___,,,,,,,,,,,
```

## Claim Type Suggestions

- `fee`
- `rebate-rate`
- `bonus-rule`
- `kyc-rule`
- `withdrawal-limit`
- `supported-region`
- `product-flow`
- `legal-copy`
- `risk-warning`
- `comparison-data`

## Source Type Suggestions

- `official-page`
- `help-center`
- `terms-page`
- `support-ticket`
- `product-walkthrough`
- `manual-screenshot`
- `third-party-reference`
- `estimated`

## Status Rules

- `verified`: source and review are complete, page may publish.
- `review-needed`: source exists, but human confirmation or screenshot refresh is still required.
- `stale`: evidence was once valid, but the trigger window has expired.
- `blocked`: source is missing, contradictory, or too weak for publication.

## Review Triggers

- Fee schedule changes.
- Rebate or signup bonus changes.
- KYC or withdrawal flow changes.
- Supported countries or payment methods change.
- Screenshot no longer matches the live interface.
- Legal disclaimer, editorial policy, or affiliate wording changes.
- Page has not been rechecked within the defined review window.

## Working Rules For The Team

1. Capture the source URL first.
2. Save a screenshot or archive copy second.
3. Record who checked it and when.
4. Link the claim to every page that uses it.
5. Set the next review trigger before the page ships.
6. Save a dated summary into `memory/` when the claim affects launch or trust decisions.

## What Counts As A Publish Blocker

- No source URL.
- No review timestamp.
- Source and screenshot conflict.
- Copy in the page does not match the verified claim.
- High-risk financial copy is older than the review window.
- Affiliate disclosure or risk notice relies on an unverified statement.

## Recommended Companion Documents

- [crypto-site-launch-qa-checklist.md](./crypto-site-launch-qa-checklist.md)
- [chinese-beginner-crypto-site-launch-playbook.md](./chinese-beginner-crypto-site-launch-playbook.md)
