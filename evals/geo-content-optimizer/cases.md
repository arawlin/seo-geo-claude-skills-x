# geo-content-optimizer Eval Cases

Simulated seed cases for GEO citation readiness. They are regression prompts, not production evidence.

```yaml
{id: geo-content-optimizer-sim-001, type: eval-case, status: simulated, target_skill: geo-content-optimizer, scenario: "User asks to improve AI citation likelihood but provides undated source claims.", input_summary: "Market growth and expert claims have no publication dates.", expected_behavior: ["Flag source freshness.", "Recommend dated sources or historical labeling.", "Avoid claiming confirmed AI citations.", "Recommend /seo:geo-drift-check after publish."], failure_modes: ["Treats undated claims as current.", "Claims citation likelihood without evidence.", "Omits date remediation."], evolution_use: "Use when changing freshness, evidence, or GEO citation language."}
```

```yaml
{id: geo-content-optimizer-sim-002, type: eval-case, status: simulated, target_skill: geo-content-optimizer, scenario: "Brand or product entity is ambiguous.", input_summary: "Atlas CRM lacks canonical site, sameAs links, or company disambiguation.", expected_behavior: ["Flag entity ambiguity.", "Recommend entity-optimizer when canonical identity is missing.", "Separate structure advice from entity trust gaps."], failure_modes: ["Assumes the entity.", "Skips disambiguation.", "Gives guidance for the wrong entity."], evolution_use: "Use when changing entity handoff or Next Best Skill routing."}
```

```yaml
{id: geo-content-optimizer-sim-003, type: eval-case, status: simulated, target_skill: geo-content-optimizer, scenario: "User asks for guaranteed ChatGPT or AI Overview citations.", input_summary: "Rewrite this page so ChatGPT will cite us.", expected_behavior: ["Reject guarantee framing.", "Offer citation-readiness improvements.", "Name monitoring or /seo:geo-drift-check."], failure_modes: ["Promises citations.", "Treats GEO Score as confirmed behavior.", "Fails to recommend measurement."], evolution_use: "Use when changing GEO promise language."}
```

```yaml
{id: geo-content-optimizer-sim-004, type: eval-case, status: simulated, target_skill: geo-content-optimizer, scenario: "Strong article lacks quotable answer-ready structure.", input_summary: "Evidence is strong but no definition block, comparison table, or concise answer.", expected_behavior: ["Recommend answer-ready structures with source support.", "Avoid generic filler.", "Tie blocks to sources or sections."], failure_modes: ["Adds unsupported template sections.", "Weakens source traceability.", "Ignores article intent."], evolution_use: "Use when changing GEO structure recommendations."}
```
