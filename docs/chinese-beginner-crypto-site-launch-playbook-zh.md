# 中文新手加密站点首发手册

本文档亦提供[英文版](./chinese-beginner-crypto-site-launch-playbook.md)。

## 首发补充运行规则

把这一节视为 MVP 首发批次的发布闸门。如果文档其他地方的轻量清单与这里冲突，以这一节为准。

### 1. 信任与披露最低标准

- 任何包含返佣链接或联盟链接的页面，都必须把披露语放在第一处商业化链接之前或同一屏内首屏可见的位置，并使用“affiliate”“paid”“earn a commission”这类明确措辞或同等清晰的中文表达。
- 联盟链接默认应带有 `rel="sponsored nofollow"`，除非你已有更严格的站点级规范。
- 第一次公开上线前，必须具备隐私政策、服务条款、编辑政策、更正与更新政策、至少两种联系方式的联系页，以及市场风险免责声明页面。
- 所有交易所、手续费、奖励、返佣、KYC、提币限制相关页面，都要显示最近核验日期、核验范围，以及核验人姓名或角色。
- 缺少披露、缺少信任页、或高风险事实已过期，都视为阻止发布的问题。

### 2. 证据台账标准

- 所有可能快速变化的事实性陈述，在发布前都必须有一条对应的证据记录。这包括手续费、返佣比例、注册奖励、身份验证规则、提币额度、支持国家地区，以及产品流程截图。
- 最低记录字段包括：声明 ID、页面 slug、声明内容、来源 URL、来源类型、核验时间、核验人、截图或归档路径、发布状态、下次复核触发条件。
- 自动采集和人工核验必须分开记录。如果某个数字只是估算值，必须标记为估算，不能包装成已核验事实。
- 把证据台账放在编辑流程旁边，并在使用这些 skill 后把带日期的摘要写入记忆系统。
- 默认使用 [crypto-site-evidence-ledger-template-zh.md](./crypto-site-evidence-ledger-template-zh.md) 作为模板。

### 3. 实体与品牌基础建设

- 在扩展商业页之前，先定稿一份唯一的品牌主档：组织名称、短描述、长描述、Logo、创始人或主编姓名、作者简介、社交或账号链接。
- About 页面和作者页面必须与 Organization / Person schema 使用同一套品牌事实。
- 先为品牌运行 `entity-optimizer`，再把输出同步到 About 文案、作者信息框、结构化数据和 CMS 默认信息中。
- 如果品牌容易和其他交易网站混淆，就要在 About、作者页和关键落地页中加入明确的区分说明。
- 站内文案、结构化数据和第三方资料之间出现实体漂移，应该视为上线问题，而不是以后再优化的小修小补。

### 4. 全站上线 QA 与回滚规则

- 正式上线前，必须在 staging 或 preview 环境对首页、文章模板、对比页模板、工具页模板和所有信任页进行一次全站技术检查。
- 逐类模板核对 robots、sitemap、canonical、`noindex` 状态、元信息一致性、`H1`、结构化数据有效性、内链、面包屑、移动端渲染和 Core Web Vitals。
- 上线当天确认没有误封禁指令，重新提交 sitemap，抽检代表性 URL，并监控 `5xx` 与 `404` 异常峰值。
- 预先定义回滚触发条件：抓取被阻断、canonical 错误、披露模块未渲染、商业页 schema 丢失，或 `404` / `5xx` 异常升高。
- 默认使用 [crypto-site-launch-qa-checklist-zh.md](./crypto-site-launch-qa-checklist-zh.md) 作为上线检查表。

### 5. 上线后监控与刷新闭环

- 每一个首发波次都必须定义负责人、基线、阈值和复查日期，覆盖收录、曝光、点击、关键词波动、工具页 CTA 点击、返佣链接点击、Core Web Vitals 和安全告警。
- 首发批次在前 4 周按周复查，之后再切换到按月节奏。
- 当手续费、返佣、奖励规则、KYC 流程、支持地区、截图或法律措辞发生变化时，必须立即刷新页面。
- 页面发布后运行 `/seo:setup-alert` 和 `/seo:report`。当页面的新鲜度、信任度或排名匹配度下降时，运行 `content-refresher`。
- 在页面 brief 和证据台账里同时记录下次复查日期，避免高波动页面悄悄过期。

### 配套附录

- [crypto-site-evidence-ledger-template-zh.md](./crypto-site-evidence-ledger-template-zh.md)
- [crypto-site-launch-qa-checklist-zh.md](./crypto-site-launch-qa-checklist-zh.md)
- [chinese-beginner-crypto-first-batch-brief-audit-zh.md](./chinese-beginner-crypto-first-batch-brief-audit-zh.md)

## 用途

这份手册把前面的策略讨论整理成可执行路线，适用于已经完成
Next.js 和 Strapi 搭建、现在要开始填充首发内容的中文新手加密站点。

首发范围刻意收窄为：

- 12 篇首发内容页
- 3 个工具页
- 1 套可重复执行的研究、写作、审核、发布流程

这是一份 how-to guide，而不是概念说明。默认读者是已经有站点框架、现在
需要把 MVP 真正上线的人。

## 目标用户与定位

- 用户：第一次接触加密货币的中文用户
- 网站承诺：帮助用户更安全地完成第一笔交易，少犯低级错误，更清楚地理解
  手续费返佣
- 变现方式：交易所返佣链接与相关转化页
- 表达风格：冷静、直接、风险优先、对新手友好

## MVP 边界

首发范围内应包含：

- 新手入门教程
- 交易所选择与省手续费页面
- 第一笔交易路径页
- 风险与防骗页面
- 轻量决策工具页

首发阶段先不要包含：

- 把日更行情分析作为核心获客方式
- 深度杠杆或合约教学，除非是基础解释和风险警示
- 大量币种单页
- 重度社群运营或付费会员流程
- 依赖复杂实时基础设施的大型监控面板

## 成功标准

只有满足以下条件，MVP 才算 ready：

- 12 篇内容页上线
- 3 个工具页上线
- About、免责声明与合作披露、隐私政策、更新与核验说明四类信任页上线
- 每篇内容页都只指向一个明确的下一步页面
- 每个页面都有标题、元描述、必要时的 FAQ，以及匹配的结构化数据
- 每个页面都通过内容审计和技术预检
- 每个页面都有清晰的风险提示、最后核验日期，以及有合作链接时的披露

## 这个仓库在流程中的角色

把这个仓库当成内容操作系统，而不是整个业务系统。

- Next.js 负责模板、路由和工具交互
- Strapi 负责存储内容模型、SEO 字段、FAQ、更新时间和工具页说明文案
- 这个技能库负责研究、起草、元信息、结构化数据、审计和项目记忆

优先使用 command，只有当你需要更细控制时，才直接下钻到单个 skill。

| 层级 | 适合处理的事 | 主要入口 |
| ------ | -------------- | ---------- |
| 研究层 | 关键词、竞品、内容缺口 | [keyword-research](../commands/keyword-research.md) |
| 构建层 | 正文草稿、GEO 优化、标题摘要 | [write-content](../commands/write-content.md), [optimize-meta](../commands/optimize-meta.md) |
| 结构化数据 | FAQ、Article、HowTo、Organization、Breadcrumb | [generate-schema](../commands/generate-schema.md) |
| 审核层 | 内容质量、页面质量、技术检查 | [audit-page](../commands/audit-page.md), [check-technical](../commands/check-technical.md) |
| 记忆层 | 保存进度、开放问题、优先级关键词 | [memory-management](../cross-cutting/memory-management/SKILL.md) |

如果你当前代理环境不支持 slash command，也可以直接使用同名 skill 对应的
自然语言提示。

## 单页标准流程

除非任务卡另有说明，否则所有内容页都按这条流程执行。

### 第 1 步：跑关键词研究

使用 [keyword-research](../commands/keyword-research.md) 确认主关键词、用户、
业务目标和页面类型。

示例：

```text
/seo:keyword-research "新手怎么买比特币" audience="中文区新手" goal="返佣" authority="low" competitors="cryptotradingcafe.com"
```

要记录：

- 主关键词
- 3 到 5 个次关键词
- 搜索意图
- 主要竞争页面
- 建议内容类型

### 第 2 步：拆一个强竞品

当你需要知道对手是怎么讲同一主题时，使用
[competitor-analysis](../research/competitor-analysis/SKILL.md)。

示例提示：

```text
Analyze SEO strategy for https://cryptotradingcafe.com around "新手怎么买比特币". Focus on beginner onboarding, trust signals, and rebate conversion.
```

要记录：

- 对手讲得好的部分
- 对手讲得含糊、过宽或不够友好的部分
- 对手呈现了哪些信任信号
- 你可以为新手做得更清楚的地方

### 第 3 步：找内容缺口

使用 [content-gap-analysis](../research/content-gap-analysis/SKILL.md)，避免只是
换个标题再写一遍同样的文章。

示例提示：

```text
Find content gaps between my site and cryptotradingcafe.com for Chinese beginner crypto onboarding.
```

要记录：

- 缺失的章节
- 缺失的格式，比如清单、计算器、对比表
- 缺失的风险解释
- 缺失的下一步承接链接

### 第 4 步：先在 Strapi 建 brief

在起草之前，先在 Strapi 填好这些字段：

- working title
- slug
- primary keyword
- secondary keywords
- audience
- intent
- page type
- CTA
- disclaimer flag
- last verified date
- FAQ block
- related pages

### 第 5 步：生成正文草稿

优先使用 [write-content](../commands/write-content.md)。它已经把 SEO 写作与 GEO
优化串起来了。

示例：

```text
/seo:write-content "新手如何完成第一笔比特币购买" keyword="新手怎么买比特币" type="how-to guide"
```

草稿回来后，必须手动补这些内容：

- 地区相关说明
- 平台规则核验
- 合规安全的表述
- 你自己的品牌语气与披露文案

### 第 6 步：优化标题和元描述

使用 [optimize-meta](../commands/optimize-meta.md)。

示例：

```text
/seo:optimize-meta "新手如何完成第一笔比特币购买" keyword="新手怎么买比特币"
```

### 第 7 步：生成结构化数据

使用 [generate-schema](../commands/generate-schema.md)。

常见搭配：

- 教程和解释页：Article + FAQ
- 步骤型指南：HowTo + FAQ
- 工具页：WebPage + FAQ

示例：

```text
/seo:generate-schema Article for 新手如何完成第一笔比特币购买
/seo:generate-schema FAQ for 新手如何完成第一笔比特币购买
```

### 第 8 步：发布前做内容审计

使用 [audit-page](../commands/audit-page.md)。

示例：

```text
/seo:audit-page [draft text or preview URL] keyword="新手怎么买比特币"
```

重点修复：

- 搜索意图不匹配
- 标题承诺不清楚
- 披露不完整
- 证据不够或步骤不完整
- FAQ 太弱或内链不足

### 第 9 步：做技术预检

对预览地址使用 [check-technical](../commands/check-technical.md)。

示例：

```text
/seo:check-technical https://preview.example.com/first-bitcoin-purchase
```

### 第 10 步：保存决策与进度

页面发布后，或者一个批次完成后，使用
[memory-management](../cross-cutting/memory-management/SKILL.md)
保存过程结论。

示例提示：

```text
Save project progress for beginner crypto launch week 1. Store hero keywords, completed pages, open loops, and next priorities.
```

## 12 加 3 之外的基础任务

这些任务必须先做，但不计入 12 篇内容页和 3 个工具页。

### F1：创建 Strapi 内容模型

交付物：

- Article 内容类型
- Tool Page 内容类型
- FAQ 组件
- Disclosure 组件
- Update Log 组件

Article 建议字段：

- title
- slug
- summary
- primary_keyword
- secondary_keywords
- audience
- intent
- page_type
- hero_cta
- main_body
- faq_items
- seo_title
- meta_description
- og_title
- og_description
- schema_types
- last_verified_at
- risk_note
- disclosure_text
- related_articles
- next_step_article

Tool Page 建议字段：

- title
- slug
- intro
- who_it_is_for
- who_should_not_use_it
- input_labels
- result_states
- explanation_copy
- faq_items
- seo_title
- meta_description
- schema_types
- risk_note
- disclosure_text
- last_verified_at
- related_articles

步骤：

1. 在 Strapi 中建立 Article 和 Tool 两类模型。
2. 建 FAQ、披露、风险提示、更新记录四个可复用组件。
3. 把主关键词、搜索意图、CTA 和最后核验时间设为必填。
4. 增加 review status 字段，至少包含 Draft、In Review、Ready For QA、
   Ready To Publish、Published。
5. 为每种页面类型预填一份模板 entry。

### F2：上线信任页

必须有的页面：

- About
- Disclaimer and affiliate disclosure
- Privacy policy
- Update and verification policy

步骤：

1. 先人工起草这些页面。
2. 用 [optimize-meta](../commands/optimize-meta.md) 做标题和摘要。
3. 用 [generate-schema](../commands/generate-schema.md) 生成
   Organization 或 WebPage schema。
4. 用 [audit-page](../commands/audit-page.md) 做清晰度和信任检查。

### F3：定义导航和 CTA 规则

规则：

- 首页只把用户分流到三条路径：完全新手、选择交易所、完成第一笔购买
- 每个页面只能有一个主 CTA 和一个下一步页面
- 交易所页面可以放返佣 CTA，但必须同时放风险提示和规则核验说明

### F4：制作可复用内容块

至少准备这些 block：

- TL;DR 摘要
- 这篇写给谁
- 哪类人不要按这篇操作
- 风险提示
- FAQ
- 下一步 CTA
- 最后核验日期
- 披露横幅

### F5：建立 QA 队列

每个页面上线前，必须完成：

- 正文完成
- meta 完成
- schema 完成
- 内容审计通过
- 技术检查通过
- 内链补齐
- 披露人工复核完成

## 首发第 1 批：最短转化链

第 1 批的目标，是让一个完全新手先理解网站、做出平台选择并开始注册。

### C01：新手总指南

- 页面类型：支柱页
- 目标：作为全站新手入口和内链中心
- 主关键词：新手炒币入门
- CTA：去选择交易所

步骤：

1. 跑新手 onboarding 关键词研究。
2. 拆竞品的新手总入口页面。
3. 写一篇长文总指南，章节一定要清楚。
4. 加上到交易所对比、注册教程、第一笔购买、防骗和风险管理的链接。
5. 生成 Article 和 FAQ schema。
6. 审计并修复清晰度问题。

### C02：币安和欧易怎么选

- 页面类型：对比页
- 目标：做用户决策页，同时建立信任和费率透明
- 主关键词：币安和欧易哪个好
- CTA：去对应注册教程

步骤：

1. 跑关键词研究。
2. 跑竞品分析，重点看 trust 和新手表述。
3. 写一张清晰对比表，覆盖易用性、下载体验、产品复杂度、费率、KYC
   阻力和支持情况。
4. 增加“什么人适合哪个平台”这一节。
5. 增加返佣解释和披露。
6. 生成 FAQ schema。
7. 审计并发布。

### C03：币安注册教程

- 页面类型：How-to guide
- 目标：高信任返佣转化页
- 主关键词：币安注册教程
- CTA：通过核验过的链接注册

步骤：

1. 研究关键词变体。
2. 在写稿前先人工核验当前注册流程。
3. 写教程时加入截图或截图占位。
4. 增加适用对象、当前限制和常见错误。
5. 增加推荐码、App 下载、KYC 和常见报错 FAQ。
6. 加 Article 和 FAQ schema。
7. 跑内容审计和技术检查。

### C04：欧易注册教程

- 页面类型：How-to guide
- 目标：提供第二条返佣转化路径
- 主关键词：欧易注册教程
- CTA：通过核验过的链接注册

步骤：

1. 按 C03 的同一流程执行。
2. 不要直接复用币安文案，平台规则不同，必须重写。
3. 发布前再次人工核验全部步骤。

### T01：交易所选择器

- 页面类型：工具页
- 目标：给新手一个简单明确的选平台结论
- CTA：跳到币安或欧易教程

最小功能逻辑：

- 用户选择熟悉度、交易目标、偏好简单程度、是否怕复杂、是否重视返佣
- 输出推荐平台和解释原因

步骤：

1. 先用纯文字写清楚决策逻辑。
2. 在 Next.js 里实现结果状态。
3. 在 Strapi 里存工具介绍、问题文案、答案文案、结果文案、FAQ、披露和
   更新时间。
4. 用 [write-content](../commands/write-content.md) 生成工具外层说明文案。
5. 用 [generate-schema](../commands/generate-schema.md) 生成 WebPage 和 FAQ。
6. 审核工具页文案。

## 首发第 2 批：第一笔交易路径

第 2 批的目标，是帮助已经注册的人理解入金、第一笔购买，以及返佣为什么
有价值。

### C05：人民币如何购买 USDT

- 页面类型：教程页
- 目标：讲清楚第一步入金动作
- 主关键词：人民币怎么买USDT
- CTA：继续阅读第一笔比特币购买指南

步骤：

1. 研究关键词和常见问题。
2. 人工核验平台当前的入金步骤。
3. 写清楚操作顺序、常见错误和风险提示。
4. 增加支付方式、到账时间、限额和安全问题 FAQ。
5. 生成 HowTo 或 Article schema，再补 FAQ schema。
6. 发布前审计。

### C06：如何完成第一笔比特币购买

- 页面类型：How-to guide
- 目标：帮助用户更安全地完成第一笔购买
- 主关键词：新手怎么买比特币
- CTA：阅读新手第一笔买什么币

步骤：

1. 跑关键词研究。
2. 查看排名靠前页面的常见结构。
3. 用非常简单的语言写步骤，并明确警告不要碰杠杆。
4. 在真正购买步骤前放一个检查清单模块。
5. 生成 FAQ 和 Article schema。
6. 审计并发布。

### C07：返佣、邀请码、手续费到底是什么

- 页面类型：解释页
- 目标：减少疑惑，增加转化信任
- 主关键词：返佣是什么意思
- CTA：打开返佣节省计算器

步骤：

1. 跑关键词研究。
2. 看竞品返佣页哪里解释得不够清楚。
3. 写一篇解释页，把自动返佣、手动返佣、为什么能省钱、用户应核验什么讲清楚。
4. 增加披露文案和核验清单。
5. 生成 FAQ schema。
6. 发布前审计。

### C08：交易所手续费对比与省钱方法

- 页面类型：对比页
- 目标：强化“帮用户降低成本”的定位
- 主关键词：交易所手续费对比
- CTA：使用返佣节省计算器

步骤：

1. 跑关键词研究。
2. 人工收集当前费率数据并注明核验日期。
3. 写一张清晰的对比表。
4. 增加现货、合约和隐性成本说明。
5. 增加 FAQ schema，并链回返佣相关页面。
6. 审计后发布。

### T02：返佣节省计算器

- 页面类型：工具页
- 目标：把返佣价值变成可感知的金额结果
- CTA：跳转到对应注册页

最小功能逻辑：

- 输入：月交易额、手续费率、返佣比例
- 输出：每月节省金额、每年节省金额、结果说明

步骤：

1. 定义计算公式和边界情况。
2. 在 Next.js 里实现交互。
3. 在 Strapi 里存标签、帮助文案、示例、FAQ 和结果说明。
4. 用 [write-content](../commands/write-content.md) 写工具说明页文案。
5. 生成 WebPage 和 FAQ schema。
6. 跑文案审计和技术检查。

## 首发第 3 批：风险与信任路径

第 3 批的目标，是让站点不只是“会转化”，也能让新手感受到你在帮他们避坑。

### C09：现货和合约的区别

- 页面类型：解释页
- 目标：让新手不要过早接触杠杆
- 主关键词：现货和合约的区别
- CTA：阅读风险管理指南

步骤：

1. 研究关键词变体。
2. 用具体例子解释风险差异。
3. 保持克制，不要把杠杆写得很刺激。
4. 加上爆仓、波动和为什么新手应先等一等的 FAQ。
5. 发布前审计。

### C10：新手第一笔该买什么

- 页面类型：解释页
- 目标：解决第一笔配置决策问题
- 主关键词：新手第一笔买什么币
- CTA：阅读比特币购买指南

步骤：

1. 跑关键词研究。
2. 以简单、波动和风险承受能力为框架来写。
3. 不要写收益承诺。
4. 加 FAQ，并链到 USDT 和比特币购买页。
5. 发布前审计。

### C11：新手防骗清单

- 页面类型：清单型指南
- 目标：建立信任和收藏价值
- 主关键词：币圈新手防骗
- CTA：完成第一次买币准备度检查

步骤：

1. 跑关键词研究。
2. 看竞品覆盖盲点。
3. 写一份非常具体的清单，把风险信号和处理动作写清楚。
4. 增加假客服、假老师、钓鱼链接、假交易所等案例。
5. 生成 FAQ schema。
6. 发布前审计。

### C12：新手风险管理入门

- 页面类型：指南页
- 目标：让品牌心智落在“先活下来”上
- 主关键词：炒币风险管理
- CTA：回到新手总指南

步骤：

1. 跑关键词研究。
2. 写仓位、亏损上限、不碰杠杆、不梭哈这些原则。
3. 用清楚的数字和例子代替抽象警告。
4. 加 FAQ schema。
5. 发布前审计。

### T03：第一次买币准备度检查

- 页面类型：工具页
- 目标：告诉用户自己是否已经准备好安全地下第一笔单
- CTA：根据结果跳到比特币购买指南或风险页

最小功能逻辑：

- 检查项包括：实名是否完成、2FA 是否开启、交易所是否选好、入金路径是否理解、
  是否理解现货和合约区别、是否准备了专用支付方式、是否知道基本骗局
- 输出：Ready、Almost Ready、Not Ready

步骤：

1. 定义每一道检查题和评分规则。
2. 在 Next.js 中实现界面。
3. 在 Strapi 中存所有标签、帮助文案、FAQ 和结果说明。
4. 用 [write-content](../commands/write-content.md) 写工具说明页文案。
5. 生成 WebPage 和 FAQ schema。
6. 做审计和技术检查。

## 每周执行节奏

### 第 0 周

- 完成 F1 到 F5
- 为第 1 批跑完一轮研究
- 在 Strapi 里定稿文章模板和工具模板

### 第 1 周

- 上线 C01 到 C04 和 T01
- 检查这一批页面之间的内链
- 批次结束后保存项目记忆

### 第 2 周

- 上线 C05 到 C08 和 T02
- 所有费率与返佣信息上线前再次人工核验
- 批次结束后保存项目记忆

### 第 3 周

- 上线 C09 到 C12 和 T03
- 在首页增加三个用户路径的入口
- 批次结束后保存项目记忆

### 第 4 周

- 对全部 15 个页面重跑一轮审计
- 收紧内链和下一步 CTA
- 补齐更新记录和披露
- 决定是否进入第 2 阶段，开始日更分析内容

## 单页完成标准

只有同时满足以下条件，页面才算 done：

- Strapi entry 完整
- 正文经过人工编辑，不只是 AI 输出
- 主 CTA 清晰
- 风险提示可见
- 需要时披露可见
- 最后核验日期存在
- 标题和元描述定稿
- 结构化数据与可见内容一致
- 页面通过内容审计
- 页面通过技术检查
- 页面只链向一个下一步页面

## 每个批次应保存到项目记忆的内容

每一批结束后，至少保存：

- Top 5 hero keywords
- 本周完成的页面
- 因为缺少核验而被阻塞的页面
- 还没解决的竞品缺口
- 下一批优先级列表

推荐提示：

```text
Save project progress for beginner crypto site launch. Store completed pages, hero keywords, blocked items, and next wave priorities.
```

## 质量与合规提醒

- 交易所规则、推荐条件和地区限制必须人工核验后再发
- 返佣比例如果会变，必须写明核验日期
- 不要发布收益承诺或确定性结果表达
- 页面语气不要比品牌承诺更激进
- 工具页要讲清楚限制条件，不能只给输出结果
- FAQ schema 必须和页面可见 FAQ 一字一句对应

## MVP 之后的第 2 阶段

只有在 12 加 3 这套首发集合稳定后，再扩展到：

- 日更市场分析
- 更深的币种教育页
- 更多交易所页面
- 词典型页面扩展
- 新手邮件或 Telegram 引导流程
