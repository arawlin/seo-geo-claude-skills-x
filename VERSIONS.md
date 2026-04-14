# SEO & GEO Skills Library — Versions

Current versions of all skills. Agents can fetch this file from `https://raw.githubusercontent.com/aaron-he-zhu/seo-geo-claude-skills/main/VERSIONS.md` once per session to check for updates.

**Versioning**: Skill versions (`metadata.version` in SKILL.md) track skill content changes independently. Plugin version (in `plugin.json`) tracks manifest and infrastructure changes.

## Skills

| Skill | Category | Version | Last Updated |
|-------|----------|---------|--------------|
| keyword-research | research | 8.0.0 | 2026-04-15 |
| competitor-analysis | research | 8.0.0 | 2026-04-15 |
| serp-analysis | research | 8.0.0 | 2026-04-15 |
| content-gap-analysis | research | 8.0.0 | 2026-04-15 |
| seo-content-writer | build | 8.0.0 | 2026-04-15 |
| geo-content-optimizer | build | 8.0.0 | 2026-04-15 |
| meta-tags-optimizer | build | 8.0.0 | 2026-04-15 |
| schema-markup-generator | build | 8.0.0 | 2026-04-15 |
| on-page-seo-auditor | optimize | 8.0.0 | 2026-04-15 |
| technical-seo-checker | optimize | 8.0.0 | 2026-04-15 |
| internal-linking-optimizer | optimize | 8.0.0 | 2026-04-15 |
| content-refresher | optimize | 8.0.0 | 2026-04-15 |
| rank-tracker | monitor | 8.0.0 | 2026-04-15 |
| backlink-analyzer | monitor | 8.0.0 | 2026-04-15 |
| performance-reporter | monitor | 8.0.0 | 2026-04-15 |
| alert-manager | monitor | 8.0.0 | 2026-04-15 |
| content-quality-auditor | cross-cutting | 8.0.0 | 2026-04-15 |
| domain-authority-auditor | cross-cutting | 8.0.0 | 2026-04-15 |
| entity-optimizer | cross-cutting | 8.0.0 | 2026-04-15 |
| memory-management | cross-cutting | 8.0.0 | 2026-04-15 |

## Changelog

### v8.0.0 — Unified Version Release (2026-04-15)

Unifies all 20 skill versions to 8.0.0. Consolidates v7.0.0 (Wiki Knowledge Layer) and v7.1.0 (Auditor Runbook Inline Strategy) into a single coherent release with all skills at the same version.

**Includes all v7.0.0 and v7.1.0 changes**:
- Wiki Knowledge Layer with auto-refreshed structured index, project isolation, and `/seo:wiki-lint`
- Auditor Runbook with Critical Fail Cap enforcement (veto items cap at 60/100)
- Guardrail Negatives (windowed positive reframes for years, numbers, qualifiers)
- User-Facing Translation Layer (no internal jargon in audit output)
- `/seo:contract-lint` command for drift detection
- `/seo:p2-review` command for deferred item evaluation
- Auditor-class handoff extension fields (`cap_applied`, `raw_overall_score`, `final_overall_score`)
- New reference files: auditor-runbook.md, AUDITOR-AUTHORS.md, contract-fail-caps.md, ADR convention

---

### v7.1.0 — Auditor Runbook Inline Strategy (2026-04-11)

**Target**: protocol-layer auditors (`content-quality-auditor`, `domain-authority-auditor`).

**Heads-up for existing users**: if you audited a page under v7.0.0 and re-audit it now, your score may drop — for example from 82 to 60 — even though you didn't change the page. This is not a regression. It's the new rule catching something the old rule missed. When it happens, **scroll to the "Critical Issue to Fix" section of your audit report**. One item there (usually a missing disclosure, a misleading title, or data that contradicts itself) is capping your score. Fix that one item and the score returns to its natural level.

**What changed**:
- **Critical Fail Cap now enforced numerically**: when any veto item fails (CORE-EEAT T04/C01/R10, CITE T03/T05/T09), the affected dimension and overall score are capped at **60/100**. 2+ veto fails return `status: BLOCKED` instead of a score. Previously, veto fails only "capped at Low" with no numeric ceiling, producing misleadingly high scores.
- **Auditor Runbook** introduced at `references/auditor-runbook.md` as single source of truth for handoff schema, cap arithmetic (decision table + 3 worked examples), Guardrail Negatives (windowed positive reframes), Artifact Gate self-check, User-Facing Translation Layer, BLOCKED-path escape hatch, and cross-version rerun explainer. Sections §1-5 are inlined into both auditor SKILL.md files with dual sha256 sync markers (`source_sha256` + `block_sha256`) for drift detection.
- **Guardrail Negatives**: years in `[current_year − 2, current_year]`, numbered lists, qualifiers, short acronyms, and correct homepage/inner-page title patterns are treated as positive signals. Auditors no longer flag "2026" as stale when authored in 2026. Pages bearing an older year (e.g., "2020" in 2026) still get flagged for R-dimension review.
- **User-Facing Translation** (Runbook §5): veto item IDs, raw-vs-capped numeric deltas, and internal field names (`cap_applied`, `raw_overall_score`, `final_overall_score`) are forbidden in user-visible output. Translated to plain language. A rerun-after-upgrade detection prepends a one-line explainer when the score changed only because the rule changed.
- **Handoff extension fields** (`cap_applied`, `raw_overall_score`, `final_overall_score`) added for auditor-class skills. Non-auditor skills unaffected. Consumer skills treat these fields as optional with documented defaults during the v7.1.0 → v7.2.0 deprecation window. An extra `class: auditor` frontmatter field marks protocol-layer gates for `/seo:contract-lint` discovery.
- **CLAUDE.md 350-line rule** formally exempted for auditor-class skills to accommodate the inlined Runbook (~700 line ceiling).

**New reference files**:
- [references/auditor-runbook.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md) — authoritative Runbook
- [references/AUDITOR-AUTHORS.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/AUDITOR-AUTHORS.md) — onboarding guide for new auditor-class skill authors
- [references/decisions/README.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/decisions/README.md) — Architecture Decision Record convention
- [references/decisions/2026-04-adr-001-inline-auditor-runbook.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/decisions/2026-04-adr-001-inline-auditor-runbook.md) — rationale for this release
- `memory/hot-cache.md` seeded with an Auditor Runbook index line
- `memory/audits/` directory initialized for downstream P2 trigger evaluation

**Modified reference files**:
- [references/skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md) — added Auditor-class Extension clause to Handoff Summary Format
- [references/core-eeat-benchmark.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/core-eeat-benchmark.md) — veto section links to Runbook §2 for cap arithmetic, no numbers restated
- [references/cite-domain-rating.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/cite-domain-rating.md) — same treatment for T03/T05/T09

**Shipped alongside v7.1.0**: `/seo:contract-lint` drift detection command (dual-hash validation: `source_sha256` + `block_sha256`), `/seo:p2-review` command for July 2026 tombstone evaluation, `references/contract-fail-caps.md` cap numbers SSOT, PostToolUse hook for external Artifact Gate validation (with silent-skip for non-audit Writes).

**Deferred to v7.3.0**: multi-veto numeric cap calibration (requires 30+ real multi-veto audits in `memory/audits/`), Gap Typology field, Failure Modes Catalog. All subject to P2 observation triggers evaluated 2026-07-10 by `/seo:p2-review`.

**Rejected during review**: Blind Pass / Coverage Gap (Claude cannot genuinely ignore in-context frameworks), Evidence Layering ceremony (no consumer), Python-based deterministic layer (violates Tier 1 zero-dependency). See ADR-001 for full rejection rationale.

Reviewed across three rounds by 15 agent perspectives: Round 1 (Skeptic / UX Advocate / Impl Verifier / Prompt Engineer / Sustainability), Round 2 (Continuity Checker / Red Team / DevEx / Migration / Doc Quality), Round 3 (Impl Auditor / Integration Tester / Drift Preventer / Regression Checker / Release Readiness). The final implementation incorporates all 14 Round 3 findings including the 2 BLOCKERs (README.md sync, `class: auditor` discovery) and the 5 HIGH fixes (arithmetic integrity, hook silent-skip, cross-version rerun rule, archive format, dual-hash drift detection).

---

### v7.0.0 — Wiki Knowledge Layer + Infrastructure Upgrades (2026-04-06)

Major release: wiki compilation layer for cross-skill knowledge synthesis, plus infrastructure and community upgrades accumulated since v6.0.0. Inspired by [Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

**Wiki Knowledge Layer** ([full spec](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/proposal-wiki-layer-v3.md)):
- **Structured index**: `memory/wiki/index.md` — auto-refreshed compiled index of all WARM files with precise fields (score, 健康度, status, next_action, mtime) and best-effort summaries
- **Project isolation**: `memory/wiki/<project>/index.md` partitioned by hot-cache `project` field; single-project users unaffected
- **Auto-refresh**: PostToolUse silently updates index after WARM writes; first init requires manual trigger (`refresh wiki index`)
- **User-tier guidance**: SessionStart provides natural-language next-step guidance for light users; structured dashboards for power users
- **Compiled pages** (Phase 2): entity/keyword/topic pages with SHA-256 source hash tracking and confidence-labeled contradiction reconciliation (HIGH/MEDIUM/LOW)
- **`/seo:wiki-lint` command** (10th command): 7-check health scan — contradictions, orphan pages, stale claims, missing pages, cross-references, HOT drift, hash mismatches
- **WARM retirement dry-run** (Phase 3): `wiki-lint --retire-preview` lists candidates; actual archival requires user confirmation
- **Terminal architecture**: HOT/WIKI/COLD three-layer target via gradual WARM absorption
- **Safe rollback**: `rm -rf memory/wiki/` reverts to pre-wiki behavior with zero side effects
- **Response Presentation Norms**: conclusion-first, natural language, collapsible technical detail, no internal jargon in user-facing output
- **Optional Wiki Hints**: handoff summary fields (Wiki Entities, Wiki Keywords) for cross-skill metadata

**Infrastructure (from v6.1.0–v6.2.0)**:
- `when_to_use` and `argument-hint` frontmatter fields added to all 20 skills
- Hooks hardening: SessionStart matcher narrowed; Stop split into focused prompts; FileChanged monitors hot-cache overflow; UserPromptSubmit connector tier awareness
- Memory system: dual truncation rule (80 lines + 25KB), staleness protocol, frontmatter standard
- Community governance: SECURITY.md, CODE_OF_CONDUCT.md, CITATION.cff, PRIVACY.md, .github/FUNDING.yml, issue templates
- README redesign: hero tagline, badges, 6-language switcher, collapsible skill finder
- 5 localized READMEs: Chinese, Japanese, Korean, Spanish, Portuguese

### v6.0.0 — GStack Pattern Adoption + Full Polish (2026-03-31)

Consolidates v5.1.0, v5.2.0, and v5.2.1 into a single major release. All 20 skills updated to 6.0.0.

**Multilingual triggers (v5.1.0):**
- 750+ triggers across 5 languages (EN, ZH, JA, KO, ES/PT) for all 20 skills
- 11 trigger categories: EN-formal, EN-casual, EN-question, EN-competitor, ZH-pro, ZH-casual, JA, KO, ES, PT, misspellings
- Descriptions rewritten for 250-char display; multilingual tags added

**Shared contract upgrades (v5.2.0):**
- Completion Status Protocol: DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_INPUT
- Escalation Protocol: 3-fails → BLOCK; data confidence checks; scope limits
- Anti-Slop Output Voice: 30 banned words, 8 banned phrases, style rules, Bad vs Good examples
- Handoff Summary now includes Status as first field

**Core skill enhancements (v5.2.0):**
- keyword-research: Named workflow phases (Phase 1/8: Scope → Phase 8/8: Deliver) + quality bar
- content-quality-auditor: Decision Gates (stop-and-ask vs continue-silently)
- seo-content-writer: AUTO-FIX vs ASK issue classification with `### Changes Made` template

**Infrastructure (v5.2.0):**
- hooks.json: Audit staleness detection (30-day threshold)
- validate-skill.sh: `--status` flag with internal version consistency (SPLIT) detection
- validate-descriptions.py: 180 UTF-8 byte budget + docs/ exclusion

**Marketplace (v5.2.0):**
- All 20 descriptions rewritten to ≤180 UTF-8 bytes for full ClawHub display

**Polish (v5.2.1):**
- keyword-research: Phase 3 renamed "Expand" → "Variations"
- content-quality-auditor: Decision gate language — specific values + numbered options
- seo-content-writer: Changes Made block after final content with before/after table
- skill-contract.md: Escalation format aligned to Handoff Summary style (markdown bullets)
- memory-management: Description removes HOT/WARM/COLD internal jargon
- validate-skill.sh: Fixed find path bug for worktree environments

### v5.2.1 — Agent Team Polish (2026-03-31)

**UX and prompt precision improvements based on 5-agent review:**
- keyword-research: Phase 3 renamed "Expand" → "Variations" (more concrete for users)
- seo-content-writer: Auto-fix documentation — added `### Changes Made` table template with before/after columns
- content-quality-auditor: Decision gate language rewritten to include specific values, thresholds, and numbered options with outcomes
- skill-contract.md: Escalation report format changed from ALL_CAPS code block to markdown bullet list (matches Handoff Summary style)
- memory-management: Description removes HOT/WARM/COLD internal jargon → "hot-list, active work, and archive tiers"
- validate-skill.sh: `--status` now detects SPLIT (version: ≠ metadata.version: within same SKILL.md)

### v5.2.0 — GStack Pattern Adoption (2026-03-31)

**Shared Contract Upgrades (all 20 skills):**
- Added Completion Status Protocol (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_INPUT)
- Added Escalation Protocol (3 failed attempts → STOP; data confidence checks; scope limits)
- Added Anti-Slop Output Voice (30 banned words, 8 banned phrases, style rules, Bad vs Good examples)
- Handoff Summary now includes Status as first field

**Core Skill Enhancements:**
- keyword-research: Named workflow phases (Phase 1/8: Scope → Phase 8/8: Deliver) with quality bar
- content-quality-auditor: Decision Gates (stop-and-ask vs continue-silently conditions)
- seo-content-writer: AUTO-FIX vs ASK issue classification in final review

**Infrastructure:**
- hooks.json: Audit staleness detection (30-day threshold for memory/audits/ files)
- validate-skill.sh: --status flag for cross-file version alignment check

**Marketplace:**
- All 20 descriptions rewritten to ≤180 UTF-8 bytes for full ClawHub display
- validate-descriptions.py updated to byte-based budget with docs/ exclusion

### v5.1.0 (2026-03-29)

Multilingual trigger optimization and refinement for ClawHub/skills.sh marketplace discoverability. Reviewed by 8-agent team (code reviewer, trigger quality, description SEO, ZH/JA/KO/ES/EN language specialists).

**Description rewrite (all 20 skills)**:
- Rewrote all descriptions to fit within 250-char truncation limit (were 376-655 chars, all truncated)
- Added 5-language coverage: EN + ZH + JA + KO + ES in every description
- Pain-point phrasing over feature names for better LLM semantic matching
- Reordered YAML fields: name → description → version (maximizes ClawHub file[0:250] info density)
- Refined description openings: content-quality-auditor leads with "Publish-readiness gate", memory-management leads with "Persist SEO/GEO campaign context"
- geo-content-optimizer now names 6 AI products: ChatGPT, Perplexity, AI Overviews, Gemini, Claude, Copilot

**Triggers expansion (all 20 skills, ~247 → ~750+)**:
- 11 categories: EN-formal, EN-casual, EN-question, EN-competitor, ZH-pro, ZH-casual, JA, KO, ES, PT, misspellings
- ZH: Added 挖词, 收录, 友链, 月报, 品牌词, TDK, 锚文本, 词库, 数据看板 and 20+ more
- KO: Added casual question forms to 8 skills (키워드 어떻게 찾아요, 왜 순위가 안 올라가, etc.)
- JA: Added ロングテールキーワード, インデックス登録, 検索順位チェック, モバイル最適化, 検索意図分析
- ES: Added posicionamiento web, mi sitio no aparece en Google, posicionamiento SEO
- PT: Added meu site não aparece no Google, monitoramento de posições
- EN: Added canonical tag issues, my rankings tanked, Google penalty recovery, Perplexity/ChatGPT competitor triggers

**Trigger mislocation fixes**:
- Moved "排名上不去" from seo-content-writer to on-page-seo-auditor
- Replaced "帮我写软文" (advertorial) → "帮我写SEO文章"
- Replaced "网站打不开" (hosting) → "网站加载太慢"
- Replaced "流量太低" (ambiguous) → "帮我挖词"
- Replaced "网站权重怎么样" (Baidu Weight) → "网站可信度怎么样"
- Fixed EN cross-skill ambiguity: "off-page SEO" → "link profile analysis"

**Tags expansion (all 20 skills)**:
- Added multilingual tags (ZH, JA, KO, ES) to all skills
- Added competitor tool cross-discovery tags

**Infrastructure**:
- Added scripts/validate-descriptions.py (dual-budget validation: desc≤250 + file[0:250] coverage)
- Fixed 5 pre-existing YAML formatting bugs in trigger lists
- Fixed JA trigger quality: サープ→検索結果, パフォーマンス報告→パフォーマンスレポート

### v5.0.0 (2026-03-29)

Unified operating model: shared skill contract, prompt-based hook automation, three-tier temperature memory, protocol-layer gates, state write-through, trigger widening, and published-link hardening.

**Unified skill contract (Plan C)**:
- Added shared [skill contract](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md) and [state model](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/state-model.md) reference documents
- Updated all 20 SKILL.md files with `When This Must Trigger`, `Quick Start`, `Skill Contract`, and `Next Best Skill` sections
- Replaced bulky per-file 20-skill navigation blocks with a compact system-mode header

**Hook lifecycle (Plan C+)**:
- Added 4-event prompt-based hooks in hooks/hooks.json (SessionStart, UserPromptSubmit, PostToolUse, Stop)
- SessionStart auto-loads memory/hot-cache.md and reminds stale open loops (>7 days)
- PostToolUse auto-recommends content-quality-auditor after content writing
- Stop prompts to save findings and auto-saves veto-level issues to hot-cache

**Temperature memory (Plan C+)**:
- Three-tier model: HOT (80 lines, auto-loaded) / WARM (200 lines/file, on-demand) / COLD (archive, unlimited)
- Automatic promotion (2+ skill refs or 3+ refs within 7 days) and demotion (30 days HOT→WARM, 90 days WARM→COLD)
- memory-management upgraded to Campaign Memory Loop with sole WARM→COLD archival authority

**Protocol-layer gates (Plan C + C+)**:
- content-quality-auditor → Publish Readiness Gate with SHIP/FIX/BLOCK verdicts
- domain-authority-auditor → Citation Trust Gate with TRUSTED/CAUTIOUS/UNTRUSTED verdicts
- entity-optimizer → Canonical Entity Profile with sole write authority for memory/entities/
- memory-management → Campaign Memory Loop with cross-skill aggregation and lifecycle management
- Gate checks automatically recommended in build and monitor skill handoffs

**State write-through (Plan C+)**:
- All 20 skills include Save Results flow with user confirmation
- Veto-level issues (CORE-EEAT T04/C01/R10, CITE T03/T05/T09) auto-save to memory/hot-cache.md
- Dated file naming: YYYY-MM-DD-topic.md across all memory/ paths

**Trigger widening (Plan C+)**:
- All 20 skills add 3-4 everyday language triggers alongside professional terms
- When This Must Trigger sections add scenario lead-in for intent matching without SEO terminology

**Published link reliability**:
- Replaced repo-internal relative Markdown links with absolute GitHub links across all docs, commands, skills, and references
- Updated README badges and navigation links to point at canonical GitHub pages
- Corrected mis-nested cross-reference targets during link conversion

**Documentation and positioning**:
- README, AGENTS, CLAUDE, CONTRIBUTING updated for operating-model positioning
- AGENTS.md: new Hooks & Automation section with hook table and temperature memory model
- CLAUDE.md: added hook automation and temperature memory references
- README: added Automation and Memory subsections to Operating Model

**Infrastructure**:
- plugin.json: hooks array expanded to 4 events; description updated; version 5.0.0
- marketplace.json: version synced to 5.0.0
- All 20 skill metadata.version bumped to 5.0.0

### v4.0.0 (2026-03-24)

ClawHub-first marketplace optimization: security fixes, vector search descriptions, multi-ecosystem install documentation.

**Security & metadata fixes**:
- Removed self-contradictory `metadata.openclaw` blocks from 9 skills (soft dependencies incorrectly declared as hard requirements)
- Fixed copy-paste error: alert-manager and performance-reporter had `primaryEnv: AMPLITUDE_API_KEY` (unrelated to their function)
- Added credential-optional statements to 11 skills with external tool integrations
- Added `homepage` field to all 20 SKILL.md frontmatters

**ClawHub search optimization**:
- Rewrote all 20 skill descriptions with natural language summaries prepended for vector search discovery
- Streamlined trigger phrases to 6-8 highest-frequency per skill
- Updated footer links to include GitHub, ClawHub, and skills.sh

**Documentation migration**:
- README: Replaced single-recommendation install with tool-based routing table (OpenClaw / Claude Code / Cursor+Codex+Windsurf)
- AGENTS.md: ClawHub moved to first position in ecosystem table; install section uses routing table
- CONTRIBUTING.md: Fixed template missing ClawHub and Vercel Labs in compatibility field; added `clawhub publish` / `clawhub sync` commands
- CLAUDE.md: Added ClawHub and skills.sh marketplace links
- config.yml: Added ClawHub Marketplace as issue template contact link

**Infrastructure**:
- plugin.json: homepage changed from skills.sh to GitHub repo URL (neutral)
- marketplace.json: version synced to 4.0.0
- validate-skill.sh: Updated openclaw check from WARN-if-missing to PASS-if-missing (pure instruction skills don't need runtime declarations)

### v3.0.0 (2026-03-04)

Consolidates all post-2.0.0 changes into a single major release aligned with plugin-dev, skill-creator, and financial-services-plugins standards.

**Plugin manifest (plugin-dev spec)**:
- Added `schemaVersion: "1.0.0"` and `id` fields
- Added `description` to all 9 commands and 20 skills in plugin.json and marketplace.json
- Restructured `hooks` from object to array format `[{event, path}]`
- Restructured `mcpServers` from object to array format `[{id, path}]`
- Added `displayName`, `capabilities`, `metadata` blocks
- Added typed `parameters` to all 9 command files

**Skill format (skill-creator spec)**:
- Added top-level `version` field to all 20 SKILL.md frontmatters
- Added `compatibility` field to all 20 skills
- Added `allowed-tools: WebFetch` to 5 skills with live URL fetching
- Added `allowed-tools: ["WebFetch"]` to 3 commands (audit-page, check-technical, generate-schema)
- Trimmed 7 SKILL.md files to ≤350 lines (deduplicated tags, condensed verbose sections)

**Infrastructure (financial-services-plugins patterns)**:
- Added `CLAUDE.md` for Claude Code auto-loading context
- Added `hooks/hooks.json` scaffold
- Added `scripts/validate-skill.sh` CLI validation tool
- Added disclaimer section to README.md
- Moved `marketplace.json` from `.claude-plugin/` to repo root
- Extracted reference data from 5 oversized skills into `references/` subdirectories

**Fixes**:
- Fixed `marketplace.json` name mismatch
- Fixed step numbering bug in `geo-content-optimizer`
- Updated CONTRIBUTING.md with 5-file sync requirement

### v2.0.0 (2026-02-08)
- CORE-EEAT content quality benchmark (80 items, 8 dimensions, veto system)
- CITE domain authority rating (40 items, 4 dimensions, veto system)
- Content-type weighted scoring and domain-type weighted scoring
- Entity optimizer with Knowledge Graph + Wikidata + AI resolution
- Memory management with two-layer hot/cold storage
- Tool-agnostic ~~placeholder connector system with progressive enhancement tiers
- 9 one-shot commands (`/seo:audit-page`, `/seo:audit-domain`, etc.)
- Inter-skill handoff protocol with score passthrough
- skills.sh marketplace and Claude Code plugin distribution

### v1.0.0 (2026-01-28)
- 20 skills across 5 categories (research, build, optimize, monitor, cross-cutting)
- Basic SEO and GEO content optimization workflows
