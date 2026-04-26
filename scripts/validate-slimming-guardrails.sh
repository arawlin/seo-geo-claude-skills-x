#!/usr/bin/env bash
# validate-slimming-guardrails.sh — semantic regression checks for repository slimming passes.
#
# This script protects high-value discovery aliases, runtime contracts, and
# copy-start templates that generic markdown/YAML validation cannot understand.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

green='\033[0;32m'
red='\033[0;31m'
nc='\033[0m'

pass() {
  printf "%bPASS%b %s\n" "$green" "$nc" "$1"
  PASS=$((PASS + 1))
}

fail() {
  printf "%bFAIL%b %s\n" "$red" "$nc" "$1"
  FAIL=$((FAIL + 1))
}

require_file() {
  local file="$1"
  if [ -f "$ROOT/$file" ]; then
    pass "$file exists"
  else
    fail "$file exists"
  fi
}

require_text() {
  local file="$1"
  local text="$2"
  local label="$3"

  if grep -Fqi -- "$text" "$ROOT/$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label (missing '$text' in $file)"
  fi
}

require_frontmatter_text() {
  local file="$1"
  local text="$2"
  local label="$3"

  if awk 'BEGIN{n=0} /^---/{n++; next} n==1{print}' "$ROOT/$file" | grep -Fqi -- "$text"; then
    pass "$label"
  else
    fail "$label (missing '$text' in $file frontmatter)"
  fi
}

require_section_text() {
  local file="$1"
  local heading="$2"
  local text="$3"
  local label="$4"
  local section

  section="$(awk -v h="$heading" '$0==h{found=1; next} found && /^## /{exit} found{print}' "$ROOT/$file" 2>/dev/null)"
  if [ -z "$section" ]; then
    fail "$label (missing section '$heading' in $file)"
  elif printf "%s\n" "$section" | grep -Fqi -- "$text"; then
    pass "$label"
  else
    fail "$label (missing '$text' in $file section '$heading')"
  fi
}

forbid_regex() {
  local file="$1"
  local pattern="$2"
  local label="$3"

  if grep -Eq -- "$pattern" "$ROOT/$file" 2>/dev/null; then
    fail "$label (matched '$pattern' in $file)"
  else
    pass "$label"
  fi
}

require_equal() {
  local actual="$1"
  local expected="$2"
  local label="$3"

  if [ "$actual" = "$expected" ]; then
    pass "$label"
  else
    fail "$label (expected '$expected', got '${actual:-<empty>}')"
  fi
}

require_json_equal() {
  local file="$1"
  local expr="$2"
  local expected="$3"
  local label="$4"
  local actual

  if ! actual="$(jq -r "$expr" "$ROOT/$file" 2>/dev/null)"; then
    fail "$label (cannot read $expr from $file)"
    return
  fi

  if [ "$actual" = "$expected" ]; then
    pass "$label"
  else
    fail "$label (expected '$expected', got '$actual')"
  fi
}

echo ""
echo "Slimming guardrails"
echo "==================="

for file in \
  ".claude-plugin/plugin.json" \
  "marketplace.json" \
  ".claude-plugin/marketplace.json" \
  "gemini-extension.json" \
  "qwen-extension.json" \
  ".codebuddy-plugin/marketplace.json" \
  ".mcp.json" \
  "hooks/hooks.json" \
  "CITATION.cff" \
  "CLAUDE.md" \
  "VERSIONS.md"
do
  require_file "$file"
done

if command -v jq >/dev/null 2>&1; then
  plugin_version="$(jq -r '.version' "$ROOT/.claude-plugin/plugin.json" 2>/dev/null)"
  if [ -n "$plugin_version" ] && [ "$plugin_version" != "null" ]; then
    pass "read plugin version: $plugin_version"
    require_json_equal "marketplace.json" ".metadata.version" "$plugin_version" "root marketplace metadata.version matches plugin"
    require_json_equal "marketplace.json" ".plugins[0].version" "$plugin_version" "root marketplace plugin version matches plugin"
    require_json_equal ".claude-plugin/marketplace.json" ".metadata.version" "$plugin_version" "bundle marketplace metadata.version matches plugin"
    require_json_equal ".claude-plugin/marketplace.json" ".plugins[0].version" "$plugin_version" "bundle marketplace plugin version matches plugin"
    require_json_equal "gemini-extension.json" ".version" "$plugin_version" "Gemini extension version matches plugin"
    require_json_equal "qwen-extension.json" ".version" "$plugin_version" "Qwen extension version matches plugin"
    require_json_equal ".codebuddy-plugin/marketplace.json" ".version" "$plugin_version" "CodeBuddy marketplace version matches plugin"
    require_json_equal ".codebuddy-plugin/marketplace.json" ".plugins[0].version" "$plugin_version" "CodeBuddy plugin version matches plugin"
    if jq empty "$ROOT/hooks/hooks.json" "$ROOT/.mcp.json" >/dev/null 2>&1; then
      pass "runtime JSON files parse cleanly"
    else
      fail "runtime JSON files parse cleanly"
    fi
    require_text "CITATION.cff" "version: \"$plugin_version\"" "CITATION.cff version matches plugin"
    require_text "VERSIONS.md" "### v$plugin_version" "VERSIONS.md has current release heading"
    require_text "CLAUDE.md" "Current bundle version: \`$plugin_version\`" "CLAUDE.md references current bundle version"
    require_text "README.md" "version-$plugin_version" "README badge references current release"
    require_text "docs/README.zh.md" "version-$plugin_version" "Chinese README badge references current release"

    versions_date="$(sed -n "s/^### v$plugin_version .* (\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)).*/\1/p" "$ROOT/VERSIONS.md" | head -1)"
    citation_date="$(sed -n 's/^date-released: "\([^"]*\)".*/\1/p' "$ROOT/CITATION.cff" | head -1)"
    require_equal "$citation_date" "$versions_date" "CITATION.cff date-released matches current VERSIONS.md release date"

    while IFS= read -r skill_file; do
      skill_name="$(awk '/^---/{if(++n==2)exit} n && /^name:/{gsub(/name: */, ""); gsub(/["'"'"']/, ""); print; exit}' "$skill_file" | tr -d '\r')"
      skill_version="$(awk '/^---/{if(++n==2)exit} n && /^version:/{gsub(/version: */, ""); gsub(/["'"'"']/, ""); print; exit}' "$skill_file" | tr -d '\r')"
      table_version="$(awk -F'|' -v name="$skill_name" '
        {
          for (i=1; i<=NF; i++) {
            gsub(/^ +| +$/, "", $i)
          }
          if ($2 == name) {
            print $4
            exit
          }
        }
      ' "$ROOT/VERSIONS.md")"
      require_equal "$table_version" "$skill_version" "VERSIONS.md skill table matches $skill_name version"
    done < <(find "$ROOT" -name "SKILL.md" -not -path "$ROOT/docs/*" -not -path "$ROOT/.claude/*" | sort)
  else
    fail "read plugin version from .claude-plugin/plugin.json"
  fi
else
  fail "jq is available for version matrix checks"
fi

if cmp -s "$ROOT/marketplace.json" "$ROOT/.claude-plugin/marketplace.json"; then
  pass "marketplace mirror is byte-identical"
else
  fail "marketplace.json and .claude-plugin/marketplace.json are byte-identical"
fi

echo ""
echo "Discovery alias allowlist"
echo "-------------------------"

require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "robots-txt" "technical SEO keeps robots.txt tag"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "xml-sitemap" "technical SEO keeps sitemap tag"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "canonical-tags" "technical SEO keeps canonical tag"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "hsts" "technical SEO keeps HSTS discovery tag"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "check my robots.txt" "technical SEO keeps robots.txt trigger"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "sitemap issue" "technical SEO keeps sitemap trigger"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "canonical tag issues" "technical SEO keeps canonical trigger"
require_frontmatter_text "optimize/technical-seo-checker/SKILL.md" "HSTS check" "technical SEO keeps HSTS trigger"

require_frontmatter_text "build/geo-content-optimizer/SKILL.md" "ai-seo" "GEO keeps AI SEO tag"
require_frontmatter_text "build/geo-content-optimizer/SKILL.md" "AI optimization" "GEO keeps AI optimization trigger"
require_frontmatter_text "build/geo-content-optimizer/SKILL.md" "generative engine optimization" "GEO keeps expanded GEO trigger"
require_frontmatter_text "build/geo-content-optimizer/SKILL.md" "AI搜索优化" "GEO keeps Chinese AI search trigger"

require_frontmatter_text "build/schema-markup-generator/SKILL.md" "schema-org" "schema skill keeps schema-org tag"
require_frontmatter_text "build/schema-markup-generator/SKILL.md" "schema.org" "schema skill keeps schema.org trigger"

require_frontmatter_text "research/keyword-research/SKILL.md" "Ahrefs alternative" "keyword research keeps Ahrefs alternative alias"
require_frontmatter_text "research/keyword-research/SKILL.md" "Semrush" "keyword research keeps Semrush alias"
require_frontmatter_text "research/keyword-research/SKILL.md" "Google Keyword Planner" "keyword research keeps Keyword Planner alias"
require_frontmatter_text "research/keyword-research/SKILL.md" "Ubersuggest" "keyword research keeps Ubersuggest alias"

require_frontmatter_text "cross-cutting/memory-management/SKILL.md" "remember project context" "memory keeps project context trigger"
require_frontmatter_text "cross-cutting/memory-management/SKILL.md" "remember this for next time" "memory keeps remember trigger"
require_frontmatter_text "cross-cutting/memory-management/SKILL.md" "wiki lint" "memory keeps wiki lint trigger"
require_frontmatter_text "cross-cutting/memory-management/SKILL.md" "what do we know so far" "memory keeps project-knowledge trigger"

echo ""
echo "Template regression matrix"
echo "--------------------------"

require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Crawlability" "robots.txt snapshot" "crawlability template captures robots.txt snapshot"
require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Crawlability" "Recommended robots.txt patch" "crawlability template includes robots.txt patch slot"
require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Crawlability" "sitemap check" "crawlability template includes sitemap check"
require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Crawlability" "only indexable URLs" "crawlability template checks indexable sitemap URLs"
require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Crawlability" "lastmod" "crawlability template checks lastmod freshness"
require_section_text "optimize/technical-seo-checker/references/technical-audit-templates.md" "## Security" "HSTS configured appropriately" "security template includes HSTS"

require_section_text "optimize/on-page-seo-auditor/references/audit-templates.md" "## Images" "filename" "image audit keeps filename evidence"
require_section_text "optimize/on-page-seo-auditor/references/audit-templates.md" "## Images" "lazy" "image audit keeps lazy-load evidence"
require_section_text "optimize/on-page-seo-auditor/references/audit-templates.md" "## CORE-EEAT Quick Scan" "Quick Score**: [X]/17" "CORE-EEAT section denominator remains /17"
require_section_text "optimize/on-page-seo-auditor/references/audit-templates.md" "## Step 11: Generate Audit Summary" "CORE-EEAT quick scan (scaled)" "CORE-EEAT roll-up marks scaled /20 score"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Weighted Scorecard" "Content quality | 25%" "on-page scoring keeps content-quality weight"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Weighted Scorecard" "Image optimization | 10%" "on-page scoring keeps image weight"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Benchmarks" "Keyword Density" "on-page scoring keeps keyword density benchmark"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Benchmarks" "500-1,499" "on-page scoring keeps complete content-length partial band"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Accessibility Overlay" "WCAG 2.2 AA" "on-page scoring keeps WCAG overlay"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Score Calculation" "Section percentage" "on-page scoring keeps normalized section interpretation"
require_section_text "optimize/on-page-seo-auditor/references/scoring-rubric.md" "## Resolution Playbook" "Missing descriptive alt" "on-page scoring keeps image-alt remediation"

require_section_text "monitor/performance-reporter/references/report-output-templates.md" "## Executive Summary" "Domain Authority / CITE" "performance executive summary keeps authority metric"
require_section_text "monitor/performance-reporter/references/report-output-templates.md" "## Executive Summary" "AI Citations" "performance executive summary keeps AI citations metric"
require_section_text "monitor/performance-reporter/references/report-output-templates.md" "## Shared Conventions" "Audience" "performance template keeps audience matrix"
require_text "monitor/performance-reporter/references/report-templates.md" "Data Freshness Requirements" "performance report templates keep data freshness requirements"
require_text "monitor/performance-reporter/references/report-templates.md" "All data sources verified and dated" "performance report templates keep dated-source requirement"
require_text "monitor/performance-reporter/references/report-templates.md" "source and date" "performance report templates keep source/date benchmark requirement"
require_text "monitor/performance-reporter/references/kpi-definitions.md" "Organic CTR | Organic clicks / impressions x 100" "KPI definitions keep organic CTR formula"
require_text "monitor/performance-reporter/references/kpi-definitions.md" "AI citation rate | Cited queries / monitored AI-answer queries x 100" "KPI definitions keep AI citation rate formula"
require_text "monitor/performance-reporter/references/kpi-definitions.md" "Toxic link ratio | Toxic backlinks / total backlinks x 100" "KPI definitions keep toxic link ratio formula"
require_section_text "monitor/performance-reporter/references/kpi-definitions.md" "## Benchmarks" "#1 | 25-35%" "KPI definitions keep CTR position benchmark"
require_section_text "monitor/performance-reporter/references/kpi-definitions.md" "## Benchmarks" "INP | <=200ms" "KPI definitions keep INP threshold"
require_section_text "monitor/performance-reporter/references/kpi-definitions.md" "## Interpretation Notes" "source and date" "KPI definitions keep source/date reporting rule"

require_section_text "build/schema-markup-generator/references/schema-templates.md" "## Article / BlogPosting" "[ISO 8601 publish date-time]" "schema templates use placeholder publish dates"
require_section_text "build/schema-markup-generator/references/schema-templates.md" "## Product" "[price]" "schema templates use placeholder prices"
require_section_text "build/schema-markup-generator/references/schema-templates.md" "## Product" "aggregateRating" "schema templates keep aggregateRating fragment"
require_section_text "build/schema-markup-generator/references/schema-templates.md" "## Product" "Optional review extension" "schema templates keep review extension guidance"
forbid_regex "build/schema-markup-generator/references/schema-templates.md" '"date[A-Za-z]*": "20[0-9]{2}-[0-9]{2}-[0-9]{2}' "schema templates do not include literal date/date-time values"
forbid_regex "build/schema-markup-generator/references/schema-templates.md" '"(price|lowPrice|highPrice)": "?[0-9]' "schema templates do not include literal numeric prices"
forbid_regex "build/schema-markup-generator/references/schema-templates.md" '"(duration|prepTime|cookTime|totalTime)": "P(T)?[0-9]' "schema templates do not include literal fixed durations"
require_section_text "build/schema-markup-generator/references/validation-guide.md" "## Required and Recommended Properties" "FAQPage" "schema validation keeps FAQPage requirements"
require_section_text "build/schema-markup-generator/references/validation-guide.md" "## Required and Recommended Properties" "Product" "schema validation keeps Product requirements"
require_section_text "build/schema-markup-generator/references/validation-guide.md" "## Rich Result Policy Checks" "Content mismatch" "schema validation keeps content-mismatch policy"
require_section_text "build/schema-markup-generator/references/validation-guide.md" "## Testing Workflow" "Post-launch" "schema validation keeps post-launch monitoring"
require_section_text "build/schema-markup-generator/references/validation-guide.md" "## Maintenance Checklist" "dateModified" "schema validation keeps dateModified maintenance rule"

require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "clear evidence of risk" "backlink rubric keeps disavow evidence threshold"
require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "Low-DA sites with real content" "backlink rubric protects legitimate low-DA sites"
require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "Nofollow links" "backlink rubric protects nofollow links"
require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "Manually review flagged domains" "backlink rubric keeps manual review step"
require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "Attempt removal first" "backlink rubric keeps removal-before-disavow order"
require_section_text "monitor/backlink-analyzer/references/link-quality-rubric.md" "## 4. Disavow File Safety Guide" "backup" "backlink rubric keeps disavow backup/rollback"

require_section_text "optimize/internal-linking-optimizer/references/link-architecture-patterns.md" "## Model Selector" "Hub-and-Spoke" "internal linking keeps model selector"
require_section_text "optimize/internal-linking-optimizer/references/link-architecture-patterns.md" "## Migration Between Models" "Preserve existing equity" "internal linking keeps migration equity guard"
require_section_text "optimize/internal-linking-optimizer/references/link-architecture-patterns.md" "## Migration Between Models" "4-8 weeks" "internal linking keeps migration monitoring threshold"

require_section_text "optimize/content-refresher/references/refresh-templates.md" "## Republishing Strategy" "50%+" "content refresher keeps major-update threshold"
require_section_text "optimize/content-refresher/references/refresh-templates.md" "## Republishing Strategy" "20-50%" "content refresher keeps moderate-update threshold"
require_section_text "optimize/content-refresher/references/refresh-templates.md" "## Republishing Strategy" "dateModified" "content refresher keeps schema freshness check"
require_section_text "optimize/content-refresher/references/refresh-templates.md" "## Republishing Strategy" "lastmod" "content refresher keeps sitemap freshness check"

require_text "build/geo-content-optimizer/references/instructions-detail.md" "Source citations" "GEO analysis keeps source citation scoring"
require_text "build/geo-content-optimizer/references/instructions-detail.md" "Content freshness" "GEO analysis keeps content freshness scoring"
require_text "build/geo-content-optimizer/references/quotable-content-examples.md" "source and publication date" "GEO quotability keeps dated-source requirement"
require_text "build/geo-content-optimizer/references/quotable-content-examples.md" "current or explicitly labeled historical" "GEO quotability keeps currentness requirement"
require_text "build/geo-content-optimizer/references/ai-citation-patterns.md" "Updated within 12 months" "GEO citation patterns keep freshness threshold"

require_section_text "build/seo-content-writer/references/title-formulas.md" "## Rewrite Examples" "[X]%" "title examples keep proof claims as placeholders"
require_section_text "build/seo-content-writer/references/content-structure-templates.md" "## Shared Build Rules" "primary keyword early" "content structure keeps first-100-word keyword rule"
require_section_text "build/seo-content-writer/references/content-structure-templates.md" "## Shared Build Rules" "40-60 word definition block" "content structure keeps GEO definition requirement"
require_section_text "build/seo-content-writer/references/content-structure-templates.md" "## Blueprint Matrix" "FAQ rich results" "content structure keeps FAQ rich-result scope"
require_section_text "build/seo-content-writer/references/content-structure-templates.md" "## Implementation Checklist" "affiliate disclosure" "content structure keeps affiliate disclosure reminder"
require_section_text "build/seo-content-writer/references/seo-writing-checklist.md" "## On-Page Checklist" "Snippet targeting" "SEO writing checklist keeps snippet targeting"
require_section_text "build/seo-content-writer/references/seo-writing-checklist.md" "## Example Calibration Card" "CTA" "SEO writing checklist keeps CTA logic"
require_section_text "build/seo-content-writer/references/seo-writing-checklist.md" "## Final Self-Check" "source and date" "SEO writing checklist keeps source/date evidence check"

require_text "research/keyword-research/references/keyword-intent-taxonomy.md" "Verify final intent against the live SERP" "keyword intent taxonomy keeps live-SERP validation"
require_section_text "research/keyword-research/references/keyword-intent-taxonomy.md" "## Funnel Mapping" "Conversion potential" "keyword intent taxonomy keeps conversion expectations"
require_section_text "research/keyword-research/references/keyword-intent-taxonomy.md" "## Mixed Intent Handling" "answer the dominant question first" "keyword intent taxonomy keeps mixed-intent priority rule"

require_text "optimize/internal-linking-optimizer/references/linking-templates.md" "Exact match | 10-20%" "linking templates keep exact-match anchor threshold"
require_text "optimize/internal-linking-optimizer/references/linking-templates.md" "Partial match | 30-40%" "linking templates keep partial-match anchor threshold"
require_text "optimize/internal-linking-optimizer/references/linking-templates.md" "Orphan pages | [X] | 0" "linking templates keep orphan-page zero target"
require_text "optimize/internal-linking-optimizer/references/linking-templates.md" "Over-optimized anchors | [X]% | <10%" "linking templates keep over-optimization threshold"

require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "Sitemap directive" "technical audit example keeps robots sitemap directive"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "Only indexable URLs" "technical audit example keeps sitemap indexability check"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "lastmod accuracy" "technical audit example keeps lastmod check"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "HSTS enabled" "technical audit example keeps HSTS check"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "INP" "technical audit example keeps INP metric"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "Structured Data" "technical audit example keeps structured-data section"
require_text "optimize/technical-seo-checker/references/technical-audit-example.md" "Errors / missing opportunities" "technical audit example keeps structured-data missing-opportunity field"
require_section_text "optimize/technical-seo-checker/references/technical-audit-example.md" "## Reporting Rules" "robots.txt, sitemap, lastmod, HSTS, INP" "technical audit example keeps protected reporting fields"

require_text "research/competitor-analysis/references/battlecard-template.md" "**Confidence**: [High/Medium/Low]" "battlecard keeps confidence field"
require_text "research/competitor-analysis/references/battlecard-template.md" "| Domain authority | [score + source/date] | [score + source/date]" "battlecard keeps source/date on both authority metrics"
require_text "research/competitor-analysis/references/battlecard-template.md" "| AI citation frequency | [High/Med/Low + source/date] | [High/Med/Low + source/date]" "battlecard keeps source/date on both AI citation metrics"

echo ""
echo "Protected runtime contracts"
echo "---------------------------"

require_text "references/skill-contract.md" "Handoff Summary Format" "skill contract keeps handoff schema"
require_text "references/skill-contract.md" "Termination rules for Next Best Skill chains" "skill contract keeps chain termination rules"
require_text "references/skill-contract.md" "Protocol Layer vs Execution Layer" "skill contract keeps layer model"
require_text "references/skill-contract.md" "Gate Verdicts" "skill contract keeps auditor verdict model"

require_text "references/state-model.md" "Sole writer" "state model keeps memory sole-writer rule"
require_text "references/state-model.md" "HOT" "state model keeps HOT tier"
require_text "references/state-model.md" "WARM" "state model keeps WARM tier"
require_text "references/state-model.md" "COLD" "state model keeps COLD tier"
require_text "references/state-model.md" "Project isolation" "state model keeps project isolation"

require_text "hooks/hooks.json" "SessionStart" "hooks keep SessionStart behavior"
require_text "hooks/hooks.json" "PostToolUse" "hooks keep PostToolUse behavior"
require_text "hooks/hooks.json" "Stop" "hooks keep Stop guard"
require_text "hooks/hooks.json" "stop_hook_active" "hooks guard Stop re-entry"
require_text "hooks/hooks.json" "Respond only with JSON" "hooks specify Stop response schema"
require_text "hooks/hooks.json" "\\\"ok\\\": true" "hooks keep Stop allow-only response"
require_text "hooks/hooks.json" "Stop hook never initiates memory writes" "hooks document Stop no-write contract"
forbid_regex "hooks/hooks.json" "Save these results for future sessions\\?|Wiki wrap-up|Auditor archiving" "hooks forbid legacy interactive Stop prompts"
require_text "hooks/hooks.json" "class: auditor-output" "hooks keep auditor archive guard"

require_text "cross-cutting/memory-management/SKILL.md" "Sole writer of wiki" "memory-management keeps sole-writer contract"
require_text "cross-cutting/memory-management/SKILL.md" "HOT/WARM/COLD" "memory-management keeps memory lifecycle"
require_text "cross-cutting/memory-management/SKILL.md" "Auditor handoff archiving" "memory-management keeps auditor archive contract"
require_text "cross-cutting/memory-management/SKILL.md" "PostToolUse" "memory-management keeps hook delegation"

require_text "cross-cutting/entity-optimizer/SKILL.md" "Profile schema" "entity-optimizer keeps canonical profile schema contract"
require_text "cross-cutting/entity-optimizer/SKILL.md" "entity-geo-handoff-schema" "entity-optimizer keeps downstream schema reference"
require_text "cross-cutting/entity-optimizer/SKILL.md" "Next Best Skill" "entity-optimizer keeps handoff contract"

current_lines="$(find "$ROOT" \
  -path "$ROOT/.git" -prune -o \
  -path "$ROOT/.claude" -prune -o \
  -path "$ROOT/.docs" -prune -o \
  -type f \( -name '*.md' -o -name '*.json' -o -name '*.yml' -o -name '*.yaml' -o -name '*.sh' -o -name '*.cff' \) \
  -print0 | xargs -0 wc -l | tail -1 | awk '{print $1}')"

echo ""
echo "Current counted lines: ${current_lines:-unknown}"
echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
