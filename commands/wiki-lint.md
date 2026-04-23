---
name: wiki-lint
description: Run wiki health check — detect contradictions, orphan pages, stale claims, missing pages, and source hash mismatches across wiki and WARM files
argument-hint: "[--fix] [--project <name>] [--retire-preview]"
parameters:
  - name: fix
    type: boolean
    required: false
    description: Auto-resolve contradictions where confidence is HIGH (time-series data). MEDIUM/LOW contradictions still require user confirmation.
  - name: project
    type: string
    required: false
    description: Limit lint to a specific project. If omitted, lints the active project from hot-cache or all projects.
  - name: retire-preview
    type: boolean
    required: false
    description: "Phase 3: List WARM files fully covered by wiki compiled pages as retirement candidates. Does not execute any archival — requires explicit user confirmation."
---

# Wiki Lint Command

> Wiki health check for the [SEO & GEO Skills Library](https://github.com/aaron-he-zhu/seo-geo-claude-skills). Full spec: [references/proposal-wiki-layer-v3.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/proposal-wiki-layer-v3.md)

Scans `memory/wiki/` compiled pages and `memory/` WARM files for inconsistencies.

## Usage

```
/seo:wiki-lint
/seo:wiki-lint --project acme-campaign-q2
/seo:wiki-lint --fix
/seo:wiki-lint --retire-preview
```

## Checks Performed

| Check | Description | Auto-fixable |
|-------|-------------|-------------|
| **Contradiction** | Two wiki/WARM files assert conflicting facts about same entity | HIGH only (time-series: use latest + changelog) |
| **Stale claim** | Wiki page cites WARM file whose source hash changed | Yes (re-compile) |
| **Orphan page** | Wiki page with zero inbound links | No (suggest deletion/linking) |
| **Missing page** | Entity mentioned 3+ times but has no page | No (suggest creation) |
| **Missing cross-ref** | Two pages discuss same topic without linking | Yes (add link) |
| **HOT drift** | hot-cache.md references entity whose wiki page changed | No (suggest HOT update) |
| **Hash mismatch** | Compiled page `sources.hash` differs from current WARM content | Yes (re-compile) |

## Contradiction Resolution

- **HIGH**: Time-series data -- auto-use latest value, preserve older as changelog.
- **MEDIUM**: Ambiguous evidence -- LLM proposes, marked `[待确认]` until user confirms.
- **LOW**: Insufficient evidence -- flagged for user, not auto-resolved even with `--fix`.

## Output Format

```markdown
## Wiki Lint Report -- [project] (YYYY-MM-DD)

### Contradictions (N) / Stale Claims (N) / Orphan Pages (N) / Missing Pages (N) / Missing Cross-Refs (N) / HOT Drift (N) / Hash Mismatches (N)
[Each section with relevant table columns]

### Summary
Total checks: N | Issues: N | Auto-fixed: N | Requires user action: N
```

Results appended to `memory/wiki/log.md`.
