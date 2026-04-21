# 5118 API 到 MCP 工具映射规范

本文档亦提供[英文版](./5118-mcp-tool-mapping.md)。

## 用途

本文档定义了一套从 5118 官方 API 到 Model Context Protocol 工具的实用映射，
面向中文区 SEO 工作流。

它服务于 [CONNECTORS.md](../CONNECTORS.md) 里的 `~~SEO tool` 占位符，也服务于
[baidu-keyword-research-connector-mapping-zh.md](./baidu-keyword-research-connector-mapping-zh.md)
里定义的百度优先工作流。

## 当前状态

基于目前能够公开访问的页面，可以确认：

- 5118 提供官方 API 商城和生产可用的 API 接口。
- 5118 对外宣传了一个可导入 OpenClaw、Gemini、Claude 等 AI 智能体的 Skill 包。
- 这次核查没有确认到 5118 官方公开的 MCP server 仓库。
- 这次核查也没有确认到一个已有明显采用度的第三方 5118 MCP server。

因此，最推荐的实现路径是：用一层薄的 MCP proxy 或 adapter 去封装 5118 官方 API。

## 已确认的 5118 官方能力

以下 API 能力都已经从 5118 官方 API 商城页面确认。

| 能力 | 5118 API | 已确认接口地址 |
| --- | --- | --- |
| 长尾词扩展 | 海量长尾词挖掘APIv2 | `http://apis.5118.com/keyword/word/v2` |
| 批量关键词搜索量与指数查询 | 关键词搜索量信息APIv2 | `http://apis.5118.com/keywordparam/v2` |
| PC 关键词排名查询 | PC-排名查询API | `http://apis.5118.com/morerank/baidupc` |
| 网站 PC 排名词导出 | PC-网站排名词导出APIv2 | `http://apis.5118.com/keyword/pc/v2` |
| 下拉词挖掘 | 下拉联想词挖掘API | `http://apis.5118.com/suggest/list` |

API 商城里还能看到其他相关能力，包括整站排名词导出、移动端排名词导出、前 50
网站快照、竞价词查询和垂直场景长尾词接口。

## 设计原则

- 暴露任务语义清晰的 MCP tool，不直接暴露底层 endpoint 名称。
- 在需要时保留 5118 原始字段，但对上层 skill 常用字段做归一化。
- 明确标注这些工具是 `official-api-backed`，不是 `official-mcp-backed`。
- 对使用 taskid 的接口，支持分页与异步轮询。

## 推荐 MCP 工具集合

下面这 5 个工具已经足够支撑关键词研究和竞品分析的最小可用集成。

### 1. `get_keyword_expansion_5118`

用途：

- 从一个种子词扩展出长尾关键词机会。

5118 来源：

- 海量长尾词挖掘APIv2
- 接口地址：`http://apis.5118.com/keyword/word/v2`

建议 MCP 输入：

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

建议 MCP 输出：

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

主要下游用途：

- 关键词发现
- 长尾词聚类
- 商业价值初筛

### 2. `get_keyword_metrics_5118`

用途：

- 一次获取最多 50 个关键词的搜索量、指数、竞争和需求信号。

5118 来源：

- 关键词搜索量信息APIv2
- 接口地址：`http://apis.5118.com/keywordparam/v2`

实现说明：

- 这个接口采用 task 模式。先提交任务，再根据 `taskid` 轮询结果。

建议 MCP 输入：

```json
{
  "keywords": [
    "比特币怎么买",
    "新手买usdt",
    "加密货币入门"
  ]
}
```

建议 MCP 输出：

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

主要下游用途：

- 需求归一化
- 难度估计
- 机会值计算

### 3. `get_suggest_terms_5118`

用途：

- 获取指定平台的下拉联想词。

5118 来源：

- 下拉联想词挖掘API
- 接口地址：`http://apis.5118.com/suggest/list`

建议 MCP 输入：

```json
{
  "word": "国庆假期",
  "platform": "baidu"
}
```

建议 MCP 输出：

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

主要下游用途：

- 问题型词发现
- 意图扩展
- GEO 友好表达识别

### 4. `get_keyword_rank_snapshot_5118`

用途：

- 针对目标网站和关键词集合，拉取 PC 排名快照。

5118 来源：

- PC-排名查询API
- 接口地址：`http://apis.5118.com/morerank/baidupc`

实现说明：

- 这个接口同样采用 task 模式。先提交任务，再轮询结果。

建议 MCP 输入：

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

建议 MCP 输出：

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

主要下游用途：

- 目标站排名校验
- quick win 词验证
- 竞品位置抽查

### 5. `get_site_ranking_keywords_5118`

用途：

- 批量导出一个网站的 PC 排名词。

5118 来源：

- PC-网站排名词导出APIv2
- 接口地址：`http://apis.5118.com/keyword/pc/v2`

建议 MCP 输入：

```json
{
  "url": "https://example.com",
  "pageIndex": 1
}
```

建议 MCP 输出：

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

主要下游用途：

- 竞品词重叠分析
- 站点级内容缺口分析
- 排名词库存建立

## 可选扩展工具

如果你后续要做更完整的中文区 SEO MCP，可以继续加这些工具：

- `get_site_ranking_keywords_mobile_5118`
- `get_domain_ranking_keywords_pc_5118`
- `get_top50_serp_sites_5118`
- `get_bidding_keywords_by_domain_5118`
- `get_bidding_domains_by_keyword_5118`

## 鉴权与传输建议

公开页面已经确认了 API endpoint 和在线调试页，但这份文档不假设具体鉴权 header 名称，
除非你已经在自己的 5118 账号或 API 凭证后台中核验过。

建议的 MCP 设计：

- 统一做成一个 `5118-seo-adapter` MCP server
- 凭证放在环境变量，不要放到 prompt 文本里
- 对 task 型 API，尽量在一个 MCP tool 里封装“提交 + 轮询”
- 为调试保留 `raw` 字段，挂原始响应片段

## 错误处理建议

因为部分 5118 API 采用 task 模式，且可能需要 1 到 10 分钟返回结果，MCP wrapper
应统一归一成以下状态：

- `queued`
- `running`
- `completed`
- `failed`

建议 wrapper 行为：

- 先提交任务
- 按受控间隔轮询
- 如果仍在运行，返回阶段性状态
- 提供 `waitForCompletion` 布尔参数给同步调用方

## 与仓库占位符的映射关系

在这个仓库里，一个以 5118 为底层的数据 MCP server 可以这样映射：

| 占位符 | 推荐工具集合 |
| --- | --- |
| `~~SEO tool` | `get_keyword_expansion_5118`、`get_keyword_metrics_5118`、`get_suggest_terms_5118`、`get_keyword_rank_snapshot_5118`、`get_site_ranking_keywords_5118` |
| `~~competitive intel` | `get_site_ranking_keywords_5118`、可选整站排名词导出、可选前 50 结果快照 |

## 推荐实现顺序

1. 先实现 `get_keyword_metrics_5118`。
2. 再实现 `get_keyword_expansion_5118`。
3. 再实现 `get_suggest_terms_5118`。
4. 再实现 `get_site_ranking_keywords_5118`。
5. 最后实现 `get_keyword_rank_snapshot_5118`。

这个顺序能先把关键词发现和指标能力跑起来，再补站点和竞品能力。

## 总结

5118 已经具备足够多的官方 API，可作为中文区关键词研究的主力 `~~SEO tool`。
当前真正缺少的不是数据，而是 MCP 打包层。最实际的方案不是等一个公开的 5118 官方 MCP
server，而是直接把官方 5118 API 封装成一个专用 MCP adapter。
