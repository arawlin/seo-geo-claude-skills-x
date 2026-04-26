---
name: validate-library
description: Library-level quality gate. Walks all 20 SKILL.md files and verifies description budgets, YAML field order, language coverage, duplicate trigger detection, frontmatter validity, release-file consistency, and slimming regression guardrails. Maintenance command — run before version bumps and PRs.
argument-hint: "[--skill <name>] [--strict]"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
parameters:
  - name: skill
    type: string
    required: false
    description: Scan a single skill directory instead of all 20.
  - name: strict
    type: boolean
    required: false
    description: Report-only by default. Pass --strict to exit non-zero on any failure (CI use).
---

# Validate Library Command

Replaces `scripts/validate-descriptions.py`. Pure-markdown command using Read/Glob/Grep tools -- no executable code.

## Usage

```
/seo:validate-library                          # scan all 20, report-only
/seo:validate-library --skill keyword-research # scan one skill
/seo:validate-library --strict                 # CI mode: STATUS: PASS or FAIL
```

Run before version bumps, release PRs, or any slimming pass. Complements `/seo:contract-lint`, `scripts/validate-skill.sh`, and `scripts/validate-slimming-guardrails.sh`.

## What It Checks

### 1. Description budget (+/-20% tolerance)
Each SKILL.md `description:` should land within byte budget (UTF-8). Targets: research 800 (640-960), build 900 (720-1080), optimize 900 (720-1080), monitor 700 (560-840), cross-cutting 1000 (800-1200). Report one line per skill with actual bytes and pass/fail.

### 2. Required YAML frontmatter fields
Must have in order: `name` (matches dir, lowercase a-z/0-9/hyphens, 1-64 chars), top-level `version` (semver-like), `description` (1-1024 chars), `license` (recommended, default Apache-2.0), `compatibility` (recommended), `metadata` (with `author`, `version`, `tags`, `triggers`). `when_to_use` must come before `allowed-tools` if both present.

### 3. Language coverage
`metadata.triggers` must include EN and ZH trigger phrases. Additional languages encouraged. Flag any skill missing EN or ZH.

### 4. Duplicate triggers
No trigger phrase in more than one skill (case-insensitive, Unicode-normalized). Report offending phrase + claiming skills.

### 5. Frontmatter validity
YAML must parse cleanly. `name` must match parent dir. `metadata.version` and top-level `version:` must agree. No BOM, mixed tabs/spaces, or trailing whitespace in keys.

### 6. Marketplace file consistency (library-level)
Both `marketplace.json` and `.claude-plugin/marketplace.json` must be real files (mode `100644`, not `120000` symlink) with byte-identical content. Procedure: check `git ls-files -s` for both, then `shasum -a 256` comparison. Fix: `cp marketplace.json .claude-plugin/marketplace.json`.

### 7. Slimming regression guardrails
Run `bash scripts/validate-slimming-guardrails.sh`. It must protect:
- Must-keep discovery aliases: `robots.txt`, `sitemap`, `canonical`, `schema.org`, `schema-org`, AI SEO/GEO aliases (`ai-seo`, `AI optimization`, `generative engine optimization`, `AI搜索优化`), keyword tool-switch aliases (`Ahrefs`, `Semrush`, `Google Keyword Planner`, `Ubersuggest`), and memory/wiki entry points.
- Historical template regressions: robots/sitemap/`lastmod`, HSTS, image filename/lazy-load, CORE-EEAT `/17` section plus scaled `/20` roll-up, authority metric, schema placeholders, review fragments, disavow safety, dateModified/lastmod freshness, migration thresholds, and audience/data-freshness/source-date fields.
- Protected runtime contracts: `skill-contract.md`, `state-model.md`, `hooks/hooks.json`, `memory-management`, and `entity-optimizer` handoff/profile contracts.

### 8. Release surface consistency
Before publishing, confirm all release surfaces agree: `.claude-plugin/plugin.json`, both marketplace files, Gemini/Qwen/CodeBuddy extension manifests, `CITATION.cff`, `VERSIONS.md`, `CLAUDE.md`, README badges, localized README badges, and JSON parseability. `/seo:sync-versions` is useful but not sufficient by itself.

## Workflow

1. Enumerate SKILL.md files (`--skill <name>` or glob all 20).
2. Read frontmatter, run checks 1-5 per skill.
3. Run marketplace check (once, library-level).
4. Run slimming regression guardrails and release surface checks.
5. Print summary table:
   ```
   SKILL                    DESC BYTES  YAML  LANG  DUPES  VERSION  STATUS
   keyword-research         862  OK     OK    EN,ZH OK     9.0.0    PASS
   ...
   Total: 20  Passed: 20  Failed: 0
   MARKETPLACE: OK
   ```
6. **Strict mode**: final line `STATUS: PASS` or `STATUS: FAIL` (any per-skill failure, marketplace fail, slimming guardrail fail, or release surface mismatch). CI parses with `tail -n 1`.

## Fallback for no-Claude environments

`bash scripts/validate-skill.sh <category>/<skill-dir>` covers checks 2+5 (ClawHub spec). `bash scripts/validate-skill.sh --status` checks skill version consistency. `bash scripts/validate-slimming-guardrails.sh` covers release-surface and semantic regression checks. These shell checks do not cover description budget, language coverage, or duplicate triggers.

## Related

[scripts/validate-skill.sh](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/scripts/validate-skill.sh) | [scripts/validate-slimming-guardrails.sh](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/scripts/validate-slimming-guardrails.sh) | `/seo:sync-versions` | `/seo:contract-lint`
