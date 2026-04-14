# Auditor Authors Guide

> For contributors writing a new auditor-class skill (for example, `mobile-seo-auditor` or `local-seo-auditor`). If you are NOT writing an auditor, read [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md) instead.

## Start here

Read these three files in order before touching anything:

1. **[skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md)** — the general handoff contract all 20 skills follow
2. **[auditor-runbook.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md) §1-5** — the auditor-specific extension: handoff schema, cap arithmetic, guardrails, Artifact Gate, translation
3. **[contract-fail-caps.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/contract-fail-caps.md)** (from v7.2.0) — the cap numbers, single source of truth

Then copy the template below.

---

## Template skill

`optimize/your-auditor/SKILL.md`:

````markdown
---
name: your-auditor
description: "Audits [what] and returns a verdict. Part of the seo-geo skills library."
version: "1.0.0"
class: auditor        # enables /seo:contract-lint discovery
when_to_use: "..."
argument-hint: "<url or content>"
license: Apache-2.0
metadata:
  author: your-handle
---

# Your Auditor

## When This Must Trigger
[standard sections per skill-contract.md]

## Quick Start
[one-line invocation + common scenario + output expectation]

## Skill Contract
- **Reads**: ...
- **Writes**: ...
- **Promotes**: ...
- **Primary next skill**: ...

## Instructions

### Step 1-3: [your specific audit logic]

<!-- runbook-sync start: source_sha256=<computed-from-auditor-runbook.md> block_sha256=<computed-from-extracted-sections-1-5> -->
## Scoring Runbook (authoritative)

> DO NOT EDIT THIS BLOCK. Mirror of references/auditor-runbook.md §1-5.
> To modify, edit the source file and re-run the sync procedure.

[... full Runbook §1-5 content copied verbatim ...]
<!-- runbook-sync end -->

### Step 4.5: Apply Scoring Runbook
Execute in order, referring to the Scoring Runbook block above:
1. Cap Enforcement (Runbook §2): walk the decision table
2. Artifact Gate Self-Check (Runbook §4): run the 7-item checklist
3. User-Facing Translation (Runbook §5): translate before rendering to user

## Validation Checkpoints
[...]

## Reference Materials
[...]

## Next Best Skill
[...]
````

---

## Veto registration checklist

To add a new veto item (for example, `M01` for a missing mobile viewport tag):

1. Define M01 in `references/mobile-seo-benchmark.md` (or the framework file for your dimension)
2. Append M01 row to `references/contract-fail-caps.md` with cap number (from v7.2.0), or inherit the 60-default from `auditor-runbook.md §2`
3. Do **NOT** edit `auditor-runbook.md §2` worked examples — the 3 worked examples cover generic veto behavior; M01 behaves the same way
4. Your SKILL.md inlines the Runbook as-is (no M01-specific additions inside the inlined block)
5. Run `/seo:contract-lint` locally before committing

**Principle**: cap arithmetic is veto-agnostic. Adding a veto item to a framework file does not require Runbook or existing auditor changes beyond the inline copy being current.

---

## Anti-patterns

Don't:

- ❌ **Link the Runbook instead of inlining it.** Links are inert at skill activation time. You must inline the full §1-5 content between sync markers.
- ❌ **Restate cap numbers.** The number 60 lives in `auditor-runbook.md §2` (and in `contract-fail-caps.md` from v7.2.0). Do not write "60" as a cap threshold anywhere else in your skill.
- ❌ **Leak veto IDs to user output.** Runbook §5 Translation Layer is mandatory. Users never see "T04 failed" — they see "Missing affiliate disclosure."
- ❌ **Invent a new handoff field.** Extend via `auditor-runbook.md §1`. Propose changes through an ADR in `references/decisions/`.
- ❌ **Edit the inlined Runbook copy directly.** Edit the source in `references/auditor-runbook.md` and re-run the sync procedure below.
- ❌ **Silently cap scores.** Always show the raw and capped values in the internal report, then translate for the user via §5.

---

## Runbook update procedure (for maintainers)

When editing `references/auditor-runbook.md`:

1. Make the edit to the source file
2. Update the version line in the Runbook frontmatter
3. Recompute the sha256 of the Runbook file content:
   ```bash
   shasum -a 256 references/auditor-runbook.md
   ```
4. Update the inlined §1-5 block in every auditor SKILL.md with the new content AND the new sha256 in the sync marker
5. If you added or removed a rule in §1-5, update §6 Lint Coverage Manifest and `commands/contract-lint.md` in the same commit
6. Run `/seo:contract-lint` to verify sha256 match and manifest coverage
7. Commit everything in one commit with message `runbook: <description>`

---

## FAQ

**Q: My skill produces a score but is not a protocol-layer gate. Do I inline the Runbook?**

A: No. Only protocol-layer auditors (currently `content-quality-auditor` and `domain-authority-auditor`, plus future gates) inline the Runbook. If your skill is in `optimize/` or `research/` and produces advisory scoring, follow `skill-contract.md §Handoff Summary Format` without the cap extension.

**Q: `/seo:contract-lint` fails on my PR but I didn't touch the Runbook. What happened?**

A: Likely the Runbook was updated upstream and you have stale inlined copies. Pull main, re-run the sync procedure, commit the updates.

**Q: How do I know my new auditor is registered with contract-lint?**

A: Add `class: auditor` to your SKILL.md frontmatter. Contract-lint discovers auditor-class skills via frontmatter glob.

**Q: Can I write my own cap arithmetic?**

A: No. `auditor-runbook.md §2` is authoritative. If you think the rule needs to change, propose it via an ADR in `references/decisions/`.

**Q: What about the 350-line SKILL.md rule?**

A: Formally exempted for auditor-class skills in `CLAUDE.md`. The exemption allows a ~750 line ceiling to accommodate the inlined Runbook. See [ADR-001](decisions/2026-04-adr-001-inline-auditor-runbook.md) for the rationale.

**Q: Do I copy the Runbook manually, or is there a sync command?**

A: For v7.1.0, manual copy-paste. For v7.2.0, `/seo:contract-lint` detects drift but does not auto-fix. A future sync command (not yet specified) may automate propagation.

**Q: My skill uses a different framework (not CORE-EEAT or CITE). Do I still inline the Runbook?**

A: Yes if you have veto items that warrant a score cap. The Runbook arithmetic is framework-agnostic — it describes how to handle veto fails, not which items count. Add your framework's veto items to your own benchmark file and let the Runbook arithmetic apply to them.

---

## Related

- [auditor-runbook.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/auditor-runbook.md) — authoritative Runbook (§1-5 inlined, §6 source-only)
- [skill-contract.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/skill-contract.md) — general contract all skills follow
- [ADR-001](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/references/decisions/2026-04-adr-001-inline-auditor-runbook.md) — why inlining was chosen over contract inheritance
- [commands/contract-lint.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/commands/contract-lint.md) (v7.2.0) — drift detection command
