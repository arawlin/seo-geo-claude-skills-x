# Proposal: Wiki Knowledge Layer

**Status**: Draft
**Date**: 2026-04-05
**Inspired by**: [Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)

## Problem

The current memory system (HOT/WARM/COLD) is a **lifecycle-managed cache**: each skill writes its own findings to `memory/<category>/`, and promotion/demotion moves entries between tiers by reference frequency. This works well for retrieval, but creates three gaps:

1. **No synthesis layer.** Running keyword-research, competitor-analysis, and serp-analysis produces three separate files. No artifact merges them into an evolving picture. Cross-skill insights (e.g., "Competitor A ranks for keywords we identified as gaps, using schema types our technical audit flagged as missing") require a human to connect the dots or re-derive them each session.

2. **No contradiction detection.** A January audit might say "site speed is healthy" while a March technical-seo-checker finds Core Web Vitals regressions. Both files coexist in `memory/audits/` without any mechanism to flag the conflict.

3. **No navigable index.** The hot-cache (80 lines) can hold pointers to ~15 items. A campaign with 50+ keywords, 5 competitors, and months of audits quickly outgrows it. Skills must guess which WARM files to load — or load none and lose context.

## Proposal

Add a **wiki layer** between HOT and WARM. The wiki is a set of LLM-maintained, interlinked markdown pages that compile and cross-reference findings from across skills. It is **not a replacement** for the temperature model — it is a new tier that reads from WARM files and promotes key conclusions to HOT.

```
┌─────────────────────────────────────────────────┐
│  HOT   hot-cache.md  (80 lines, auto-loaded)    │
├─────────────────────────────────────────────────┤
│  WIKI  wiki/         (compiled, interlinked)     │  ← NEW
├─────────────────────────────────────────────────┤
│  WARM  memory/       (per-skill, per-category)   │
├─────────────────────────────────────────────────┤
│  COLD  memory/archive/ (dated, query-only)       │
└─────────────────────────────────────────────────┘
```

## Design

### 1. Directory structure

```
wiki/
├── index.md              # Full catalog: every page, one-line summary, category
├── log.md                # Append-only timeline of ingests, queries, lint passes
├── entities/             # One page per entity (competitor, author, brand)
├── keywords/             # One page per keyword cluster or topic
├── topics/               # Concept pages (e.g., "Core Web Vitals", "E-E-A-T")
├── comparisons/          # Cross-entity analysis pages
└── synthesis/            # Campaign-level narratives, quarterly rollups
```

### 2. Three operations

| Operation | Trigger | What happens |
|-----------|---------|-------------|
| **Ingest** | Any skill writes to `memory/` | Wiki reads the new WARM file, updates or creates relevant wiki pages, appends to `log.md`, updates `index.md` |
| **Query** | User asks a cross-skill question | Read `index.md` to locate relevant pages, synthesize answer, optionally file the answer back as a new wiki page |
| **Lint** | Manual (`/seo:wiki-lint`) or scheduled | Scan for: contradictions between pages, orphan pages (no inbound links), stale claims superseded by newer WARM data, missing entity pages for items mentioned 3+ times, gaps that suggest a skill should be re-run |

### 3. Wiki page format

```markdown
---
name: competitor-acme-corp
type: entity                    # entity | keyword | topic | comparison | synthesis
sources:                        # WARM files that contributed
  - memory/research/competitors/acme-corp.md
  - memory/audits/domain/acme-corp-cite.md
last_compiled: 2026-04-05
---

# Acme Corp

## Profile
...

## Keyword Overlap
<!-- Cross-references wiki/keywords/ pages -->

## Audit History
<!-- Links to dated audit summaries -->

## Open Questions
- [ ] Backlink profile not yet analyzed (see memory/open-loops.md#acme-backlinks)
```

### 4. index.md

Content-oriented catalog. The LLM reads this first when answering cross-skill queries.

```markdown
# Wiki Index

## Entities
- [Acme Corp](entities/acme-corp.md) — Primary competitor, DR 72, 340 overlapping keywords
- [Jane Doe](entities/jane-doe.md) — Industry author, cited in 4 competitor articles

## Keywords
- [best crm software](keywords/best-crm-software.md) — Hero keyword, KD 45, vol 12k/mo
- [crm comparison 2026](keywords/crm-comparison-2026.md) — Long-tail cluster, 8 variants

## Topics
- [Core Web Vitals](topics/core-web-vitals.md) — Technical SEO factor, audited 2026-03-15
- [E-E-A-T Signals](topics/eeat-signals.md) — Quality framework, 6 action items open

## Comparisons
- [Us vs Acme vs Beta](comparisons/us-acme-beta.md) — Content gap analysis, 2026-03-20

## Synthesis
- [Q1 2026 Campaign Rollup](synthesis/q1-2026-rollup.md) — 23 keywords tracked, 4 content pieces published
```

### 5. log.md

Append-only timeline. Parseable with grep.

```markdown
# Wiki Log

## [2026-04-05] ingest | keyword-research → best crm software
Updated: wiki/keywords/best-crm-software.md, wiki/index.md
New page: wiki/keywords/crm-comparison-2026.md

## [2026-04-05] ingest | competitor-analysis → Acme Corp
Updated: wiki/entities/acme-corp.md, wiki/comparisons/us-acme-beta.md
Contradiction flagged: DR was 68 in January audit, now 72

## [2026-04-05] lint | full scan
- 2 contradictions resolved
- 1 orphan page removed (wiki/topics/deprecated-metric.md)
- 3 missing entity pages suggested
```

### 6. Lint checklist

| Check | Action |
|-------|--------|
| Contradiction | Two wiki pages assert conflicting facts about the same entity/keyword. Flag with `⚠️ CONFLICT` inline and add to `open-loops.md` |
| Stale claim | A wiki page cites a WARM file older than 30 days when a newer file exists. Mark claim as `[stale — verify]` |
| Orphan page | Wiki page with zero inbound links from other wiki pages. Suggest deletion or linking |
| Missing page | Entity or keyword mentioned 3+ times across wiki pages but has no dedicated page. Suggest creation |
| Missing cross-reference | Two pages discuss the same topic but don't link to each other. Suggest `[[wikilink]]` |
| HOT drift | hot-cache.md references an entity/keyword whose wiki page has materially changed. Suggest HOT update |

## Integration with existing system

### Skill contract changes

Add one field to the skill contract `Writes` section:

```
Writes: deliverable + handoff summary + wiki ingest trigger
```

After writing to `memory/<category>/`, the skill emits a structured ingest signal:

```markdown
<!-- wiki-ingest
source: memory/research/competitors/acme-corp.md
entities: [Acme Corp]
keywords: [best crm software, crm comparison]
topics: [domain authority, content gap]
-->
```

The `memory-management` skill (or a new `wiki-maintainer` protocol skill) picks up this signal and runs the ingest operation.

### Hook changes

| Hook | Current | Proposed addition |
|------|---------|-------------------|
| **SessionStart** | Load hot-cache.md | Also load `wiki/index.md` (read-only, for navigation) |
| **PostToolUse** | Recommend content-quality-auditor | Also trigger wiki ingest if a WARM file was written |
| **Stop** | Save veto issues to HOT | Also append session activity to `wiki/log.md` |

### New command

```
/seo:wiki-lint — Run wiki health check: contradictions, orphans, stale claims, missing pages
```

### Ownership

| Actor | Responsibility |
|-------|---------------|
| **Execution skills** (16) | Emit wiki-ingest signals after writing to WARM |
| **memory-management** | Ingest operation: read WARM, update/create wiki pages, maintain index and log |
| **memory-management** | Lint operation: detect contradictions, orphans, staleness, missing pages |
| **entity-optimizer** | Canonical entity wiki pages (extends current entity ownership) |
| **User** | Query operation: ask cross-skill questions, decide which answers to file back |

### Capacity rules

| File | Limit | Rationale |
|------|-------|-----------|
| `wiki/index.md` | 300 lines | Must stay scannable by the LLM in one read |
| `wiki/log.md` | 500 lines | Oldest entries archived to `wiki/log-archive/YYYY.md` |
| Individual wiki pages | 200 lines | Consistent with WARM file limits |
| `wiki/` total page count | No hard limit | index.md is the bottleneck; prune orphans via lint |

## What this does NOT change

- **HOT/WARM/COLD lifecycle**: Unchanged. Promotion/demotion rules stay the same.
- **Skill file structure**: No changes to SKILL.md format or required sections.
- **Quality frameworks**: CORE-EEAT and CITE scoring remains in audit skills.
- **Tool connector pattern**: Wiki pages are pure markdown; no tool dependencies.
- **Handoff summary format**: Unchanged. Wiki ingest signal is an addition, not a replacement.

## Implementation phases

### Phase 1 — Foundation (v6.3.0)

- Create `wiki/` directory with `index.md` and `log.md`
- Add wiki-ingest signal spec to `references/skill-contract.md`
- Update `memory-management` SKILL.md with ingest and lint operations
- Update `references/state-model.md` with wiki tier documentation
- Add `wiki/index.md` to SessionStart hook loading

### Phase 2 — Skill integration (v6.4.0)

- Add wiki-ingest signals to all 16 execution skills
- Build `/seo:wiki-lint` command
- Add PostToolUse hook for automatic ingest triggering
- Add Stop hook for log.md appending

### Phase 3 — Query-and-file-back (v6.5.0)

- Implement query-to-wiki-page workflow in memory-management
- Add `wiki/synthesis/` for campaign-level narratives
- Add `wiki/comparisons/` for cross-entity analysis
- Optional: integrate with qmd or similar local search if wiki exceeds ~100 pages

## Risks and mitigations

| Risk | Mitigation |
|------|-----------|
| Wiki bloat — too many pages, index becomes unmanageable | 300-line index limit + lint orphan pruning |
| Ingest noise — minor WARM updates trigger unnecessary wiki rewrites | Ingest signal is opt-in per skill; trivial updates can skip the signal |
| Contradictions in wiki pages themselves | Lint operation is the explicit fix; contradictions are flagged, not hidden |
| Added complexity for contributors | Wiki layer is entirely LLM-maintained; contributors only add the ingest signal comment to skills |
| Session cost — loading index.md adds tokens | index.md at 300 lines is ~4KB, negligible compared to hot-cache.md |

## Success criteria

1. A user running 3+ skills in sequence can ask "what do we know about Competitor X?" and get a synthesized answer that cites findings from all relevant skills — without re-running any skill.
2. A contradiction between a January audit and a March audit is automatically flagged within one lint pass.
3. `wiki/index.md` serves as a reliable table of contents for the entire campaign knowledge base.
4. No existing skill behavior or memory lifecycle is broken.
