# 百度版关键词研究连接器映射规范

本文档亦提供[英文版](./baidu-keyword-research-connector-mapping.md)。

## 用途

本文档定义了一套面向百度场景的
[keyword-research](../research/keyword-research/SKILL.md) 连接器映射规范。
它保留了这个 skill 现有的 8 阶段工作流和占位符式 connector 模型，但把默认的
全球化数据源替换成更适合中文市场的数据来源。

当你的站点面向中文搜索需求，且百度是主要搜索引擎时，使用这套映射。不要把它
原样用于 Google 优先或全球化 SEO 项目。

## 设计目标

- 保持 [CONNECTORS.md](../CONNECTORS.md) 现有的 `~~placeholder` 模型不变。
- 先支持 Tier 1 手工流程，再逐步升级到 Tier 2 或 Tier 3 自动化。
- 用适合百度的需求、竞争和排名信号替换全球默认指标。
- 让每个输出指标都能追溯到明确的数据来源类型。

## 适用范围

这套映射适用于：

- 中文内容选题和编辑规划
- 以百度为主的关键词研究
- 需要实用优先级判断的新站或低权重站
- 同时结合官方平台、第三方工具和 workspace 本地 SERP MCP 的混合型工作流

这套映射不默认依赖 Ahrefs、Semrush 或 Google Search Console。

## 占位符映射

建议把通用 connector 类别映射成以下中文区数据源。

| Skill 占位符 | 推荐中文区来源 | 主要用途 |
| --- | --- | --- |
| `~~SEO tool` | 百度指数、5118、爱站、站长工具 | 需求分、扩词、相关词、趋势输入 |
| `~~search console` | 百度搜索资源平台、百度统计、服务端日志 | 查询词到页面的表现、收录、点击与曝光证据 |
| `~~competitive intel` | `search-serp-adapter`、5118、爱站 | 竞品覆盖、结果页结构、交集分析 |
| `~~analytics` | 百度统计、第一方埋点、服务端日志 | 落地页访问上下文与转化辅助判断 |
| `~~AI monitor` | 百度 AI 搜索、豆包、Kimi、元宝的手工追踪 | 需要 GEO 观察时作为补充输入 |

在这个仓库里，`.vscode/mcp.json` 已经注册了一个本地 SERP MCP server，名称是
`search-serp-adapter`。在需要实时百度结果页结构时，默认先使用它，再决定是否做人审。

## 来源优先级规则

当同一指标可以从多个来源获得时，按以下顺序取值。

### 1. 官方平台数据

- 百度搜索资源平台
- 百度统计
- 第一方服务端日志

针对你自己站点的查询词、落地页和点击行为，优先使用官方或第一方数据。

### 2. 中文第三方 SEO 平台

- 5118
- 爱站
- 站长工具
- 百度指数

这些平台主要用于关键词发现、相关词扩展、需求估计和竞品覆盖分析。

### 3. Workspace 本地 SERP MCP

把 `.vscode/mcp.json` 中的 `search-serp-adapter` 作为百度 PC 和移动端结果抓取的主来源。
只有在本地 MCP 不可用，或需要人工复核结果时，才退回手工检查。

## 指标翻译层

原始 skill 依赖的是 search volume、keyword difficulty、SERP analysis、current rankings
和 competitor overlap 等全球 SEO 指标。在百度优先场景下，应按以下定义重解释。

### 搜索需求强度

用它替代精确的 historical search volume。

| 字段 | 类型 | 定义 |
| --- | --- | --- |
| `demand_score` | 0-100 数值 | 基于百度指数和第三方工具归一化后的需求分 |
| `demand_band` | low, medium, high | 当精确值不可辩护时使用的需求等级 |
| `trend_30d` | rising, flat, falling | 近 30 天变化趋势 |
| `trend_90d` | rising, flat, falling | 近 90 天变化趋势 |
| `seasonality_flag` | boolean | 是否存在明显季节性 |

建议来源组合：

- 百度指数趋势数据
- 5118 热度或需求指标
- 爱站关键词需求信号

当不同来源不一致时，优先输出归一化分数或等级，而不是伪造精确月搜。

### 关键词竞争难度

用它替代工具原生的 keyword difficulty。

| 字段 | 类型 | 定义 |
| --- | --- | --- |
| `difficulty_score` | 1-100 数值 | 百度竞争分 |
| `difficulty_band` | low, medium, high | 难度等级 |
| `authority_pressure` | 0-100 数值 | 首页强站压力 |
| `baijiahao_ratio` | percent | 抽样结果中百家号占比 |
| `official_site_ratio` | percent | 官方站或大平台占比 |
| `fresh_content_ratio` | percent | 180 天内更新或发布内容占比 |

建议评分模型：

```text
difficulty_score =
  0.25 * authority_pressure +
  0.20 * official_site_ratio +
  0.20 * baijiahao_ratio +
  0.15 * fresh_content_ratio +
  0.10 * competitor_coverage_pressure +
  0.10 * commercial_serp_density
```

建议解释标准：

- 1-39：低难度
- 40-69：中难度
- 70-100：高难度

### SERP 结构

用它替代泛化的 SERP analysis。

| 字段 | 类型 | 定义 |
| --- | --- | --- |
| `top10_result_types` | list | 前 10 结果的类型分布 |
| `forum_ratio` | percent | 论坛或问答站点占比 |
| `video_ratio` | percent | 视频结果占比 |
| `baike_presence` | boolean | 是否有百科结果出现在显著位置 |
| `baijiahao_presence` | boolean | 是否有百家号结果出现在显著位置 |
| `answer_box_presence` | boolean | 是否出现直答型模块 |
| `ecosystem_bias` | low, medium, high | 百度生态偏置强度 |

建议结果类型分类：

- 官方站
- 媒体站
- 百家号
- 百科
- 问答
- 论坛
- 视频
- 工具页
- 聚合页
- 下载页

### 自站查询表现

用它替代 Search Console 风格的 ranking 数据。

| 字段 | 类型 | 定义 |
| --- | --- | --- |
| `query` | string | 查询词 |
| `landing_page` | URL | 接住该查询词的落地页 |
| `impressions` | number | 观察到的曝光量 |
| `clicks` | number | 观察到的点击量 |
| `ctr` | percent | 点击率 |
| `avg_position_band` | range | 位置区间，例如 1-3、4-10、11-20、20+ |
| `indexed_flag` | boolean | 页面是否已收录 |

优先使用百度搜索资源平台。当平台数据不完整时，再补充百度统计和日志证据。

### 竞品关键词重叠

用它替代某个海外工具的 overlap 报表。

| 字段 | 类型 | 定义 |
| --- | --- | --- |
| `competitor_domain` | string | 竞品站点 |
| `overlapping_keywords_count` | number | 共享监控关键词数量 |
| `competitor_only_keywords` | number | 只在竞品侧发现的关键词数量 |
| `shared_high_intent_keywords` | number | 共享的商业型或转化型关键词数量 |
| `weak_gap_keywords` | list | 你未覆盖但竞争难度较低或中等的缺口词 |

建议来源：

- 5118 竞品词导出
- 爱站竞品词报告
- `search-serp-adapter` 导出的关键主题结果集

## 自动化的最小数据契约

如果你后续要自建百度版 MCP 服务，至少应该暴露以下 5 组能力。

### 1. 关键词指标

输入：

- 种子词
- 市场或地区
- 语言
- 设备类型

输出：

- `query`
- `demand_score`
- `demand_band`
- `difficulty_score`
- `difficulty_band`
- `trend_30d`
- `trend_90d`
- `source_list`

### 2. 扩词结果

输入：

- 种子词
- 最大返回数
- 是否包含问句词

输出：

- `keyword`
- `relation_type`
- `demand_score`
- `source`
- `geo_potential_flag`

### 3. SERP 快照

输入：

- 查询词
- 市场或地区
- 设备
- top-N 数量

输出：

- `rank`
- `title`
- `url`
- `domain`
- `result_type`
- `ecosystem_flag`
- `freshness_hint`
- `snippet_presence`

实现说明：

- 在这个 workspace 中，这个能力应优先通过 `.vscode/mcp.json` 里配置的
  `search-serp-adapter` MCP server 提供。

### 4. 自站查询数据

输入：

- 站点
- 时间范围
- 查询词或页面过滤条件

输出：

- `query`
- `landing_page`
- `impressions`
- `clicks`
- `ctr`
- `avg_position_band`
- `indexed_flag`

### 5. 竞品交集

输入：

- 目标站点
- 竞品站点列表
- 主题范围

输出：

- `keyword`
- `target_has_page`
- `competitor_count`
- `top_competitor`
- `estimated_gap_value`
- `difficulty_band`

## 面向关键词研究报告的输出规则

使用这套映射时，报告格式也应该改成适合百度场景的表达方式。

### 需求表达

优先使用：

- `需求分 78/100，近 90 天上升`

避免：

- 在只有趋势数据时硬写精确月搜

### 难度表达

优先使用：

- `百度竞争分 42/100；前 10 结果里有 3 个强站和 2 个百家号结果`

避免：

- 直接套用海外工具的 KD 标签，却不解释本地评分依据

### SERP 结构表达

优先使用：

- `前 10 结构：2 个官方站、3 个媒体站、2 个百家号、3 个论坛或问答结果`

### 机会值公式

保留 skill 原有的机会值逻辑，但输入要切换成百度口径。

```text
Opportunity = (Demand Score × Intent Value) / Difficulty Score
```

建议意图权重：

- informational = 1
- navigational = 1
- commercial = 2
- transactional = 3

## 报告中的必填说明

所有百度版关键词研究报告都应明确写出以下内容：

- 需求指标是精确值、估算值还是归一化值
- 竞争分是否为自定义百度竞争模型
- 各项数据里哪些来自官方平台、第三方工具或手工抽样
- SERP 抽样日期
- 抽样设备是 PC 还是移动端
- 地区口径是全国还是特定省市

如果缺少这些说明，报告看起来会比底层数据更“精确”，但其实不可复核。

## 推荐落地路径

### 第一阶段：本地 MCP 工作流

先从本地 SERP MCP 配合手工和第三方指标开始：

- 百度指数截图或导出
- 5118 或爱站关键词导出
- `search-serp-adapter` SERP 抓取结果
- 百度搜索资源平台截图

### 第二阶段：文件驱动聚合

把导出的 CSV 统一归一成本文档定义的字段。

### 第三阶段：扩展 MCP 自动化

再把归一层包装成 `~~SEO tool` 和 `~~search console` 的实现，供自动化流程调用。

## 总结

这份映射规范不是替换
[keyword-research](../research/keyword-research/SKILL.md) 工作流，而是让它适配百度优先的运营场景。具体方式是：把 connector 类别重新绑定到中文区数据源，并把需求、难度、SERP、排名与重叠分析改写成更适合中文搜索、且可辩护的指标体系。
