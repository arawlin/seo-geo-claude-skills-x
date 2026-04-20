# Connectors

This document is also available in [Chinese](./CONNECTORS-zh.md).

> Skills use `~~category` placeholders instead of specific tool names. Replace
> each placeholder with whichever tool your organization uses.

Use
[docs/baidu-keyword-research-connector-mapping.md](./docs/baidu-keyword-research-connector-mapping.md)
when your keyword research workflow is Baidu-first and Chinese-market specific.

In this workspace, a local SERP MCP server is already configured in
`.vscode/mcp.json` as `search-serp-adapter`. Prefer it over manual Baidu SERP
sampling when keyword research or SERP analysis needs live result data.

## Tool Categories

| Category | Placeholder | Example Tools | Included Server(s) |
| --- | --- | --- | --- |
| SEO Platform | `~~SEO tool` | Ahrefs, Semrush, Moz, SISTRIX, SE Ranking, Baidu Index, 5118, Aizhan, Chinaz | Ahrefs, Semrush, SE Ranking, SISTRIX |
| Analytics | `~~analytics` | Google Analytics, Adobe Analytics, Plausible, Matomo, Baidu Tongji | Amplitude |
| Search Console | `~~search console` | Google Search Console, Bing Webmaster Tools, Baidu Search Resource Platform | — |
| AI Visibility | `~~AI monitor` | Otterly, Profound, Scrunch AI | — |
| Web Crawler | `~~web crawler` | Screaming Frog, Sitebulb, DeepCrawl, Lumar | — |
| Link Database | `~~link database` | Ahrefs, Majestic, Moz Link Explorer | Ahrefs, Semrush |
| Competitive Intel | `~~competitive intel` | SimilarWeb, SpyFu, Semrush, 5118, Aizhan | SimilarWeb, Semrush |
| CDN / Hosting | `~~CDN` | Cloudflare, Fastly, Vercel, Netlify | Cloudflare, Vercel |
| Page Speed | `~~page speed tool` | Google PageSpeed Insights, WebPageTest, GTmetrix, Lighthouse CLI, Chrome UX Report (CrUX) API | — (no default MCP; see "Page speed data without an MCP" below) |
| Schema Validator | `~~schema validator` | Google Rich Results Test, Schema.org Validator | — |
| Knowledge Graph | `~~knowledge graph` | Google Knowledge Graph API, Wikidata SPARQL, DBpedia, CrunchBase | — |
| Brand Monitor | `~~brand monitor` | Google Alerts, Brand24, Mention.com, Brandwatch | — |
| CRM / Marketing | `~~CRM` | HubSpot, Salesforce, Marketo | HubSpot |
| Content Platform | `~~content platform` | Notion, WordPress, Medium, Ghost, Substack | Notion |
| Communication | `~~team chat` | Slack, Microsoft Teams, Discord | Slack |
| Reporting | `~~reporting` | Google Data Studio, Tableau, Power BI | — |
| Content Management | `~~CMS` | WordPress, Webflow, Contentful, Sanity | Webflow, Sanity, Contentful |

## Included MCP Servers

Pre-configured in `.mcp.json` with HTTP transport and no local executable
setup required:

| Server | What it provides |
| --- | --- |
| Ahrefs | Keyword data, backlink profiles, site audits |
| Semrush | Keyword research, domain analytics, backlinks, SERP data |
| SE Ranking | Keyword tracking, site audits, competitive data |
| SISTRIX | Visibility Index, rankings, search volume |
| SimilarWeb | Traffic estimates, competitive intelligence |
| Cloudflare | DNS management, cache purging, Workers, performance |
| Vercel | Project deployments, domain management, logs |
| HubSpot | CRM contacts, marketing analytics |
| Amplitude | Product analytics, user behavior data |
| Notion | Project documentation, content calendars |
| Webflow | Site management, CMS content, design canvas |
| Sanity | Structured content, schema management, media |
| Contentful | Content lifecycle management, assets, environments |
| Slack | Team notifications, alert delivery |

To add more servers, edit `.mcp.json` at the project root:

```json
{
  "mcpServers": {
    "google-search-console": {
      "type": "http",
      "url": "https://your-search-console-mcp-endpoint"
    },
    "baidu-search-resource-platform": {
      "type": "http",
      "url": "https://your-baidu-search-mcp-endpoint"
    }
  }
}
```

## Regional Connector Profiles

You do not need to use the same tool stack in every market. The placeholders
are intentionally generic so the same skill can operate against different
regional data sources.

### Global-default Profile

- `~~SEO tool` -> Ahrefs, Semrush, SE Ranking, or SISTRIX
- `~~search console` -> Google Search Console or Bing Webmaster Tools
- `~~analytics` -> Google Analytics, Adobe Analytics, Plausible, or Matomo
- `~~competitive intel` -> SimilarWeb, SpyFu, Semrush

### Chinese-market Profile

- `~~SEO tool` -> Baidu Index, 5118, Aizhan, Chinaz
- `~~search console` -> Baidu Search Resource Platform, Baidu Tongji, server logs
- `~~analytics` -> Baidu Tongji, first-party analytics, server logs
- `~~competitive intel` -> `search-serp-adapter`, 5118, Aizhan

For a full Baidu-first field mapping for keyword research, see
[docs/baidu-keyword-research-connector-mapping.md](./docs/baidu-keyword-research-connector-mapping.md).

## Workspace-local MCP Servers

Some teams keep market-specific MCP connectors in workspace settings rather than
the root `.mcp.json`. In this repository, the current local setup includes:

| Server | Config Location | Purpose |
| --- | --- | --- |
| `search-serp-adapter` | `.vscode/mcp.json` | Local SERP retrieval for Baidu or other configured search providers |

## Page Speed Data Without An MCP

`~~page speed tool` has no default MCP server because no vendor currently
exposes one in a stable way. Technical SEO audits still rely on Core Web Vitals
data, so here are the supported manual paths.

### Option 1: PageSpeed Insights Export

- Run `https://pagespeed.web.dev/report?url=<your-url>` in a browser.
- Copy the JSON view or a screenshot.
- Paste it into the conversation when a skill asks for performance data.

### Option 2: PSI API

- Endpoint: `https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed?url=<url>&strategy=mobile&key=<API_KEY>`
- Get a free API key from Google Cloud Console.
- Paste the `lighthouseResult.audits` section when prompted.

### Option 3: Lighthouse CLI

- Run `npx lighthouse <url> --output json --output-path=./lh.json`.
- Paste relevant sections or summarize LCP, INP, CLS, and TBT scores.

### Option 4: Chrome UX Report

- Endpoint: `https://chromeuxreport.googleapis.com/v1/records:queryRecord`
- This requires an API key.
- It provides field data from real users rather than lab data.
- Use it for site-level LCP, INP, and CLS summaries.

### Option 5: `~~web crawler` Integration

- Screaming Frog or Sitebulb can call the PageSpeed Insights API during a crawl.
- Export CSV with per-URL Core Web Vitals.
- Paste the CSV when running bulk technical audits.

## How Placeholders Work

A skill might say:

```text
Pull keyword rankings from ~~SEO tool and cross-reference with ~~search console impressions.
```

If your organization uses Ahrefs and Google Search Console, read it as:

```text
Pull keyword rankings from Ahrefs and cross-reference with Google Search Console impressions.
```

If your organization works in the Chinese market, you might instead read it as:

```text
Pull keyword demand from Baidu Index or 5118, validate live SERP structure through search-serp-adapter, and cross-reference with Baidu Search Resource Platform impressions.
```

## Progressive Enhancement Tiers

Skills are designed to work at three levels of tool integration:

| Tier | Integration Level | Experience |
| --- | --- | --- |
| **Tier 1** | No integrations | Paste data and describe context manually. Skills still provide full analysis frameworks. |
| **Tier 2** | Basic MCP | Connect `~~search console` or `~~analytics` for automatic data retrieval. |
| **Tier 3** | Full integration | Connect SEO, analytics, search console, CDN, CMS, and more for fully automated workflows. |

Every skill works without any tool integration. Connecting tools through MCP
automates data retrieval but is never required.

## Environment Variables

Some skills declare a `primaryEnv` in their `metadata.openclaw` block for
ClawHub discovery. These are soft dependencies, not requirements.

| Variable | MCP Server | Skills Using It |
| --- | --- | --- |
| `AHREFS_API_KEY` | Ahrefs | keyword-research, competitor-analysis, serp-analysis, content-gap-analysis, backlink-analyzer, rank-tracker, internal-linking-optimizer |
| `AMPLITUDE_API_KEY` | Amplitude | performance-reporter, alert-manager |

Most newer servers, including Semrush, SE Ranking, SISTRIX, SimilarWeb,
Cloudflare, Vercel, Webflow, Sanity, and Contentful, use OAuth. Authentication
happens interactively on first use, so no environment variables are required.

All 20 skills function at Tier 1 by accepting manually provided data.
