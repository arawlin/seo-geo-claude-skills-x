# content-quality-auditor Eval Cases

Simulated seed cases for CORE-EEAT veto behavior, cap arithmetic, `BLOCKED`, handoff, and artifact gates.

```yaml
{id: content-quality-auditor-sim-001, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Affiliate links appear before disclosure.", input_summary: "Best hosting article has comparison tables and affiliate buttons; disclosure is in footer.", expected_behavior: ["Flag the relevant veto.", "Apply cap arithmetic.", "Explain the issue clearly."], failure_modes: ["Treats disclosure as minor.", "Averages away the veto.", "Omits cap_applied or final_overall_score."], evolution_use: "Use for affiliate disclosure, veto handling, or score presentation changes."}
```

```yaml
{id: content-quality-auditor-sim-002, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "User asks for a full score without page content or URL.", input_summary: "Score my Kubernetes autoscaling article; no article is provided.", expected_behavior: ["Return NEEDS_INPUT or BLOCKED.", "State needed evidence.", "Do not fabricate scores."], failure_modes: ["Guesses from topic.", "Emits full artifact without evidence.", "Marks audit complete despite missing data."], evolution_use: "Use when changing insufficient-evidence handling."}
```

```yaml
{id: content-quality-auditor-sim-003, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Raw score passes but one veto fails.", input_summary: "Expertise and structure are strong, but a veto item fails.", expected_behavior: ["Keep raw and final capped scores separate.", "Use math.floor rounding.", "Set cap_applied: true."], failure_modes: ["Rounds 77.5 to 78.", "Caps only a dimension.", "Drops raw_overall_score."], evolution_use: "Use when changing scoring, caps, or handoff fields."}
```

```yaml
{id: content-quality-auditor-sim-004, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Audit has fixable issues and downstream work.", input_summary: "Outdated stats, missing credentials, and weak source freshness.", expected_behavior: ["Emit DONE_WITH_CONCERNS or DONE with priorities.", "Preserve open loops.", "Recommend the right downstream skill."], failure_modes: ["Drops actionable handoff.", "Uses internal jargon.", "Creates recursive routing."], evolution_use: "Use when changing auditor handoff or routing."}
```

```yaml
{id: content-quality-auditor-sim-005, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Title promises definitive medical proof but body has generic opinions.", input_summary: "'Best Diabetes Supplements Proven by Doctors' has no named doctors, citations, or proof.", expected_behavior: ["Flag C01 or equivalent title-mismatch veto.", "Treat as veto-level publish risk.", "Preserve required remediation."], failure_modes: ["Only rewrites title.", "Treats as low-priority CTR issue.", "Scores as publish-ready."], evolution_use: "Use when changing title accuracy, claims substantiation, or veto severity."}
```

```yaml
{id: content-quality-auditor-sim-006, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Article cites conflicting current statistics for one claim.", input_summary: "Market is listed as $4B and $14B in different sections.", expected_behavior: ["Flag R10 or equivalent contradictory-data veto.", "Require source/date reconciliation.", "Do not average the contradiction away."], failure_modes: ["Marks as minor fact-check note.", "Keeps high final score.", "Fails to ask for source/date evidence."], evolution_use: "Use when changing source reconciliation, evidence handling, or data freshness."}
```

```yaml
{id: content-quality-auditor-sim-007, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Two or more veto items fail.", input_summary: "YMYL affiliate review lacks disclosure, has contradictory safety data, and unsupported expert claims.", expected_behavior: ["Set BLOCKED by runbook rules.", "Do not emit final_overall_score when BLOCKED.", "List vetoes and unblock actions."], failure_modes: ["Applies single-veto cap only.", "Publishes final score despite BLOCKED.", "Hides a veto in general recommendations."], evolution_use: "Use when changing multi-veto handling, BLOCKED status, or score artifacts."}
```

```yaml
{id: content-quality-auditor-sim-008, type: eval-case, status: simulated, target_skill: content-quality-auditor, scenario: "Audit output misses required scoring artifact fields.", input_summary: "Narrative recommendations omit cap_applied, raw_overall_score, and final_overall_score while claiming DONE.", expected_behavior: ["Fail artifact gate or return DONE_WITH_CONCERNS.", "Require score fields when allowed.", "Explain blocked, capped, or publish-ready state."], failure_modes: ["Accepts narrative-only output.", "Claims DONE without score artifacts.", "Does not distinguish capped, blocked, and uncapped states."], evolution_use: "Use when changing auditor output, artifact gates, or score field requirements."}
```
