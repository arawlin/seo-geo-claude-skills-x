# Baidu Keyword Research Connector Mapping

This document is also available in [Chinese](./baidu-keyword-research-connector-mapping-zh.md).

## Purpose

This document defines a Baidu-focused connector mapping for
[keyword-research](../research/keyword-research/SKILL.md). It keeps the skill's
existing eight-phase workflow and placeholder-based connector model, but swaps
global-default data sources for Chinese-market equivalents.

Use this mapping when your site targets Chinese-language search demand and
Baidu is the primary search engine. Do not use it as-is for Google-first or
global SEO programs.

## Design Goals

- Keep the existing `~~placeholder` model from [CONNECTORS.md](../CONNECTORS.md)
  unchanged.
- Support Tier 1 manual workflows immediately and Tier 2 or Tier 3 automation
  later.
- Replace exact global metrics with Baidu-appropriate demand, competition, and
  ranking signals.
- Make every reported metric traceable to an explicit source type.

## Scope

This mapping is designed for:

- Chinese-language editorial planning
- Baidu-led keyword research
- New or low-authority sites that need practical prioritization
- Hybrid workflows that combine official platform data, third-party tools, and
  manual SERP review

This mapping does not assume that Ahrefs, Semrush, or Google Search Console are
present.

## Placeholder Mapping

Map the generic connector categories to Baidu-market sources as follows.

| Skill Placeholder | Recommended Baidu-Market Sources | Primary Use |
| --- | --- | --- |
| `~~SEO tool` | Baidu Index, 5118, Aizhan, Chinaz | Demand scoring, expansion, related terms, trend inputs |
| `~~search console` | Baidu Search Resource Platform, Baidu Tongji, server logs | Query-to-page performance, indexation, click and impression evidence |
| `~~competitive intel` | 5118, Aizhan, manual Baidu top-10 sampling | Competitor coverage, ranking pattern review, overlap analysis |
| `~~analytics` | Baidu Tongji, first-party analytics, server logs | Landing page traffic context and conversion support |
| `~~AI monitor` | Manual tracking for Baidu AI Search, Doubao, Kimi, Yuanbao | GEO observations when AI citation monitoring is required |

## Source Priority Rules

Use sources in this order when the same metric can be collected from more than
one place.

### 1. Official Platform Data

- Baidu Search Resource Platform
- Baidu Tongji
- First-party server logs

Use official or first-party data first for your own site's indexed queries,
landing pages, and click behavior.

### 2. Third-Party Chinese SEO Platforms

- 5118
- Aizhan
- Chinaz
- Baidu Index

Use these platforms for keyword discovery, related queries, demand estimation,
and competitor coverage.

### 3. Manual SERP Sampling

Use manual Baidu desktop and mobile result sampling when no stable API exists or
when platform outputs conflict.

## Metric Translation Layer

The original skill expects global SEO metrics such as search volume, keyword
difficulty, SERP analysis, current rankings, and competitor overlap. In a
Baidu-first workflow, reinterpret them using the definitions below.

### Search Demand Strength

Use this in place of exact historical search volume.

| Field | Type | Definition |
| --- | --- | --- |
| `demand_score` | 0-100 number | Normalized demand score derived from Baidu Index and third-party tools |
| `demand_band` | low, medium, high | Demand bucket when exact precision is not defensible |
| `trend_30d` | rising, flat, falling | Recent 30-day movement |
| `trend_90d` | rising, flat, falling | Recent 90-day movement |
| `seasonality_flag` | boolean | Whether the term shows seasonal behavior |

Recommended source mix:

- Baidu Index trend data
- 5118 demand or heat indicators
- Aizhan keyword demand signals

If sources disagree, output a normalized score or band instead of a fake exact
monthly volume.

### Competition Difficulty

Use this in place of a vendor-native keyword difficulty metric.

| Field | Type | Definition |
| --- | --- | --- |
| `difficulty_score` | 1-100 number | Baidu competition score |
| `difficulty_band` | low, medium, high | Difficulty bucket |
| `authority_pressure` | 0-100 number | Presence of strong domains on page one |
| `baijiahao_ratio` | percent | Share of Baijiahao results in sampled rankings |
| `official_site_ratio` | percent | Share of official or large-platform results |
| `fresh_content_ratio` | percent | Share of results updated or published within 180 days |

Suggested scoring model:

```text
difficulty_score =
  0.25 * authority_pressure +
  0.20 * official_site_ratio +
  0.20 * baijiahao_ratio +
  0.15 * fresh_content_ratio +
  0.10 * competitor_coverage_pressure +
  0.10 * commercial_serp_density
```

Suggested interpretation:

- 1-39: low difficulty
- 40-69: medium difficulty
- 70-100: high difficulty

### SERP Structure Reporting

Use this in place of generic SERP analysis.

| Field | Type | Definition |
| --- | --- | --- |
| `top10_result_types` | list | Distribution of result formats in the top 10 |
| `forum_ratio` | percent | Share of forums or Q&A properties |
| `video_ratio` | percent | Share of video results |
| `baike_presence` | boolean | Whether Baike appears in prominent positions |
| `baijiahao_presence` | boolean | Whether Baijiahao appears in prominent positions |
| `answer_box_presence` | boolean | Whether direct-answer modules are visible |
| `ecosystem_bias` | low, medium, high | Strength of Baidu ecosystem preference |

Recommended result type taxonomy:

- official site
- media site
- Baijiahao
- Baike
- Q&A
- forum
- video
- tool page
- aggregator
- download page

### Site Query Performance

Use this in place of Search Console ranking metrics.

| Field | Type | Definition |
| --- | --- | --- |
| `query` | string | Search term |
| `landing_page` | URL | Landing page receiving the query |
| `impressions` | number | Observed exposure count |
| `clicks` | number | Observed click count |
| `ctr` | percent | Click-through rate |
| `avg_position_band` | range | Position bucket such as 1-3, 4-10, 11-20, 20+ |
| `indexed_flag` | boolean | Whether the page is indexed |

Use Baidu Search Resource Platform first. If the data is incomplete, supplement
it with Baidu Tongji and server log evidence.

### Competitor Keyword Overlap

Use this in place of a vendor-specific overlap report.

| Field | Type | Definition |
| --- | --- | --- |
| `competitor_domain` | string | Competitor site |
| `overlapping_keywords_count` | number | Shared tracked keywords |
| `competitor_only_keywords` | number | Keywords found only on the competitor |
| `shared_high_intent_keywords` | number | Shared commercial or transactional terms |
| `weak_gap_keywords` | list | Missed keywords with low or medium competition |

Recommended sources:

- 5118 competitor keyword exports
- Aizhan competitor term reports
- manual top-20 Baidu ranking collection for key clusters

## Minimum Data Contract For Automation

If you later build a Baidu-focused MCP service, expose at least these five
operations.

### 1. Keyword Metrics

Input:

- seed term
- market or geography
- language
- device type

Output:

- `query`
- `demand_score`
- `demand_band`
- `difficulty_score`
- `difficulty_band`
- `trend_30d`
- `trend_90d`
- `source_list`

### 2. Keyword Expansion

Input:

- seed term
- max results
- include question terms flag

Output:

- `keyword`
- `relation_type`
- `demand_score`
- `source`
- `geo_potential_flag`

### 3. SERP Snapshot

Input:

- query
- market or geography
- device
- top-N value

Output:

- `rank`
- `title`
- `url`
- `domain`
- `result_type`
- `ecosystem_flag`
- `freshness_hint`
- `snippet_presence`

### 4. Site Query Data

Input:

- site
- date range
- query or page filter

Output:

- `query`
- `landing_page`
- `impressions`
- `clicks`
- `ctr`
- `avg_position_band`
- `indexed_flag`

### 5. Competitor Overlap

Input:

- target site
- competitor sites
- topic scope

Output:

- `keyword`
- `target_has_page`
- `competitor_count`
- `top_competitor`
- `estimated_gap_value`
- `difficulty_band`

## Output Rules For Keyword Research Reports

When using this mapping, present data in a Baidu-appropriate format.

### Demand

Prefer:

- `Demand score 78/100, rising over 90 days`

Avoid:

- fabricated exact monthly search volume when only trend data exists

### Difficulty

Prefer:

- `Baidu competition score 42/100; 3 major domains and 2 Baijiahao results in the top 10`

Avoid:

- copying an overseas vendor's KD label without explaining the local scoring basis

### SERP Structure

Prefer:

- `Top 10 mix: 2 official sites, 3 media results, 2 Baijiahao results, 3 forum or Q&A results`

### Opportunity Formula

Retain the skill's opportunity logic, but adapt the inputs.

```text
Opportunity = (Demand Score × Intent Value) / Difficulty Score
```

Recommended intent values:

- informational = 1
- navigational = 1
- commercial = 2
- transactional = 3

## Required Disclosures In Reports

Every Baidu-focused keyword research report should state all of the following:

- whether the demand metric is exact, estimated, or normalized
- whether the difficulty score is a custom Baidu competition model
- which sources were official, third-party, or manual
- the SERP sampling date
- whether the sample was desktop or mobile
- whether the geography was national or province-specific

Without these notes, a report can look more precise than the underlying data
actually supports.

## Recommended Rollout Path

### Phase 1: Manual Workflow

Start with manual collection:

- Baidu Index screenshots or exports
- 5118 or Aizhan keyword exports
- manual Baidu top-10 sampling
- Baidu Search Resource Platform screenshots

### Phase 2: File-Driven Aggregation

Normalize exported CSV files into the fields defined in this document.

### Phase 3: MCP Automation

Wrap the normalized data layer behind `~~SEO tool` and `~~search console`
implementations for automated use.

## Summary

This mapping does not replace the
[keyword-research](../research/keyword-research/SKILL.md) workflow. It adapts
the skill to a Baidu-first operating model by remapping connector categories to
Chinese-market sources and by redefining demand, difficulty, SERP, ranking, and
overlap metrics in a form that is defensible for Chinese search.
