# Architecture Decision Records (ADRs)

This directory captures non-obvious decisions made during the project's evolution. Each ADR records the context, decision, consequences, and rejected alternatives so future contributors can understand the **why**, not just the **what**.

## Format

File naming: `YYYY-MM-adr-NNN-kebab-case-title.md`

Each ADR contains:

- **Context** — what problem prompted the decision
- **Decision** — what we chose
- **Consequences** — tradeoffs, both positive and negative
- **Rejected alternatives** — what we considered and why we didn't pick it
- **Review triggers** — dated or conditional events that should cause reconsideration

## Status values

- **Proposed** — under discussion
- **Accepted** — shipped or scheduled for release
- **Superseded by ADR-NNN** — replaced; link to the newer ADR
- **Deprecated** — no longer applies, kept for history

## Current ADRs

- [ADR-001: Inline Auditor Runbook instead of Contract Inheritance](2026-04-adr-001-inline-auditor-runbook.md) — Accepted, v7.1.0

## When to write an ADR

Write an ADR when:

- A decision is non-obvious and a future contributor might ask "why not X?"
- A decision constrains future work in a meaningful way
- A decision was made after considering and rejecting alternatives worth remembering
- A decision violates an existing convention and needs to justify the exception

Do NOT write an ADR for:

- Routine implementation choices that follow existing conventions
- Cosmetic or naming decisions
- Bug fixes without architectural implications

When in doubt, write one. ADRs are cheap to create and expensive to miss.
