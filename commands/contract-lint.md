---
name: contract-lint
description: Validate auditor Runbook inline copies, handoff schema compliance, and jargon leaks across all SKILL.md files. Produces drift report.
argument-hint: "[--skill <name>] [--strict]"
parameters:
  - name: skill
    type: string
    required: false
    description: Limit the scan to a single skill directory. If omitted, scans all skills in the library.
  - name: strict
    type: boolean
    required: false
    description: Exit with non-zero status if ANY drift is found (for CI use). Default is report-only.
---

# Contract Lint

> Validates auditor Runbook inline copies, handoff schema compliance, and user-facing jargon leaks across all SKILL.md files. Part of the [SEO & GEO Skills Library](https://github.com/aaron-he-zhu/seo-geo-claude-skills).

**Authoritative check list**: validates [references/auditor-runbook.md §6 Lint Coverage Manifest](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md). When §6 changes, update this command in the same commit. If they disagree, the Runbook wins.

## What It Checks

### Runbook drift (high severity)
- **Source sha256 match** (Attack A): Both auditor SKILL.md files carry matching `source_sha256` in `<!-- runbook-sync start -->` markers, equal to `shasum -a 256 references/auditor-runbook.md`.
- **Block sha256 match** (Attack B): Content between sync markers matches declared `block_sha256`. Catches tampering inside inlined block.
- **Block sha256 matches extracted §1-5**: `block_sha256` equals sha256 of §1-5 extracted from Runbook source, pinning both file and region.
- **Runbook block present**: Every `class: auditor` skill has sync marker pair with both `source_sha256` and `block_sha256` attributes.
- **Inlined §1-5 sections present**: Within each sync block: §1 Handoff Schema, §2 Decision Table + 3 Worked Examples, §3 Guardrail table, §4 Artifact Gate 7-item checklist, §5 Translation Layer.

### Handoff schema drift (high severity)
- **Cap fields declared for auditors**: Auditor SKILL.md mentions `cap_applied`, `raw_overall_score`, `final_overall_score`.
- **Non-auditor skills do NOT emit cap fields**: Non-auditor SKILL.md files do not reference `cap_applied` in example handoffs.
- **Handoff array shape**: `key_findings` with `title` + `severity` + `evidence` appears in auditor handoffs.

### Source of truth drift (medium severity)
- **No restated cap numbers**: `60/100`, `cap at 60`, etc. appear ONLY in `references/auditor-runbook.md` §2 and `references/contract-fail-caps.md`. Other files must link, not restate.
- **Veto item definition consolidation**: T04/C01/R10 defined in `core-eeat-benchmark.md`; T03/T05/T09 in `cite-domain-rating.md`. No other file defines these as vetos.

### User-facing jargon leaks (medium severity)
- **Veto IDs in example outputs**: `T04`, `C01`, `R10`, `T03`, `T05`, `T09` must not appear in user-facing example blocks.
- **Internal field names in examples**: `cap_applied`, `raw_overall_score`, `final_overall_score`, `gap_type` must not appear in user-facing examples.
- **Raw-to-capped numeric deltas**: Patterns like `82 -> 60`, `capped at 60` must not appear in user-facing examples.

### Guardrail windowing (medium severity)
- **Year rule is windowed**: Runbook §3 Guardrail entry includes `current_year - 2` or equivalent.
- **No unconditional year positives**: No SKILL.md says "year markers are always positive".

## Ownership Rule (do not lint against)

These patterns are ALLOWED to restate cap numbers, veto IDs, and Runbook content:

**Source files**: `references/auditor-runbook.md`, `references/contract-fail-caps.md`, `references/core-eeat-benchmark.md`, `references/cite-domain-rating.md`, `references/decisions/`.

**Inlined copies (per ADR-001)**: `cross-cutting/content-quality-auditor/SKILL.md` and `cross-cutting/domain-authority-auditor/SKILL.md` -- the `<!-- runbook-sync -->` region is authorized. Drift detected via dual-hash, not grep.

**Informational mentions**: `VERSIONS.md`, `memory/hot-cache.md`, `references/AUDITOR-AUTHORS.md`, `README.md` -- exempt from false-positive flagging.

## Usage

```
/seo:contract-lint                                    # full scan
/seo:contract-lint --skill content-quality-auditor    # single skill
/seo:contract-lint --strict                           # CI mode
```

## Output

Report written to `references/lint-latest.md`.

```markdown
# Contract Lint Report -- YYYY-MM-DD HH:MM

**Runbook source sha256**: <hash> | **Version**: <version>

## Runbook Drift (N found)
| # | File | Check | Expected | Actual | Action |

## Handoff Schema Drift (N found)
| # | Skill | Missing field | Required by |

## Source of Truth Drift (N found)
| # | File | Restated content | Correct source |

## User-Facing Jargon Leaks (N found)
| # | Skill | Leak pattern | Location |

## Summary
Skills scanned: N | Runbook drift: N | Handoff drift: N | SoT drift: N | Jargon leaks: N
**Total issues: N** | **Exit status**: clean | warnings | drift
```

## What It Does NOT Do

No auto-fix. No runtime handoff validation (that is the PostToolUse Artifact Gate hook). No validation of non-auditor skills beyond handoff schema. No validation of the Runbook source itself.

## Self-Maintenance

When [references/auditor-runbook.md §6](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md) changes, update this command's check list in the same commit. Drift between this command and §6 is itself lintable -- contract-lint verifies its check list matches §6 before running.

## Notes

> **New auditor authors**: add `class: auditor` to SKILL.md frontmatter. Discovery is by frontmatter glob, not hardcoded manifest. See [AUDITOR-AUTHORS.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/AUDITOR-AUTHORS.md).
