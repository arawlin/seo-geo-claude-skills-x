# ADR-002: Guardrailed Systematic Slimming Plan

- **Date**: 2026-04-24
- **Status**: Accepted
- **Target release**: v9.5.0+
- **Authors**: aaron-he-zhu + Codex + agent review panel

## Context

The repository has already completed several slimming passes that are being published as a single v9.5.0 release. The operating baseline before this ADR was approximately `21,336` tracked lines, down from `24,823` at the start of the current slimming wave.

This repository is not a normal code package. It is a content-based SEO/GEO skill operating system:

- `SKILL.md` files control discovery, activation, handoff, and runtime behavior.
- `references/` files carry execution templates, scoring rubrics, protocol contracts, and examples.
- `commands/` files expose slash-command workflows and maintenance gates.
- Manifests, README files, `VERSIONS.md`, and `CITATION.cff` are release surfaces.

Prior review rounds found that simple line-cutting can damage behavior even when markdown remains valid. Regressions included stale citation metadata, missing discovery aliases, under-specified robots/sitemap/HSTS/image/schema/report templates, conflicting score denominators, and missing release checks.

## Decision

Adopt a guardrail-first slimming strategy. No further large slimming phase should run until Phase 0 creates machine-checkable regression guards and release gates.

The safe target is a further net reduction of about `2,000-2,800` lines, reaching roughly `18.5k-19.3k` tracked lines. A stretch target near `18.0k` is acceptable only if agent review and regression checks stay clean after each phase. Targets below `18.0k` are not recommended unless the project accepts higher behavioral risk or moves content into a generated/external packaging model.

## Protected Zones

These files or sections are protected. They may be corrected or clarified, but they are not slimming pools.

| Protected area | Reason |
|----------------|--------|
| `references/core-eeat-benchmark.md` | Authoritative CORE-EEAT scoring source |
| `references/cite-domain-rating.md` | Authoritative CITE scoring source |
| `references/auditor-runbook.md` | Source for auditor inline execution rules |
| Auditor inline runbook blocks in `content-quality-auditor` and `domain-authority-auditor` | Required for execution fidelity; markdown links do not reliably load at activation |
| `references/skill-contract.md` contract sections | Shared handoff, status, promotion, and protocol rules |
| `references/state-model.md` memory/wiki lifecycle sections | Shared state semantics and ownership rules |
| `hooks/hooks.json` memory/wiki hook behavior | Runtime behavior, not documentation bloat |
| `cross-cutting/memory-management/SKILL.md` runtime contract | Sole writer, hooks delegation, archive behavior, HOT/WARM/COLD lifecycle |
| `cross-cutting/entity-optimizer/SKILL.md` canonical profile contract | Downstream skills depend on required entity fields and graceful degradation behavior |
| High-value discovery aliases | Discovery recall is a product feature, not decoration |

## Phase 0: Regression and Release Guardrails

Phase 0 is mandatory and may add lines. It is insurance against repeated semantic regressions.

### 0.1 Canonical Section Set

First decide the canonical `SKILL.md` section set. Current contract text still names sections that many slimmed skills no longer expose exactly.

Allowed outcome options:

1. Restore the old required headings across skills.
2. Update `references/skill-contract.md`, `CONTRIBUTING.md`, `CLAUDE.md`, and validators to the current compact section set.

Do not add heading checks until the canonical set is settled.

### 0.2 Auditor Validator Exception

Update `scripts/validate-skill.sh` so auditor-class skills with `class: auditor` or `runbook-sync` markers are exempt from the normal 400-line warning. The accepted ceiling for protocol-layer auditors is approximately 750 lines, as documented in `CLAUDE.md`.

### 0.3 Historical Regression Matrix

Create machine-checkable assertions for prior review findings. These can live in `/seo:validate-library`, `scripts/validate-skill.sh`, a new maintenance command, or CI shell checks.

| Regression class | Required assertion |
|------------------|--------------------|
| Citation metadata | `CITATION.cff` version and release date match the public plugin release |
| Technical aliases | `technical-seo-checker` retains robots.txt, sitemap, canonical, and related triggers/tags |
| GEO aliases | `geo-content-optimizer` retains AI SEO, AI optimization, generative engine optimization, and Chinese AI search phrases |
| Schema aliases | `schema-markup-generator` retains `schema.org` and `schema-org` discovery paths |
| Keyword tool aliases | `keyword-research` retains Semrush, Google Keyword Planner, Ubersuggest, and Ahrefs replacement paths |
| Robots/sitemap template | Technical templates retain current robots content, recommended snippet, sitemap validity, only-indexable-URL checks, and `lastmod` accuracy |
| HTTPS security | Technical templates retain explicit HSTS checks |
| Image audit | On-page templates retain filename and lazy-loading checks |
| CORE-EEAT rollup | Quick-scan denominator and summary denominator are consistent or explicitly scaled |
| Authority metric | Performance reports retain DA/DR/authority in top-level summary where required |
| Schema placeholders | Copy-start schema templates use placeholders, not stale literal dates/prices/durations |
| Review schema | Eligible schema examples retain reusable `aggregateRating` and `review` fragments |
| Memory/entity contracts | Sole-writer and canonical profile contracts remain in activation path |
| Disavow safety | Link-quality rubric retains clear-risk-only, low-DA-is-not-toxic, nofollow, manual review, removal attempt, backup, and follow-up safeguards |
| Threshold/date/report freshness | Internal-link thresholds, content refresh date strategy, GEO source/date/currentness, audience matrix, and data freshness remain present |

### 0.4 Discovery Alias Allowlist

Maintain a small allowlist of must-keep discovery phrases by skill. This should not freeze every trigger forever. It should only protect high-value aliases that reviews have identified as essential.

Minimum initial allowlist:

- `robots.txt`, `sitemap`, `canonical`, `HSTS`
- `schema.org`, `schema-org`
- `AI SEO`, `AI optimization`, `generative engine optimization`, `AI搜索优化`
- `Semrush`, `Google Keyword Planner`, `Ubersuggest`, `Ahrefs alternative`
- `project context`, `remember this`, `wiki lint`, `what do we know so far`

### 0.5 Release Matrix Gate

Before publish, verify all release surfaces:

- `.claude-plugin/plugin.json`
- `marketplace.json`
- `.claude-plugin/marketplace.json`
- `gemini-extension.json`
- `qwen-extension.json`
- `.codebuddy-plugin/marketplace.json`
- `CITATION.cff`
- `README.md`
- `docs/README.zh.md`
- `CLAUDE.md`
- `VERSIONS.md`

`/seo:sync-versions` is useful but not sufficient. It does not cover all follow-up files.

### 0.6 CI Integration

The publish workflow must run the Phase 0 gates before publishing. Release automation should fail before `bundle-publish` or `skills-publish` if regression checks fail.

### 0.7 Line Budget Check

Every slimming phase must record:

- starting tracked line count
- ending tracked line count
- gross deletion
- review/fix/release overhead
- net reduction

Use current `git ls-files | xargs wc -l`, not historical 37k-era baselines.

### Phase 0 Implementation Status

Implemented in v9.5.0:

- `references/skill-contract.md`, `CONTRIBUTING.md`, `AGENTS.md`, and `scripts/validate-skill.sh` now agree on the compact section contract.
- `scripts/validate-skill.sh` checks required shared headings and recognizes auditor-class `runbook-sync` exceptions up to the documented ~750-line ceiling.
- `scripts/validate-slimming-guardrails.sh` encodes the historical regression matrix, discovery alias allowlist, release-surface checks, and protected runtime-contract checks.
- `.github/workflows/clawhub-publish.yml` runs guardrails, all 20 skill validators, skill version status, JSON parsing, marketplace mirror comparison, and diff whitespace checks before publishing.
- `commands/validate-library.md`, `CLAUDE.md`, README, localized README, manifests, `VERSIONS.md`, and `CITATION.cff` document and expose the v9.5.0 release gate.

## Phase 1: Reference Pack Compression

Phase 1 is still the main savings pool, but files must be classified before editing.

### 1.1 File Classes

| Class | Treatment |
|-------|-----------|
| Protocol / benchmark | Do not slim |
| Realtime technical matrix | Compact only after required fields and update cadence are locked |
| Generation contract | Preserve required-vs-optional fields, validation rules, policy violations, and preflight checks |
| Rubric / threshold | Convert to compact tables, retain thresholds, counterexamples, and safety guards |
| Template pack | Replace long examples with placeholders and starter blocks |
| Worked examples | Keep one complete example per skill; convert the rest to calibration cards |

### 1.2 First Candidates

Prioritize examples, repeated reports, and non-recently-repaired template packs. Avoid first-pass edits to recently restored packs unless Phase 0 checks already cover them.

Good candidates:

- Repeated `example-report.md` files that can become calibration cards
- Long outreach, positioning, topic cluster, and setup guides where thresholds are simple
- Duplicated instructions-detail packs that restate `SKILL.md` steps

Caution candidates:

- `schema-templates.md`
- `validation-guide.md`
- `robots-txt-reference.md`
- `llm-crawler-handling.md`
- `http-status-codes.md`
- `kpi-definitions.md`

These are compressible but must keep generation or realtime decision fields.

Expected safe net reduction: `900-1,500` lines after review/fix overhead.

## Phase 2: Examples and Report Body Reduction

Each skill should usually keep:

- one complete worked example if it materially improves execution quality
- short calibration cards for common variants
- links to full external docs only where the linked content is non-execution-critical

Remove or compress:

- repeated executive summaries
- repeated long output tables with no unique fields
- sample numbers that can be mistaken for defaults
- multi-page reports whose structure is already captured in templates

Expected safe net reduction: `400-700` lines.

## Phase 3: Ordinary Skill Skeleton Standardization

Only non-auditor, non-protocol skills are eligible.

Target shape:

1. Frontmatter
2. One-sentence function summary
3. Compact Quick Start block
4. Skill Contract
5. Data Sources with `~~category` connectors and Tier 1 fallback
6. Instructions as 7-11 concise steps
7. Save Results
8. Reference Materials
9. Next Best Skill

Preserve:

- high-value triggers
- `when_to_use`
- `description` discovery quality
- `Reads` / `Writes` / `Promotes`
- Data Sources and Tier 1 fallback
- Reference links required by slimmed instructions

Do not apply this phase to:

- `content-quality-auditor`
- `domain-authority-auditor`
- `memory-management`
- `entity-optimizer`

Expected safe net reduction: `300-500` lines.

## Phase 4: Command Surface Polish

Commands are not a major savings pool. Current command volume is about 1,146 lines, and several maintenance commands intentionally differ from user-facing workflow commands.

Do:

- standardize only repetitive user-facing command sections
- avoid forcing `contract-lint`, `validate-library`, and `sync-versions` into the same shape
- preserve output schemas consumed by humans or CI

Expected safe net reduction: `75-150` lines.

## Phase 5: Root Docs and Release History

Root docs are last, not first. Their job is onboarding, installation, and release clarity.

Allowed reductions:

- keep only recent detailed changelog entries in `VERSIONS.md`
- move older detail to GitHub Releases or a compact archive note
- avoid duplicating maintenance rules across README, CLAUDE, AGENTS, and CONTRIBUTING

Do not remove:

- install instructions
- skill and command inventory
- license, privacy, security, and code of conduct surfaces
- current release version and citation metadata

Expected safe net reduction: `100-250` lines.

## Execution Protocol Per Phase

Each phase uses the same loop:

1. Record baseline line count.
2. Select a small write set.
3. List protected fields for that write set.
4. Edit only that write set.
5. Run all local checks.
6. Run agent team review with three roles: behavior/template fidelity, discovery/contract, release/validation.
7. Fix all findings.
8. Re-run all checks.
9. Update version/tracking only after findings are resolved.

Required local checks:

```sh
bash scripts/validate-slimming-guardrails.sh

for dir in research/keyword-research research/competitor-analysis research/serp-analysis research/content-gap-analysis build/seo-content-writer build/geo-content-optimizer build/meta-tags-optimizer build/schema-markup-generator optimize/on-page-seo-auditor optimize/technical-seo-checker optimize/internal-linking-optimizer optimize/content-refresher monitor/rank-tracker monitor/backlink-analyzer monitor/performance-reporter monitor/alert-manager cross-cutting/content-quality-auditor cross-cutting/domain-authority-auditor cross-cutting/entity-optimizer cross-cutting/memory-management; do
  ./scripts/validate-skill.sh "$dir" || exit 1
done

./scripts/validate-skill.sh --status
jq empty .claude-plugin/plugin.json marketplace.json .claude-plugin/marketplace.json gemini-extension.json qwen-extension.json .codebuddy-plugin/marketplace.json
cmp -s marketplace.json .claude-plugin/marketplace.json
git diff --check
git ls-files | xargs wc -l | tail -1
```

## Revised Targets

| Target | Line count | Net reduction from 21,336 | Recommendation |
|--------|------------|---------------------------|----------------|
| Safe | 19.3k | about 2.0k | Recommended |
| Strong | 18.5k-19.0k | about 2.3k-2.8k | Acceptable after Phase 0 |
| Stretch | about 18.0k | about 3.3k | Only if reviews stay clean |
| Not recommended | below 18.0k | 3.3k+ | Likely requires high-risk cuts |

All targets must account for review/fix/release overhead. A phase that deletes 800 lines may net only 600-680 lines after guardrail additions and review fixes.

## Rejected Alternatives

- **Continue direct reference compression without Phase 0.** Rejected because previous regressions were semantic and passed generic markdown checks.
- **Use frontmatter centralization as a major savings lever.** Rejected because plugin manifests do not provide defaults and required discovery metadata must stay local to each skill.
- **Make commands a major slimming pool.** Rejected because command volume is small and maintenance commands carry intentional schema detail.
- **Compress auditor inline runbooks.** Rejected because ADR-001 established that inlining is required for execution fidelity.
- **Target below 18k immediately.** Rejected because it would likely require cutting protected protocol, discovery, or safety content.

## Review Triggers

Revisit this ADR when any of the following happen:

- Phase 0 gates are implemented and pass in CI.
- A future slimming phase produces a P1 regression.
- Tracked line count reaches 19k and the team considers the stretch target.
- ClawHub or Claude Code gains a reliable preprocessor or reference-loading mechanism that changes the cost of inline content.
