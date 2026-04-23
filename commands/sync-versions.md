---
name: sync-versions
description: Propagate the canonical version from .claude-plugin/plugin.json to all cross-agent manifest files so Gemini, Qwen, CodeBuddy, and the skills.sh marketplace stay in lockstep with the Claude Code manifest. Pure-markdown command — reads and writes JSON files directly, no executable script.
argument-hint: "[--dry-run]"
allowed-tools: ["Read", "Edit"]
parameters:
  - name: dry-run
    type: boolean
    required: false
    description: Report what would change without writing. Default is apply.
---

# Sync Versions Command

Keeps the version field aligned across every manifest the library publishes to. Canonical source is `.claude-plugin/plugin.json`. Zero executable code -- uses Read/Edit tools.

## Usage

```
/seo:sync-versions
/seo:sync-versions --dry-run
```

Run after editing `.claude-plugin/plugin.json` `version` field. Idempotent: no-op when everything is in sync.

## Workflow

1. **Read canonical source**: Read `.claude-plugin/plugin.json`, extract `version` (`$V`). Stop with error if missing.

2. **Update each target file** using Edit tool (preserve indentation, key order, trailing newline):

   | Target file | Paths to update |
   |---|---|
   | `marketplace.json` | `metadata.version`, `plugins[0].version` |
   | `gemini-extension.json` | top-level `version` |
   | `qwen-extension.json` | top-level `version` |
   | `.codebuddy-plugin/marketplace.json` | top-level `version`, `plugins[0].version` |

   Do NOT touch other `version` fields (schema versions, SKILL.md `metadata.version`, etc.).

3. **Idempotence**: skip paths already equal to `$V`. If `--dry-run`, report only.

4. **Summary report** example (9.0.0 -> 9.1.0):
   ```
   Sync versions -> 9.1.0
     marketplace.json: metadata.version ok (was 9.0.0)
     gemini-extension.json: version ok (was 9.0.0)
     qwen-extension.json: version: already in sync
     ...
   5 file(s) updated, 1 field already in sync.
   ```

5. **Follow-ups NOT done** (flag for user): 20 SKILL.md `metadata.version` (manual per CLAUDE.md), VERSIONS.md changelog, CITATION.cff, README.md + localized docs badges.

## Fallback for no-Claude environments

```bash
V=$(jq -r .version .claude-plugin/plugin.json) && \
  jq --arg v "$V" '.metadata.version=$v | .plugins[0].version=$v' marketplace.json > marketplace.json.tmp && mv marketplace.json.tmp marketplace.json && \
  jq --arg v "$V" '.version=$v' gemini-extension.json > gemini-extension.json.tmp && mv gemini-extension.json.tmp gemini-extension.json && \
  jq --arg v "$V" '.version=$v' qwen-extension.json > qwen-extension.json.tmp && mv qwen-extension.json.tmp qwen-extension.json && \
  jq --arg v "$V" '.version=$v | .plugins[0].version=$v' .codebuddy-plugin/marketplace.json > .codebuddy-plugin/marketplace.json.tmp && mv .codebuddy-plugin/marketplace.json.tmp .codebuddy-plugin/marketplace.json
```

## Related

[CLAUDE.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/CLAUDE.md) Contribution Rules | [VERSIONS.md](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/VERSIONS.md)
