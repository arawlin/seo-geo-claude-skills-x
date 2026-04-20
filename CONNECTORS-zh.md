# Connectors

本文档亦提供[英文版](./CONNECTORS.md)。

> 所有 skill 使用 `~~category` 占位符，而不是写死具体工具名。请把这些占位符
> 替换成你所在组织实际使用的工具。

如果你的关键词研究工作流以百度和中文市场为主，请同时参考
[docs/baidu-keyword-research-connector-mapping-zh.md](./docs/baidu-keyword-research-connector-mapping-zh.md)。

在这个 workspace 里，`.vscode/mcp.json` 已经配置了本地 SERP MCP server
`search-serp-adapter`。当关键词研究或 SERP 分析需要实时结果页数据时，优先使用
它，而不是手工抽样百度结果页。

## 工具类别

| 类别 | 占位符 | 示例工具 | 当前内置 Server |
| --- | --- | --- | --- |
| SEO 平台 | `~~SEO tool` | Ahrefs、Semrush、Moz、SISTRIX、SE Ranking、百度指数、5118、爱站、站长工具 | Ahrefs、Semrush、SE Ranking、SISTRIX |
| 分析平台 | `~~analytics` | Google Analytics、Adobe Analytics、Plausible、Matomo、百度统计 | Amplitude |
| 搜索控制台 | `~~search console` | Google Search Console、Bing Webmaster Tools、百度搜索资源平台 | — |
| AI 可见性 | `~~AI monitor` | Otterly、Profound、Scrunch AI | — |
| 爬虫工具 | `~~web crawler` | Screaming Frog、Sitebulb、DeepCrawl、Lumar | — |
| 外链数据库 | `~~link database` | Ahrefs、Majestic、Moz Link Explorer | Ahrefs、Semrush |
| 竞品情报 | `~~competitive intel` | SimilarWeb、SpyFu、Semrush、5118、爱站 | SimilarWeb、Semrush |
| CDN / Hosting | `~~CDN` | Cloudflare、Fastly、Vercel、Netlify | Cloudflare、Vercel |
| 页面速度 | `~~page speed tool` | Google PageSpeed Insights、WebPageTest、GTmetrix、Lighthouse CLI、Chrome UX Report (CrUX) API | —（当前无默认 MCP，见下方“没有 MCP 时的页面速度数据”） |
| Schema 校验 | `~~schema validator` | Google Rich Results Test、Schema.org Validator | — |
| 知识图谱 | `~~knowledge graph` | Google Knowledge Graph API、Wikidata SPARQL、DBpedia、CrunchBase | — |
| 品牌监测 | `~~brand monitor` | Google Alerts、Brand24、Mention.com、Brandwatch | — |
| CRM / 营销 | `~~CRM` | HubSpot、Salesforce、Marketo | HubSpot |
| 内容平台 | `~~content platform` | Notion、WordPress、Medium、Ghost、Substack | Notion |
| 沟通工具 | `~~team chat` | Slack、Microsoft Teams、Discord | Slack |
| 报表 | `~~reporting` | Google Data Studio、Tableau、Power BI | — |
| 内容管理 | `~~CMS` | WordPress、Webflow、Contentful、Sanity | Webflow、Sanity、Contentful |

## 当前内置 MCP Servers

这些 server 已在 `.mcp.json` 中预配置为 HTTP 方式，不需要本地安装额外程序：

| Server | 提供能力 |
| --- | --- |
| Ahrefs | 关键词数据、外链画像、站点审计 |
| Semrush | 关键词研究、域名分析、外链、SERP 数据 |
| SE Ranking | 关键词跟踪、站点审计、竞品数据 |
| SISTRIX | Visibility Index、排名、搜索量 |
| SimilarWeb | 流量估算、竞品情报 |
| Cloudflare | DNS 管理、缓存清理、Workers、性能 |
| Vercel | 项目部署、域名管理、日志 |
| HubSpot | CRM 联系人、营销分析 |
| Amplitude | 产品分析、用户行为数据 |
| Notion | 项目文档、内容日历 |
| Webflow | 站点管理、CMS 内容、设计画布 |
| Sanity | 结构化内容、Schema 管理、媒体 |
| Contentful | 内容生命周期管理、素材、环境 |
| Slack | 团队通知、告警投递 |

如果你要增加更多 server，请编辑项目根目录的 `.mcp.json`：

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

## 区域化连接器配置

你不需要在所有市场使用同一套工具栈。之所以使用通用占位符，就是为了让同一个
skill 可以在不同区域绑定不同的数据源。

### 全球默认配置

- `~~SEO tool` -> Ahrefs、Semrush、SE Ranking、SISTRIX
- `~~search console` -> Google Search Console、Bing Webmaster Tools
- `~~analytics` -> Google Analytics、Adobe Analytics、Plausible、Matomo
- `~~competitive intel` -> SimilarWeb、SpyFu、Semrush

### 中文区配置

- `~~SEO tool` -> 百度指数、5118、爱站、站长工具
- `~~search console` -> 百度搜索资源平台、百度统计、服务端日志
- `~~analytics` -> 百度统计、第一方分析、服务端日志
- `~~competitive intel` -> `search-serp-adapter`、5118、爱站

如果你需要 keyword-research 的百度版字段定义和输出口径，请查看
[docs/baidu-keyword-research-connector-mapping-zh.md](./docs/baidu-keyword-research-connector-mapping-zh.md)。

## Workspace 本地 MCP Servers

有些团队会把区域化 MCP connector 放在 workspace 配置里，而不是项目根目录的
`.mcp.json`。这个仓库当前的本地配置包含：

| Server | 配置位置 | 用途 |
| --- | --- | --- |
| `search-serp-adapter` | `.vscode/mcp.json` | 提供百度或其他已接搜索引擎的本地 SERP 抓取能力 |

## 没有 MCP 时的页面速度数据

`~~page speed tool` 目前没有默认 MCP server，因为目前没有供应商公开提供稳定的
对应接口。技术 SEO 审计仍然需要 Core Web Vitals 数据，因此这里给出手工输入路径。

### 方案 1：PageSpeed Insights 导出

- 在浏览器中打开 `https://pagespeed.web.dev/report?url=<your-url>`。
- 复制 JSON 视图或截图。
- 当 skill 要求提供 performance data 时，直接贴进对话。

### 方案 2：PSI API

- Endpoint: `https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed?url=<url>&strategy=mobile&key=<API_KEY>`
- 在 Google Cloud Console 申请免费的 PageSpeed Insights API key。
- 按需要贴出 `lighthouseResult.audits` 段落。

### 方案 3：Lighthouse CLI

- 运行 `npx lighthouse <url> --output json --output-path=./lh.json`。
- 粘贴关键段落，或总结 LCP、INP、CLS、TBT 分数。

### 方案 4：Chrome UX Report

- Endpoint: `https://chromeuxreport.googleapis.com/v1/records:queryRecord`
- 这个接口需要 API key。
- 它提供真实用户 field data，而不是实验室数据。
- 适合汇总站点级的 LCP、INP、CLS。

### 方案 5：接入 `~~web crawler`

- Screaming Frog 或 Sitebulb 可以在抓取时调用 PageSpeed Insights API。
- 导出包含每个 URL Core Web Vitals 的 CSV。
- 在做批量技术审计时把 CSV 贴给 skill。

## 占位符是怎么工作的

skill 里可能会这样写：

```text
Pull keyword rankings from ~~SEO tool and cross-reference with ~~search console impressions.
```

如果你的组织使用 Ahrefs 和 Google Search Console，就把它理解成：

```text
Pull keyword rankings from Ahrefs and cross-reference with Google Search Console impressions.
```

如果你的工作市场是中文区，也可以理解成：

```text
Pull keyword demand from Baidu Index or 5118, use search-serp-adapter 校验实时 SERP 结构，再和百度搜索资源平台曝光数据交叉验证。
```

## 渐进增强层级

所有 skill 都按 3 个集成层级设计：

| 层级 | 集成方式 | 使用体验 |
| --- | --- | --- |
| **Tier 1** | 无集成 | 手工粘贴数据、口头描述上下文，skill 仍然可以输出完整分析框架。 |
| **Tier 2** | 基础 MCP | 连接 `~~search console` 或 `~~analytics`，自动拉取基础数据。 |
| **Tier 3** | 全量集成 | 连接 SEO、分析、搜索控制台、CDN、CMS 等工具，实现自动化工作流。 |

每个 skill 都可以在没有任何工具集成的情况下工作。MCP 的作用是自动取数，而不是
成为使用前提。

## 环境变量

一些 skill 会在 `metadata.openclaw` 中声明 `primaryEnv`，用于 ClawHub 发现。
这些都是软依赖，不会阻止 skill 在无集成模式下运行。

| 变量 | MCP Server | 使用这些变量的 Skills |
| --- | --- | --- |
| `AHREFS_API_KEY` | Ahrefs | keyword-research、competitor-analysis、serp-analysis、content-gap-analysis、backlink-analyzer、rank-tracker、internal-linking-optimizer |
| `AMPLITUDE_API_KEY` | Amplitude | performance-reporter、alert-manager |

大多数较新的 server，包括 Semrush、SE Ranking、SISTRIX、SimilarWeb、Cloudflare、
Vercel、Webflow、Sanity 和 Contentful，都使用 OAuth。首次使用时会进行交互式认证，
因此不需要环境变量。

全部 20 个 skill 都支持 Tier 1，也就是不接任何集成时，通过手工输入数据完成分析。
