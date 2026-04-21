# 5118 API To MCP Tool Mapping

This document is also available in [Chinese](./5118-mcp-tool-mapping-zh.md).

## Purpose

This document defines a practical mapping from confirmed 5118 official APIs to
Model Context Protocol tools for Chinese-market SEO workflows.

It is designed to support the `~~SEO tool` placeholder used by
[CONNECTORS.md](../CONNECTORS.md) and the Baidu-first workflow described in
[baidu-keyword-research-connector-mapping.md](./baidu-keyword-research-connector-mapping.md).

## Current Status

Based on currently accessible public pages:

- 5118 exposes a public API marketplace with production API endpoints.
- 5118 advertises an AI skill package that can be imported into AI agents such
  as OpenClaw, Gemini, and Claude.
- A public 5118 official MCP server repository was not confirmed during this
  review.
- A public third-party 5118 MCP server with clear adoption signals was also not
  confirmed during this review.

This means the recommended implementation path is to wrap the official 5118 API
endpoints behind a thin MCP proxy or adapter.

## Confirmed Official 5118 Capabilities

The following API capabilities were confirmed from the 5118 API marketplace.

| Capability | 5118 API | Confirmed Endpoint |
| --- | --- | --- |
| Long-tail keyword expansion | Massive Long-tail Keyword Mining API v2 | `http://apis.5118.com/keyword/word/v2` |
| Batch keyword volume and index lookup | Keyword Search Volume Info API v2 | `http://apis.5118.com/keywordparam/v2` |
| PC keyword ranking lookup | PC Rank Query API | `http://apis.5118.com/morerank/baidupc` |
| PC site ranking keywords export | PC Site Ranking Keywords Export API v2 | `http://apis.5118.com/keyword/pc/v2` |
| Search suggestion mining | Suggestion Terms Mining API | `http://apis.5118.com/suggest/list` |

Additional related APIs are visible in the API marketplace, including whole-site
ranking exports, mobile ranking exports, top-50 ranking snapshots, bidding
queries, and vertical long-tail sources.

## Design Principles

- Expose only task-shaped MCP tools, not raw endpoint names.
- Preserve 5118 field names in the raw payload where useful, but normalize the
  top-level MCP response fields for downstream skills.
- Mark each tool as `official-api-backed` rather than `official-mcp-backed`.
- Support pagination and asynchronous polling where 5118 APIs use task IDs.

## Recommended MCP Tool Set

These five tools cover the minimum viable integration for keyword research and
competitive analysis.

### 1. `get_keyword_expansion_5118`

Purpose:

- Expand a seed term into long-tail keyword opportunities.

5118 source:

- Massive Long-tail Keyword Mining API v2
- Endpoint: `http://apis.5118.com/keyword/word/v2`

Suggested MCP input:

```json
{
  "keyword": "新手怎么买比特币",
  "pageIndex": 1,
  "pageSize": 100,
  "sortField": 4,
  "sortType": "desc",
  "filter": 2,
  "filterDate": "2026-04-20"
}
```

Suggested MCP output:

```json
{
  "source": "5118",
  "sourceType": "official-api-backed",
  "query": "新手怎么买比特币",
  "pageIndex": 1,
  "pageSize": 100,
  "total": 52,
  "keywords": [
    {
      "keyword": "新手怎么买比特币最安全",
      "index": 1063,
      "mobileIndex": 919,
      "pcSearchVolume": 240,
      "mobileSearchVolume": 1433,
      "competitionLevel": 1,
      "bidCompanyCount": 185,
      "longKeywordCount": 6045520,
      "semPrice": "0.35~4.57"
    }
  ]
}
```

Key downstream use:

- keyword discovery
- long-tail clustering
- commercial opportunity scoring

### 2. `get_keyword_metrics_5118`

Purpose:

- Fetch volume, index, competition, and demand signals for up to 50 keywords.

5118 source:

- Keyword Search Volume Info API v2
- Endpoint: `http://apis.5118.com/keywordparam/v2`

Implementation note:

- This API uses a task-based pattern. Submit a job, then poll by `taskid`.

Suggested MCP input:

```json
{
  "keywords": [
    "比特币怎么买",
    "新手买usdt",
    "加密货币入门"
  ]
}
```

Suggested MCP output:

```json
{
  "source": "5118",
  "sourceType": "official-api-backed",
  "status": "completed",
  "taskId": 123456,
  "items": [
    {
      "keyword": "比特币怎么买",
      "index": 330,
      "mobileIndex": 212,
      "haosouIndex": 351,
      "douyinIndex": 564,
      "pcSearchVolume": 258,
      "mobileSearchVolume": 372,
      "longKeywordCount": 48718,
      "competitionLevel": 1,
      "bidCompanyCount": 276,
      "bidPrice": 9.3,
      "showReason": "高频热搜词"
    }
  ]
}
```

Key downstream use:

- demand normalization
- difficulty estimation
- opportunity score calculation

### 3. `get_suggest_terms_5118`

Purpose:

- Retrieve suggestion and autocomplete terms from a specified platform.

5118 source:

- Suggestion Terms Mining API
- Endpoint: `http://apis.5118.com/suggest/list`

Suggested MCP input:

```json
{
  "word": "国庆假期",
  "platform": "baidu"
}
```

Suggested MCP output:

```json
{
  "source": "5118",
  "sourceType": "official-api-backed",
  "word": "国庆假期",
  "platform": "baidu",
  "suggestions": [
    {
      "promoteWord": "国庆假期去哪玩",
      "addedAt": "2020-09-24T11:29:10.097"
    }
  ]
}
```

Key downstream use:

- question discovery
- intent expansion
- GEO-friendly phrasing detection

### 4. `get_keyword_rank_snapshot_5118`

Purpose:

- Get PC ranking results for a target site and keyword set.

5118 source:

- PC Rank Query API
- Endpoint: `http://apis.5118.com/morerank/baidupc`

Implementation note:

- This API is also task-based. Submit the task, then poll the result.

Suggested MCP input:

```json
{
  "url": "https://example.com",
  "keywords": [
    "电脑",
    "笔记本电脑"
  ],
  "checkRow": 50
}
```

Suggested MCP output:

```json
{
  "source": "5118",
  "sourceType": "official-api-backed",
  "status": "completed",
  "taskId": 234567,
  "results": [
    {
      "keyword": "电脑",
      "searchEngine": "baidupc",
      "ip": "114.102.34.101",
      "area": "湖北省潜江市",
      "network": "电信",
      "ranks": [
        {
          "siteUrl": "www.example.com",
          "rank": 9,
          "pageTitle": "示例标题",
          "pageUrl": "https://www.example.com/",
          "top100": 18384,
          "siteWeight": "4"
        }
      ]
    }
  ]
}
```

Key downstream use:

- target-site ranking checks
- quick win validation
- competitor positioning review

### 5. `get_site_ranking_keywords_5118`

Purpose:

- Export a site's PC ranking keywords at scale.

5118 source:

- PC Site Ranking Keywords Export API v2
- Endpoint: `http://apis.5118.com/keyword/pc/v2`

Suggested MCP input:

```json
{
  "url": "https://example.com",
  "pageIndex": 1
}
```

Suggested MCP output:

```json
{
  "source": "5118",
  "sourceType": "official-api-backed",
  "url": "https://example.com",
  "pageIndex": 1,
  "pageSize": 500,
  "total": 590511,
  "keywords": [
    {
      "keyword": "水质分析仪表",
      "rank": 1,
      "pageTitle": "示例标题",
      "index": 0,
      "longKeywordCount": 696,
      "bidCompanyCount": 317
    }
  ]
}
```

Key downstream use:

- competitor overlap
- site-level content gap analysis
- ranking inventory creation

## Optional Extension Tools

If you need a fuller Chinese-market SEO MCP, add these later.

- `get_site_ranking_keywords_mobile_5118`
- `get_domain_ranking_keywords_pc_5118`
- `get_top50_serp_sites_5118`
- `get_bidding_keywords_by_domain_5118`
- `get_bidding_domains_by_keyword_5118`

## Authentication And Transport Guidance

The public pages confirm API endpoints and online debugging pages, but this
document does not assume a specific auth header name until you verify it in your
own purchased account or API credential panel.

Recommended MCP design:

- use one MCP server named `5118-seo-adapter`
- keep credentials in environment variables, not prompt text
- expose task submission and polling as one logical MCP tool where possible
- return raw response fragments under a `raw` key for debugging

## Error Handling Guidance

Because some 5118 APIs are task-based and may take 1 to 10 minutes to complete,
the MCP wrapper should normalize API behavior into these states:

- `queued`
- `running`
- `completed`
- `failed`

Recommended wrapper behavior:

- submit task
- poll at a controlled interval
- return partial state if still running
- allow a `waitForCompletion` boolean for synchronous callers

## Mapping To Repository Placeholders

Within this repository, a 5118-backed MCP server would map as follows.

| Placeholder | Recommended Tool Set |
| --- | --- |
| `~~SEO tool` | `get_keyword_expansion_5118`, `get_keyword_metrics_5118`, `get_suggest_terms_5118`, `get_keyword_rank_snapshot_5118`, `get_site_ranking_keywords_5118` |
| `~~competitive intel` | `get_site_ranking_keywords_5118`, optional domain-wide ranking exports, optional top-50 ranking snapshots |

## Recommended Implementation Order

1. Implement `get_keyword_metrics_5118`.
2. Implement `get_keyword_expansion_5118`.
3. Implement `get_suggest_terms_5118`.
4. Implement `get_site_ranking_keywords_5118`.
5. Implement `get_keyword_rank_snapshot_5118`.

This order gives you keyword discovery and metric coverage first, then site and
competitor coverage.

## Summary

5118 already provides enough official API coverage to act as the primary
Chinese-market `~~SEO tool` for keyword research. The missing layer is not data
availability but MCP packaging. The most practical path is to wrap the official
5118 APIs behind a dedicated MCP adapter rather than waiting for a public 5118
official MCP server.
