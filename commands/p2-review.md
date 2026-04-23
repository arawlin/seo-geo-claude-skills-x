---
name: p2-review
description: Evaluate v7.1.0 P2 observation items against trigger conditions. Auto-closes unmet items on 2026-07-10; proposes met items for v7.3.
argument-hint: "[--verbose] [--since <date>]"
parameters:
  - name: verbose
    type: boolean
    required: false
    description: Show per-item reasoning and counts, not just the summary.
  - name: since
    type: string
    required: false
    description: Scan memory/audits/ from this date forward (YYYY-MM-DD). Default is v7.1.0 release date (2026-04-11).
---

# P2 Review

> Evaluates v7.1.0 **P2 observation items** against their binary trigger conditions, reports status, and makes a recommendation for v7.3.0.

**Ownership**: designated runner for the 2026-07-10 tombstone review tied to [ADR-001](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/decisions/2026-04-adr-001-inline-auditor-runbook.md). The SessionStart hook reminds the user to run this command if date >= 2026-07-10 and `memory/p2-review-2026-07.md` does not exist.

## What It Checks

Scans `memory/audits/YYYY-MM*.md` for evidence that each P2 item's trigger has been met.

| Item | Binary trigger | Data source |
|---|---|---|
| **Gap Typology field** | 3+ handoffs with explicit `audit_gap_types` annotation | `memory/audits/*.md` |
| **40-tier cap number** | 30+ audits with 2+ veto fails (BLOCKED) | `memory/audits/*.md` |
| **Failure Modes Catalog** | 5+ audits with `false_positive: true` annotation | `memory/audits/*.md` |
| **Adversarial Pass** | Named user feedback: "audits feel mechanical" | feedback channel |
| **wiki-lint aggregation** | Any 2+ of above items pass (derived) | derived |

## Evaluation Procedure

For each P2 item: read matching `memory/audits/` files, count records matching trigger, compare to threshold.
- **MET**: threshold reached -- propose for v7.3.0
- **PARTIAL**: count > 0 but below threshold -- keep observing
- **UNMET**: count == 0 after 90+ days -- propose tombstone

**Tombstone rule**: UNMET at >= 2026-07-10 is proposed for deletion, written to `references/decisions/2026-07-adr-002-p2-tombstone.md`.

## Usage

```
/seo:p2-review                         # evaluate current state
/seo:p2-review --verbose               # per-item counts and reasoning
/seo:p2-review --since 2026-05-01      # only count audits after May 2026
```

## Output

Report written to `memory/p2-review-YYYY-MM.md`.

```markdown
# P2 Review -- YYYY-MM-DD

**Scanned**: memory/audits/*.md (since 2026-04-11) | **Audits counted**: N

## Per-item status
| Item | Threshold | Actual | Status | Recommendation |

## Recommendations
- Propose tombstone: N items | Continue observing: N items

## Next steps
1. Tombstone -> create ADR-002, PR to remove deferred references.
2. Observing -> re-run in 90 days.
3. Met -> create ADR + implementation ticket for v7.3.0.
```

## Not included

No auto-fix (recommendations only). No external data sources (reads `memory/audits/` only). No forecast of when UNMET items might become MET.

## Related

- [ADR-001](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/decisions/2026-04-adr-001-inline-auditor-runbook.md) | [auditor-runbook.md §2](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md) | [contract-fail-caps.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/contract-fail-caps.md) | [memory-management](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/cross-cutting/memory-management/SKILL.md)
