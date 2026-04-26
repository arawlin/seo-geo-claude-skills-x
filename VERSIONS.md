# SEO & GEO Skills Library — Versions

Current versions of all skills. Agents can fetch this file from `https://raw.githubusercontent.com/aaron-he-zhu/seo-geo-claude-skills/main/VERSIONS.md` once per session to check for updates.

**Versioning**: v9.5.0 is a consolidated release. Skill `version` and `metadata.version` values are aligned to the plugin version so external marketplaces can publish one clean post-v9.0.0 update.

## Skills

| Skill | Category | Version | Last Updated |
|-------|----------|---------|--------------|
| keyword-research | research | 9.5.0 | 2026-04-26 |
| competitor-analysis | research | 9.5.0 | 2026-04-26 |
| serp-analysis | research | 9.5.0 | 2026-04-25 |
| content-gap-analysis | research | 9.5.0 | 2026-04-25 |
| seo-content-writer | build | 9.5.0 | 2026-04-26 |
| geo-content-optimizer | build | 9.5.0 | 2026-04-26 |
| meta-tags-optimizer | build | 9.5.0 | 2026-04-25 |
| schema-markup-generator | build | 9.5.0 | 2026-04-26 |
| on-page-seo-auditor | optimize | 9.5.0 | 2026-04-26 |
| technical-seo-checker | optimize | 9.5.0 | 2026-04-26 |
| internal-linking-optimizer | optimize | 9.5.0 | 2026-04-26 |
| content-refresher | optimize | 9.5.0 | 2026-04-26 |
| rank-tracker | monitor | 9.5.0 | 2026-04-25 |
| backlink-analyzer | monitor | 9.5.0 | 2026-04-25 |
| performance-reporter | monitor | 9.5.0 | 2026-04-26 |
| alert-manager | monitor | 9.5.0 | 2026-04-25 |
| content-quality-auditor | cross-cutting | 9.5.0 | 2026-04-25 |
| domain-authority-auditor | cross-cutting | 9.5.0 | 2026-04-25 |
| entity-optimizer | cross-cutting | 9.5.0 | 2026-04-25 |
| memory-management | cross-cutting | 9.5.0 | 2026-04-25 |

## Changelog

### v9.5.0 — Consolidated post-v9.0.0 release (2026-04-26)

Single public release consolidating all work after v9.0.0 into one clean update.

**What changed**: neutralized the prompt-injection false positive in `/seo:geo-drift-check`; replaced the Windows-incompatible marketplace symlink with a real mirror file; added `allowed-tools` to `/seo:contract-lint` from PR #10; compressed regular skill shells, commands, root docs, and high-volume reference packs while preserving execution contracts; added `scripts/validate-slimming-guardrails.sh`; strengthened `validate-skill.sh` for shared-section checks and auditor runbook hash validation; updated release workflow checks; aligned cross-agent manifests, marketplace files, badges, CITATION, and all skill versions to 9.5.0; and fixed issue #14 by replacing interactive Stop hooks with an allow-only JSON Stop guard.

**Guardrails kept**: all 20 skills and 15 commands remain. Discovery aliases, CORE-EEAT, CITE, auditor runbook semantics, memory/entity contracts, schema placeholders, technical audit fields, reporting benchmarks, data freshness requirements, CTA logic, intent mapping, anchor distribution thresholds, KPI formulas, WCAG checks, rich-result policy checks, and backlink disavow safety rules are preserved.

**External credit**: PR #10 from @xiaolai identified the missing `allowed-tools` declaration for `/seo:contract-lint`; the consolidated git commit carries a `Co-authored-by` trailer for that contribution.

### v9.0.0 — Quality Pass + Multi-Agent Compatibility (2026-04-17)

Major release combining three streams of work: (1) a 6-agent panel quality review with legal/compliance hardening, (2) ten new playbooks and instructions-detail references that make skills directly executable without inline bloat, and (3) native install support for five additional AI coding agents.

**Heads-up for existing users**: no breaking changes to skill I/O contracts. Score numbers may shift slightly on re-audit because of new FTC/GDPR/WCAG checks and tightened veto evaluation; if so, the affected item is flagged in the "Critical Issue to Fix" section. The core operating model (trigger → quick start → skill contract → handoff → next best skill) is unchanged.

#### Legal & Compliance (new)

- **SECURITY.md** scraping boundaries — robots.txt, CFAA, hiQ v LinkedIn / Meta v Bright Data precedents, EU DSM Art 4 TDM-reservation awareness
- **FTC affiliate-disclosure enforcement** in CORE-EEAT T04 — five new sub-items. Substantive standard: 16 CFR §255.5 (Endorsement Guides); penalty hook: 15 U.S.C. §45(m) → 2024 Trade Regulation Rule on Consumer Reviews and Testimonials (16 CFR Part 465), inflation-adjusted annually per 16 CFR §1.98 (~$53K/violation in 2025)
- **GDPR Art 4 / Art 17** retention + deletion flow in `memory-management`; **Art 6** lawful-basis prompt in `entity-optimizer`
- **EU AI Act Art 53** TDM reservation in `technical-seo-checker/references/llm-crawler-handling.md`
- **ADA / WCAG 2.2 AA** alt-text rebalance — 1.1.1 descriptive primary, SEO keyword secondary (previous ordering risked ADA compliance claims)
- **Schema aggregateRating** truth warnings on 4 template blocks (preventing fake-rating schemas)
- **Trademark annotations** — Moz Domain Authority™ / Ahrefs Domain Rating™ referenced with TM glyphs where first mentioned

#### New Playbooks (high-value, directly usable)

- `build/geo-content-optimizer/references/ai-overview-recovery.md` — playbook for recovering traffic after losing Google AI Overview citation
- `optimize/on-page-seo-auditor/references/bulk-audit-playbook.md` — site-wide batch audit workflow
- `optimize/technical-seo-checker/references/bulk-audit-playbook.md` — counterpart for technical health
- `optimize/technical-seo-checker/references/ecommerce-platform-patterns.md` — Shopify, WooCommerce, Headless, BigCommerce, Magento common issues
- `optimize/technical-seo-checker/references/llm-crawler-handling.md` — robots.txt patterns for GPTBot, ClaudeBot, Gemini, Perplexity, etc.
- `optimize/technical-seo-checker/references/pre-migration-playbook.md` — 6-stage WordPress → Headless migration guide
- Inter-skill contracts: `references/entity-geo-handoff-schema.md` (entity-optimizer ↔ geo-content-optimizer) and `references/geo-score-feedback-loop.md` (T+14/T+45/T+90 validation protocol)

#### New command

- `/seo:geo-drift-check` (experimental) — validates predicted GEO Score against actual AI-engine citation behavior. Pure-markdown command; uses whichever AI-engine MCP the user has connected. No Python scripts, no scheduled runners, no bundled API keys.

#### Content Quality (SKILL.md size compliance)

- 11 SKILL.md files trimmed to ≤350 lines per CLAUDE.md rule. Execution detail moved to `references/instructions-detail.md` (9 new reference files across research/build/cross-cutting). Skill body now declares behavior; detail file defines procedure. Reduces cold-load token footprint by ~40% on affected skills.
- Handoff Summary template added to all 18 non-auditor skills (20/20 coverage now).

#### Memory System Expansion

- Memory scaffolding: `memory/glossary.md`, `memory/decisions.md`, `memory/open-loops.md`, `memory/entities/candidates.md`, `memory/geo-feedback/` (with YAML frontmatter + initial templates)
- Library terminology merged into `README.md#terminology` (collapsed details section). Reduces jargon friction for new users.

#### Contract Hardening

- Cap rounding determinism: `math.floor` rule added to Runbook §2 (no more 59.8 vs 59 off-by-one)
- Runbook SHA256 alignment made six-way (source × 3 + block × 4) via class marker for `contract-lint` reliability
- Next Best Skill cycle termination: verdict-conditional + visited-set patterns in 5 skills, documented in `skill-contract.md`
- `class: auditor-output` frontmatter marker added for hook field decoupling
- Wiki sole-writer delegation clarified in `state-model.md`
- HOT tier identity unified (32 stale `CLAUDE.md` references swapped for `memory/hot-cache.md`)
- `gap_type` namespace disambiguation (entity vs audit)
- `approved_by` provenance cascade for `memory/decisions.md`

#### i18n & UX

- Quick Start in 60 seconds — 3-step TL;DR above the detailed install table
- Commands tier split: 10 user (day-to-day) + 5 maintenance (for power users; includes the two slash commands that replaced the purged `.py` scripts)
- Next Best decision trees embedded in 5 skills (`keyword-research`, `content-quality-auditor`, `on-page-seo-auditor`, `competitor-analysis`, `entity-optimizer`)
- Mini-examples (User prompt + Output + Reference link) in 10 trimmed Example sections
- Jargon dimension codes (C/O/R/E/Exp/Ept/A/T) removed from `/seo:audit-page` and `/seo:audit-domain` user-visible output
- `--technical` flag removed (§5 violation)
- 3 thin skills expanded: `memory-management`, `internal-linking-optimizer`, `schema-markup-generator` (+39 triggers in JA/KO/ES/PT + misspellings)
- ES/PT diacritics restored (48 accented characters each, 0 regressions)
- Language switcher labels corrected: Espanol → Español, Portugues → Português

#### Native Install (5 more agents)

Carried forward from v8.0.3 interim work:

- Gemini CLI: `gemini extensions install <github-url>` — via new `gemini-extension.json`
- Qwen Code: `qwen extensions install <github-url>` — via new `qwen-extension.json`
- Amp: `amp skill add aaron-he-zhu/seo-geo-claude-skills` — works out-of-box
- Kimi Code CLI: `kimi plugin install <github-url>` — works out-of-box
- CodeBuddy: `/plugin marketplace add <repo>` then `/plugin install aaron-seo-geo` (in-app 2-step) — via new `.codebuddy-plugin/marketplace.json`

#### Zero-.py design philosophy (enforced)

v9.0.0 removes **all Python scripts** from the repo to enforce AGENTS.md's "content-only repository" claim. The two previous dev utilities are now slash commands:

- `scripts/sync-versions.py` → deleted; replaced by [`/seo:sync-versions`](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/commands/sync-versions.md) maintenance command (pure-markdown; includes a jq one-liner fallback for CI)
- `scripts/validate-descriptions.py` → deleted; replaced by [`/seo:validate-library`](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/commands/validate-library.md) maintenance command
- `scripts/validate-skill.sh` retained (bash, pre-existing, ClawHub spec validator)

Contribution rule added to [CLAUDE.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/CLAUDE.md): new developer utilities go as `commands/*.md` slash commands, not `.py` scripts.

#### Infrastructure

- `cloudmetrics.io` (real domain, tort risk) replaced with `acme-analytics.example` (RFC 2606 reserved) in examples
- `hooks.json` dangling reference fixed (`examples.md §Archive Block Format`)
- PRIVACY.md accuracy rewrite (default no-transmit + WebFetch + MCP explicit)
- PostToolUse hook session-level debounce (content-quality nag suppression)
- Wiki init threshold lowered (5 → 3 non-stub files)
- Artifact Gate structural requirements now checked via path + frontmatter rather than prose grep

#### Validators (all green)

- validate-skill.sh per-directory: 20/20 pass, 0 warnings
- validate-skill.sh --status: 20/20 version-consistent across `version:` and `metadata.version:`
- `/seo:validate-library` (replaces validate-descriptions.py): 20/20 pass
- JSON parse (plugin, marketplace, .mcp.json, hooks.json, gemini-extension, qwen-extension, .codebuddy-plugin/marketplace): 7/7 OK
- 622 GitHub absolute URLs verified resolvable
- 160/160 required skill sections present
- Six-way SHA256 alignment verified across inlined Runbook §1-5

---

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

> Earlier versions (v1.0.0–v7.1.0) are documented in [GitHub Releases](https://github.com/aaron-he-zhu/seo-geo-claude-skills/releases).
