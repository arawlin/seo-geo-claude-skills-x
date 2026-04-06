# 提案 v3: Wiki 知识层

**��态**: 终稿 (含验收反馈)
**日期**: 2026-04-05
**灵感来源**: [Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
**架构评审**: Karpathy, Peter (OpenClaw), Dario Amodei (Anthropic), Simon Willison
**用户评审**: 李明 (多客户自由顾问), Sarah Chen (非技术内容经理), James Park (技术 SEO), 王芳 (小型电商老板)

---

## 1. 背景与动机

当前记忆系统 (HOT/WARM/COLD) 是生命周期管理的缓存。每个技能独立写入 `memory/` 子目录，晋升/降级规则按引用频率运作。这在检索层面有效，但存在四个缺口：

1. **无综合层**: 运行 keyword-research、competitor-analysis、serp-analysis 产生三份独立文件，没有制品将它们合并成演进中的全景。
2. **无矛盾检测**: 一月审计说"网站速度正常"，三月 technical-seo-checker 发现 CWV 退化，两份文件共存而无机制标记冲突。
3. **无可导航索引**: hot-cache (80 行) 容量有限，技能必须猜测加载哪些 WARM 文件。
4. **无项目隔离**: 多客户用户的 WARM 文件混在同一个 `memory/` 目录下，跨项目切换时上下文恢复成本高。

### v3 相对 v2 的关键调整

v2 经过架构团队评审后解决了层级定位和安全回退问题。v3 基于四位目标用户的实测反馈进一步优化：

| 用户反馈 | v3 调整 |
|----------|---------|
| 手动触发 = 不会触发 (4/4 用户) | 索引刷新改为**自动执行** (低风险操作)，编译页面保持确认模式 |
| 多项目隔离缺失 (李明) | 引入 `memory/wiki/<project>/` 项目级索引 |
| index 只有摘要，缺结构化数据 (Sarah, James) | index 条目增加 **score、status、next_action** 结构化字段 |
| 术语门槛过高 (Sarah, 王芳) | 增加面向终端用户的自然语言触发和结果呈现规范 |
| Source hash 应在 Phase 1 (James) | Phase 1 index 条目记录源文件 **mtime**，Phase 2 升级为 content hash |
| 测试策略缺失 (James) | 增加第 14 节验证策略 |
| 轻度用户无感 (王芳) | SessionStart hook 增加**主动引导**逻辑 |

### 验收反馈纳入

8 人联合验收后 (8/8 Accept，平均 8.4/10)，纳入以下遗留改进项：

| 验收反馈 | 提出者 | 纳入方式 |
|----------|--------|----------|
| 摘要列标为 best-effort，结构化字段优先 | Karpathy + Simon | 第 6.1 节字段说明增加精确度分级 |
| Phase 2 矛盾裁定增加置信度标注 | Dario | 第 5.3 节矛盾解决策略增加 confidence 字段 |
| 分数列增加可读性标签 | Sarah | 第 6.1 节分数列增加 `健康度` 映射 |
| log.md 明确长期保留策略 | James | 第 9 节容量规则补充 log 归档策略 |
| Phase 3 WARM 退役增加 dry-run | Peter | 第 11 节 Phase 3 交付物增加 dry-run 模式 |

---

## 2. 核心设计原则

| # | 原则 | 来源 |
|---|------|------|
| P1 | **编译而非复制** — wiki 是 WARM 文件的编译产物，不存储原始数据 | Karpathy |
| P2 | **零技能侵入** — 执行技能的 SKILL.md 和写入路径不做修改 | Peter |
| P3 | **分级确认** — 低风险操作 (索引刷新) 自动执行；高风险操作 (编译页面写入) 需用户确认 | Dario + 用户反馈 |
| P4 | **增量证明** — 每阶段设评估门槛，不达标不推进 | Simon |
| P5 | **安全回退** — 删除 `memory/wiki/` 即回到 v6.2.0 行为 | 全体共识 |
| P6 | **源文件不可变** — wiki 操作永远不修改、不删除 WARM 源文件 | 全体共识 |
| P7 | **三层为终态** — 长期目标 HOT/WIKI/COLD，通过渐进迁移实现 | Karpathy + Simon |
| P8 | **用户分层** — 轻度用户通过主动引导受益，重度用户通过结构化索引受益，两者互不干扰 | 王芳 + 李明 |

---

## 3. 架构

### 3.1 Phase 1 架构

```
┌──────────────────────────────────────────────────────────┐
│  HOT    memory/hot-cache.md    (80 行, 自动加载)          │
├──────────────────────────────────────────────────────────┤
│  WARM   memory/<category>/     (按技能/类别, 按需加载)     │
│    └── wiki/                   (编译视图)          [新增] │
│         ├── index.md           (全局索引)                 │
│         └── <project>/         (项目级索引, 可选)         │
│              └── index.md                                │
├──────────────────────────────────────────────────────────┤
│  COLD   memory/archive/        (按日期, 仅查询)           │
└──────────────────────────────────────────────────────────┘
```

Wiki 位于 `memory/wiki/`，逻辑上是 WARM 的派生层，不参与温度生命周期。

### 3.2 Phase 2 架构

```
memory/wiki/
├── index.md                     # 全局索引
├── log.md                       # 追加式时间线
├── <project>/                   # 项目级
│    ├── index.md
│    ├── acme-corp.md            # 编译页面 (type: entity)
│    ├── best-crm-software.md    # 编译页面 (type: keyword)
│    └── core-web-vitals.md      # 编译页面 (type: topic)
└── <project-b>/
     └── index.md
```

编译页面平铺在项目目录内，用 frontmatter `type` 分类。超过 30 页后可拆分子目录。

### 3.3 终态架构 (Phase 3+)

```
┌──────────────────────────────────────────────────────────┐
│  HOT    memory/hot-cache.md    (80 行, 自动加载)          │
├──────────────────────────────────────────────────────────┤
│  WIKI   memory/wiki/           (编译, 互链, 按需加载)      │
├──────────────────────────────────────────────────────────┤
│  COLD   memory/archive/        (按日期, 仅查询)           │
└──────────────────────────────────────────────────────────┘
```

Wiki 吸收 WARM 核心功能，技能直接贡献结构化结论。原始 WARM 文件归入 COLD。

---

## 4. 项目隔离

### 4.1 设计

hot-cache.md 中已有"当前项目"标识 (如 `project: acme-campaign-q2`)。Wiki 利用此标识实现项目级索引：

```
memory/wiki/
├── index.md                        # 全局索引 (所有项目的汇总)
├── acme-campaign-q2/
│    └── index.md                   # 仅 Acme 项目的 WARM 文件
└── beta-seo-2026/
     └── index.md                   # 仅 Beta 项目的 WARM 文件
```

### 4.2 规则

- hot-cache 中 `project` 字段存在时，SessionStart 优先加载 `memory/wiki/<project>/index.md`
- `project` 字段不存在时，加载 `memory/wiki/index.md` (全局索引)
- 全局索引始终生成，项目级索引仅在 hot-cache 声明项目时生成
- WARM 文件归属到项目的依据：文件 frontmatter 中的 `project` 字段；无 `project` 字段的文件归入全局索引
- 单项目用户无感知：没有 `project` 字段就只有全局 index.md，行为与单项目完全一致

### 4.3 WARM 文件 frontmatter 扩展 (可选)

```yaml
---
name: competitor-acme-analysis
description: Acme Corp competitor analysis for Q2 campaign
type: reference
project: acme-campaign-q2          # 可选。标注归属项目
---
```

技能不强制写 `project` 字段——如果 hot-cache 中有活跃项目，memory-management 在 ingest 时自动为缺少 `project` 的新文件补充标注。

---

## 5. 操作定义

### 5.1 Ingest (编译)

**分级确认模型**：

| 操作 | 风险级别 | 确认方式 | 理由 |
|------|----------|----------|------|
| 刷新 index.md | 低 | **自动执行** | index 是可完全重建的派生物，写错了重新生成即可 |
| 创建/更新编译页面 | 中 | **展示摘要后确认** | 编译页面包含 LLM 推断的综合结论，可能引入错误 |
| 删除 wiki 页面 | 高 | **逐项确认** | 防止误删 |

**自动刷新触发条件** (Phase 1):

| 触发点 | 行为 |
|--------|------|
| 任意技能写入 WARM 文件后 (PostToolUse) | 静默更新 index.md，不打断用户工作流 |
| SessionStart 检测到 index.md 的 `last_compiled` 超过 24 小时 | 在 session 开头自动刷新 |
| 用户手动说"刷新 wiki 索引" | 立即刷新 |

**Phase 2 编译页面确认流程**:

```
LLM: 我准备更新以下 wiki 编译页面：
     - wiki/acme-q2/acme-corp.md — 新增 DR 变化记录 (68→72)
     - wiki/acme-q2/best-crm-software.md — 更新竞品排名数据
     要继续吗？
User: yes
LLM: [执行写入]
```

可通过配置开关 `wiki_confirm: false` 切换为全自动模式 (Phase 2)。

### 5.2 Query (查询)

用户提出跨技能问题时：

1. LLM 读取当前项目的 `memory/wiki/<project>/index.md` (或全局 index.md)
2. 通过 index 中的结构化字段定位相关 WARM 文件
3. 读取 WARM 文件，综合回答

**回答呈现规范** (面向所有用户层级):

- 结论先行，不要以"根据 memory/audits/content/homepage.md 文件显示..."开头
- 使用自然语言而非技术术语：说"你的首页有两个需要修复的问题"而非"CORE-EEAT T04 和 C01 两项 veto 未通过"
- 技术细节以折叠区呈现，不强制轻度用户阅读
- 以"建议下一步"结尾，引导用户行动

**Query-to-wiki (Phase 2+)**: 有价值的综合回答可归档为新编译页面 (需用户确认)。

### 5.3 Lint (健康检查)

| 阶段 | 触发 | 检查项 |
|------|------|--------|
| Phase 1 | index.md 刷新时自动执行 | 缺少 frontmatter 的 WARM 文件; mtime 超过 90 天; 缺少 `project` 标注的文件 |
| Phase 2 | `/seo:wiki-lint` 手动命令 | + 矛盾检测; 孤儿页; 缺失页; HOT 漂移; 陈旧引用; source hash 不一致 |
| Phase 3 | 可配置定期执行 | + 跨项目重复检测; WARM 退役候选 |

**矛盾解决策略** (Phase 2):

- 时间序列数据 (如 DR 值)：采用最新值，旧值保留为 changelog。置信度: **HIGH** (规则确定)
- 判断分歧 (如"速度正常" vs "CWV 退化")：触发 reconciliation prompt，LLM 裁定并记录理由。置信度: **MEDIUM** 或 **LOW** (由 LLM 自评)
- 解决结果写入编译页面，不修改 WARM 源文件
- 每条裁定附带 `confidence: HIGH | MEDIUM | LOW` 标注。`LOW` 置信度的裁定在编译页面中标记为 `[待确认]`，lint 会持续提醒直到用户手动确认或提供新证据

---

## 6. 页面格式

### 6.1 index.md — 结构化索引 (Phase 1)

```markdown
---
name: wiki-index
type: index
project: acme-campaign-q2
last_compiled: 2026-04-05T14:30:00+08:00
source_count: 23
---

# Acme Q2 Campaign — Wiki Index

> 自动编译自 memory/ 目录。删除 memory/wiki/ 可安全回退。

## Research

| 文件 | 摘要 | 分数 | 健康度 | 状态 | 下一步 | 更新日期 | mtime |
|------|------|------|--------|------|--------|----------|-------|
| `memory/research/keywords/hero-kws.md` | 10 个核心关键词, KD 25-45 | — | — | DONE | 启动内容创作 | 2026-03-15 | 1710489600 |
| `memory/research/competitors/acme.md` | Acme Corp, DR 72, 差距 12 条 | — | — | DONE_WITH_CONCERNS | 反向链接分析 | 2026-03-20 | 1710921600 |

## Audits

| 文件 | 摘要 | 分数 | 健康度 | 状态 | 下一步 | 更新日期 | mtime |
|------|------|------|--------|------|--------|----------|-------|
| `memory/audits/content/homepage.md` | 首页内容审计 | EEAT 72 | 需改进 | FIX (2 veto) | 修复 T04, C01 | 2026-04-01 | 1711929600 |
| `memory/audits/technical/cwv.md` | Core Web Vitals | CWV 65 | 需改进 | FIX (LCP) | 优化 LCP 至 <2.5s | 2026-04-03 | 1712102400 |
| `memory/audits/domain/cite.md` | 域名权威评估 | CITE 58 | 紧急 | CAUTIOUS | 增加权威引用 | 2026-03-25 | 1711324800 |

## Content

| 文件 | 摘要 | 分数 | 健康度 | 状态 | 下一步 | 更新日期 | mtime |
|------|------|------|--------|------|--------|----------|-------|
| `memory/content/briefs/crm-guide.md` | CRM 选购指南 brief | — | — | DONE | 进入内容写作 | 2026-03-28 | 1711584000 |

## Monitoring

| 文件 | 摘要 | 分数 | 健康度 | 状态 | 下一步 | 更新日期 | mtime |
|------|------|------|--------|------|--------|----------|-------|
| `memory/monitoring/rank-history/apr.md` | 8/10 核心词排名上升 | — | — | DONE | 持续监控 | 2026-04-03 | 1712102400 |

---

### Quick Status

- **待处理**: 2 项审计 veto (T04, C01), LCP 优化
- **进行中**: CRM 选购指南内容创作
- **已完成**: 关键词研究, 竞品分析, 排名追踪

### 变更记录 (最近 5 次刷新)

| 时间 | 变更 |
|------|------|
| 2026-04-05 14:30 | +1 新文件 (rank-history/apr.md), ~1 更新 (cwv.md) |
| 2026-04-03 09:15 | +2 新文件 (cwv.md, cite.md) |
| 2026-04-01 16:00 | +1 新文件 (homepage.md) |

---
文件总数: 23 | 健康检查: 缺少 frontmatter 1 个, 超过 90 天 0 个
```

**字段说明**:

| 字段 | 来源 | 用途 |
|------|------|------|
| `摘要` | LLM 从 WARM 文件内容推断 (≤15 字) | 快速扫描 | **Best-effort** — 允许措辞差异，不作为决策依据 |
| `分数` | 从 WARM 文件中提取的 CORE-EEAT/CITE/CWV 等评分 | 跨页面对比 | **精确** — 直接提取，不推断 |
| `健康度` | 由分数映射: ≥80 良好 / 60-79 需改进 / <60 紧急 / 无分数 — | 非技术用户可读性 | **精确** — 规则映射，无 LLM 推断 |
| `状态` | 从 handoff summary 的 Status 字段提取 | 快速判断进度 | **精确** — 直接提取 |
| `下一步` | 从 handoff summary 的 Next Skill 或 Open Loops 提取 | "接着干什么" | **精确** — 直接提取 |
| `更新日期` | WARM 文件 frontmatter 或内容中的日期 | 时间线排序 | **精确** — 直接提取 |
| `mtime` | 文件系统修改时间 (Unix timestamp) | 新鲜度校验 | **精确** — 系统读取 |

**精确度分级**: 结构化字段 (分数、健康度、状态、下一步、更新日期、mtime) 为**精确字段**，从源文件直接提取或规则映射，保证幂等性。摘要为 **best-effort 字段**，由 LLM 推断生成，允许措辞差异，不作为自动化决策依据。这一分级确保 index.md 的核心功能 (定位、筛选、排序) 不受 LLM 非确定性影响。

**Quick Status 部分**: 从 index 表格中自动汇总，给轻度用户 (王芳) 一个 3 秒可读的全局概览。

**变更记录**: 每次刷新 index.md 时自动追加一条 diff 摘要 (James 的增量视图需求)。保留最近 5 条，更早的在 Phase 2 归入 log.md。

### 6.2 编译页面 (Phase 2)

```markdown
---
name: competitor-acme-corp
type: entity
project: acme-campaign-q2
sources:
  - path: memory/research/competitors/acme.md
    hash: a1b2c3d4
  - path: memory/audits/domain/acme-cite.md
    hash: e5f6g7h8
last_compiled: 2026-04-05
---

# Acme Corp

## Profile
- 域名权威: DR 72 (2026-03-20) ← DR 68 (2026-01-15)
- 主要内容策略: 长文 SEO + 产品对比页
- 与我们的关键词重叠: 34 个

## Keyword Overlap
→ [best crm software](best-crm-software.md) | → [crm comparison 2026](crm-comparison-2026.md)

## Audit History

| 日期 | 维度 | 发现 | 源文件 |
|------|------|------|--------|
| 2026-04-01 | 域名权威 (CITE) | CITE 58, CAUTIOUS | `memory/audits/domain/cite.md` |
| 2026-03-20 | 竞品分析 | DR 72, 内容差距 12 条 | `memory/research/competitors/acme.md` |

## Open Questions
- [ ] 反向链接分析未完成
- [ ] 社交媒体影响力待评估
```

**`sources.hash`**: WARM 文件内容前 8 位 SHA-256。Lint 时对比当前 hash 与记录 hash，不一致则标记为待重新编译。

### 6.3 log.md (Phase 2)

```markdown
# Wiki Log

## [2026-04-05 14:30] ingest | acme-campaign-q2
- index.md 刷新: +1 新文件, ~1 更新
- 编译页面: acme-corp.md 更新 (DR 变化记录)
- 矛盾标记: "速度正常" (Jan) vs "CWV 退化" (Mar) → 已解决, 采用最新数据

## [2026-04-03 09:15] ingest | acme-campaign-q2
- index.md 刷新: +2 新文件 (cwv.md, cite.md)

## [2026-04-01 16:00] lint | acme-campaign-q2
- 孤儿页: 0
- 矛盾: 1 (速度评估, 待解决)
- 缺失页: 建议创建 Acme Corp entity 页面
```

可用 grep 解析: `grep "^## \[" memory/wiki/log.md | tail -5`

---

## 7. 面向不同用户层级的体验设计

### 7.1 轻度用户 (王芳)

**目标**: 无需了解 wiki 架构，通过主动引导自然受益。

**SessionStart 主动引导** (基于 index.md Quick Status):

```
你好！根据上次的工作记录：
- 你已经完成了关键词研究，找到了 10 个目标关键词
- 建议下一步：为"手工陶瓷茶壶"这个关键词写一篇产品页内容
  → 要开始吗？
```

**触发条件**: hot-cache 中有活跃项目 + index.md 中存在 `状态: DONE` 且 `下一步` 非空的条目。

**呈现规范**:
- 不出现 "wiki"、"index"、"WARM"、"ingest" 等术语
- 用"上次的工作记录"代替"根据 memory/wiki/index.md"
- 用"你的页面有 2 个需要修复的问题"代替"CORE-EEAT T04, C01 veto"
- 用"建议下一步"代替"Recommended Next Skill: content-refresher"

### 7.2 中度用户 (Sarah)

**目标**: 通过结构化分数数据支持月度汇报。

**审计看板视图** (从 index.md `分数` 列生成):

```
📊 内容审计汇总 (Acme Q2 Campaign)

| 页面 | EEAT | CITE | 健康度 | 趋势 | 上次审计 |
|------|------|------|--------|------|----------|
| 首页 | 72 | 58 | 需改进 | — | 2026-04-01 |
| CRM 指南 | — | — | 未审计 | — | — |
| 产品页 | 81 | 63 | 良好 | ↑ (+5) | 2026-03-28 |

待修复: 2 项 veto (首页 T04, C01)
紧急: 域名权威 CITE 58 分
```

**触发**: 用户问"审计状况怎么样"、"给我看分数"、"帮我准备月度报告"等。

### 7.3 重度用户 (李明, James)

**目标**: 快速上下文恢复 + 综合报告生成。

**项目切换体验**:

```
User: 切换到 Acme 项目
LLM: [加载 memory/wiki/acme-campaign-q2/index.md]

已切换到 Acme Q2 Campaign。项目状态:
- 待处理: 2 项审计 veto, LCP 优化
- 进行中: CRM 选购指南内容创作
- 上次活动: 2026-04-03 (排名追踪更新)

要从哪里继续？
```

**综合报告生成** (Phase 2):

```
User: 帮我生成 Acme 站点的综合审计报告
LLM: [读取项目 index.md → 定位所有 audits 类 WARM 文件 → 读取 → 编译]

生成报告包含以下维度:
- 技术 SEO: CWV 65, LCP 需优化
- 内容质量: EEAT 72, 2 项否决
- 域名权威: CITE 58, 建议增加引用
- 内链优化: 47 个孤儿页
- Schema 覆盖: 32%

要以什么格式输出？(Markdown / 客户报告模板 / 数据表格)
```

---

## 8. 与现有系统的集成

### 8.1 Hook 变更

| Hook | 当前行为 | Phase 1 变更 | Phase 2 变更 |
|------|----------|-------------|-------------|
| **SessionStart** | 加载 hot-cache; 检查 open-loops | + 加载项目级 index.md (若存在); + 轻度用户主动引导 (基于 Quick Status) | 不变 |
| **PostToolUse** | 推荐 content-quality-auditor | + WARM 写入后**静默刷新** index.md | + 提示"要更新编译页面吗？" |
| **Stop** | 保存否决项; 提示保存 | + 追加变更记录到 index.md 底部 | + 追加到 log.md |
| **FileChanged** | 监控 hot-cache.md | 不变 | 不变 |

**关键变更**: PostToolUse 自动刷新 index.md 是 v3 最重要的改动。index.md 是纯派生物 (可完全从 WARM 文件重建)，写错了无副作用，因此不需要用户确认。这解决了 4/4 用户反馈的"手动触发 = 不会触发"问题。

### 8.2 Skill Contract 影响

**Phase 1: 零变更。**

16 个执行技能不做任何修改。memory-management 新增一个操作。

**Phase 2 (可选增强)**:

skill-contract.md 的 Writes 部分增加可选字段：

```
Writes: deliverable + handoff summary [+ optional wiki hints]
```

Wiki hints 格式 (在 handoff summary 中，可见字段，非 HTML 注释):

```markdown
### Handoff Summary

- **Status**: DONE
- **Wiki Entities**: [Acme Corp]
- **Wiki Keywords**: [best crm software, crm comparison]
```

不发出 hints 的技能照常工作——memory-management 通过扫描目录自行检测变更。

### 8.3 memory-management 变更

新增操作:

```
8. Wiki Index 维护
   - 自动: PostToolUse 后静默刷新 index.md
   - 手动: "刷新 wiki 索引" / "build wiki index"
   - 项目切换: 根据 hot-cache project 字段加载对应 index
```

触发短语 (多语言):
- EN: "refresh wiki index", "build wiki", "project status"
- ZH: "刷新 wiki 索引", "生成索引", "项目状况"
- JA: "wikiインデックスを更新", "プロジェクト状況"
- KO: "위키 인덱스 새로고침", "프로젝트 상태"

### 8.4 state-model.md 变更

在 WARM 小节之后新增：

```markdown
### WIKI 编译视图 — `memory/wiki/`

- 性质: WARM 文件的只读编译索引和综合页面
- 项目隔离: `memory/wiki/<project>/index.md` 按 hot-cache project 字段分区
- 自动加载: SessionStart 加载当前项目的 index.md (不存在则跳过)
- 自动刷新: PostToolUse 后静默更新 index.md (低风险，可完全重建)
- 写入者: 仅 memory-management 技能
- 回退: 删除 memory/wiki/ 即回到无 wiki 状态，零副作用
- 不参与晋升/降级生命周期
```

### 8.5 迁移

**v6.2.0 → v6.3.0 (Phase 1)**:

1. 用户无需做任何操作
2. `memory/wiki/` 在首次 PostToolUse 后自动创建
3. `memory/wiki/index.md` 不存在时，SessionStart 静默跳过
4. 无数据迁移，无文件重命名，无目录重组
5. 已有 WARM 文件无需增加 `project` 字段——未标注的文件归入全局索引

**v6.3.0 → v6.4.0 (Phase 2)**:

1. 已有 index.md 自动兼容
2. 编译页面为新增功能，不影响已有 index
3. log.md 从空文件开始

---

## 9. 容量规则

| 文件 | 限制 | 理由 |
|------|------|------|
| 项目级 `index.md` | 200 行 | 单项目范围，200 行足够 |
| 全局 `index.md` | 300 行 | 多项目汇总，需更大空间 |
| 变更记录 (index 底部) | 5 条 | 更早的在 Phase 2 归入 log.md |
| `log.md` (Phase 2) | 500 行 | 超过 500 行时，最早的条目按年归档到 `log-archive/YYYY.md`; 归档文件无上限，按年分割; 归档操作由 memory-management 在 lint 时自动执行 |
| 编译页面 (Phase 2) | 200 行/页 | 与 WARM 文件限制一致 |
| 单项目编译页面总数 | 无硬性限制 | index.md 是瓶颈；通过 lint 清理孤儿页 |

---

## 10. 手动回退方案

在任何阶段：

```bash
rm -rf memory/wiki/
```

**回退后的行为**:

- SessionStart 检测到 index.md 不存在，静默跳过，零报错
- PostToolUse 检测到 `memory/wiki/` 不存在，跳过刷新，零报错
- 所有 WARM 文件完好无损 (wiki 从未修改它们)
- HOT cache 完好无损
- 16 个执行技能行为不变
- memory-management 的现有功能不变
- 唯一丢失的是编译索引——下次 PostToolUse 或手动触发时自动重建

**此回退方案在所有阶段保持有效。** 如果某个功能导致回退不干净，该功能必须提供降级路径。

---

## 11. 实施计划

### Phase 1 — 结构化索引 + 自动刷新 (v6.3.0)

**目标**: 证明自动维护的 WARM 文件索引能改善跨技能上下文获取和用户引导。

**交付物**:

| # | 交付项 | 涉及文件 |
|---|--------|---------|
| 1 | memory-management 新增 "wiki index 维护" 操作 | `cross-cutting/memory-management/SKILL.md` |
| 2 | index.md 格式定义 (含 score、status、next_action、mtime、Quick Status、变更记录) | `references/state-model.md` |
| 3 | PostToolUse hook: WARM 写入后静默刷新 index.md | `hooks/hooks.json` |
| 4 | SessionStart hook: 加载项目级 index.md + 轻度用户主动引导 | `hooks/hooks.json` |
| 5 | 项目隔离: 按 hot-cache project 字段分区 index | `references/state-model.md` |
| 6 | 回答呈现规范: 结论先行、自然语言、折叠技术细节 | `references/skill-contract.md` (附录) |

**不包含**: 编译页面、log.md、`/seo:wiki-lint` 命令、ingest signal、任何执行技能改动。

**评估门槛 (进入 Phase 2 的条件)**:
- [ ] 跨技能查询 ("我们对 Competitor X 了解多少") 回答质量有可感知提升
- [ ] 多项目用户切换项目后，上下文恢复时间从 15-20 分钟降到 5 分钟以内
- [ ] 轻度用户的 SessionStart 引导被实际使用 (非关闭/跳过)
- [ ] 不使用 wiki 的用户体验零退化
- [ ] index.md 自动刷新未产生用户投诉的错误

### Phase 2 — 编译页面 + Lint + 报告生成 (v6.4.0)

**前提**: Phase 1 评估门槛全部达标。

**交付物**:

| # | 交付项 | 涉及文件 |
|---|--------|---------|
| 1 | 编译页面: entity / keyword / topic 类型 | `memory-management/SKILL.md` |
| 2 | 自定义聚合维度: 支持按站点/审计类型/时间段编译 | `memory-management/SKILL.md` |
| 3 | Source hash (SHA-256 前 8 位) 写入编译页面 frontmatter | 编译页面格式规范 |
| 4 | `/seo:wiki-lint` 命令: 矛盾检测、孤儿页、陈旧引用、缺失页、hash 不一致 | 新增 command |
| 5 | log.md 追加式时间线 | `references/state-model.md` |
| 6 | PostToolUse: WARM 写入后提示"要更新编译页面吗？" | `hooks/hooks.json` |
| 7 | Stop hook: 追加会话活动到 log.md | `hooks/hooks.json` |
| 8 | 配置开关 `wiki_confirm`: true (默认) / false | `memory-management/SKILL.md` |
| 9 | skill-contract.md: 可选 wiki hints 字段 | `references/skill-contract.md` |
| 10 | 综合报告生成: 用户可按维度聚合审计结果输出客户报告 | `memory-management/SKILL.md` |
| 11 | Query-to-wiki: 有价值的综合回答归档为新编译页面 (需确认) | `memory-management/SKILL.md` |

**评估门槛 (进入 Phase 3 的条件)**:
- [ ] lint 可靠检测手工构造的矛盾测试用例
- [ ] 编译页面被用户实际查阅 (非仅 LLM 读取)
- [ ] source hash 不一致检测的误报率 < 5%
- [ ] 综合报告生成的输出被至少 3 个用户用于客户汇报

### Phase 3 — 技能集成与 WARM 退役评估 (v6.5.0+)

**前提**: Phase 2 评估门槛全部达标。

**交付物**:

| # | 交付项 |
|---|--------|
| 1 | 技能 Reads 部分可选增加 `memory/wiki/` 路径 |
| 2 | comparisons/ 和 synthesis/ 页面类型 |
| 3 | WARM ��役 dry-run 模式: `wiki-lint --retire-preview` 输出退役候选列表但不执行任何归档，用户确认后才执行实际退役操作 |
| 4 | WARM 部分路径退役执行: wiki 完全覆盖某 WARM 类别 + dry-run 通过用户确认后，该类别归档到 COLD |
| 5 | 定期 lint: 可配置自动执行频率 |
| 6 | 跨项目分析: 全局 index 支持跨项目对比 |

**此阶段为探索性质**，不预设交付日期。

---

## 12. 不变的部分

| 组件 | 状态 |
|------|------|
| HOT/WARM/COLD 温度生命周期 | 不变 |
| 16 个执行技能的 SKILL.md | Phase 1-2 不变。Phase 3 可选增强 |
| 4 个协议层技能的角色定义 | 不变 |
| CORE-EEAT 和 CITE 评分框架 | 不变 |
| 工具连接器占位模式 (~~category) | 不变 |
| Handoff summary 格式 | 不变 (Phase 2 增加可选字段) |
| 否决项自动写入 HOT | 不变 |
| `memory/` 下所有现有子目录 | 不变 |
| CONTRIBUTING.md 贡献流程 | Phase 1 不变 |

---

## 13. 成功标准

| # | 标准 | 阶段 | 对应用户 |
|---|------|------|----------|
| S1 | 跨技能查询获得综合回答，无需重新运行任何技能 | Phase 1 | 李明, James |
| S2 | 多项目用户切换项目后 5 分钟内进入工作状态 | Phase 1 | 李明 |
| S3 | 轻度用户通过 SessionStart 引导发现并使用新技能 | Phase 1 | 王芳 |
| S4 | 中度用户能快速获得跨页面审计分数对比 | Phase 1 | Sarah |
| S5 | index.md 作为战役知识库的可靠目录 | Phase 1 | 全体 |
| S6 | 一月与三月审计的矛盾被 lint 自动标记 | Phase 2 | James |
| S7 | 综合审计报告可在 2 分钟内生成 | Phase 2 | James |
| S8 | 删除 `memory/wiki/` 后系统行为回到 v6.2.0 | 所有 | 全体 |
| S9 | 不使用 wiki 的用户体验零退化 | 所有 | 全体 |

---

## 14. 验证策略

### 14.1 Phase 1 验证

**index.md 生成的确定性测试**:

由于 index.md 由 LLM 生成，存在非确定性。验证方法：

1. **结构验证**: index.md 必须通过格式校验——frontmatter 包含必需字段、表格列数正确、mtime 为有效 Unix 时间戳、Quick Status 部分存在
2. **完整性验证**: index.md 列出的文件数 = `memory/` 目录下含 frontmatter 的文件数
3. **新鲜度验证**: 每个条目的 mtime 字段 = 对应 WARM 文件的实际 mtime (误差 ≤1 秒)
4. **幂等性验证**: 对同一组 WARM 文件连续生成两次 index.md，**精确字段** (分数、健康度、状态、下一步、更新日期、mtime) 必须逐字一致；**best-effort 字段** (摘要) 允许措辞差异，不纳入自动化回归测试

**自动刷新验证**:

1. 写入一个 WARM 文件后，index.md 的 `source_count` 和 `last_compiled` 更新
2. 删除 `memory/wiki/` 后写入 WARM 文件，`memory/wiki/` 自动重建
3. `memory/wiki/` 不存在时 SessionStart 零报错

**项目隔离验证**:

1. hot-cache 设置 `project: A` 后生成索引，index 只包含 `project: A` 的文件
2. 切换 `project: B` 后生成索引，index 只包含 `project: B` 的文件
3. 无 `project` 字段的文件出现在全局 index 中

### 14.2 Phase 2 验证

**矛盾检测测试用例**:

准备一组测试 WARM 文件，其中包含已知矛盾 (如 DR 值不一致、速度评估冲突)。运行 lint，验证所有已知矛盾被标记。误报率 = 标记的非矛盾数 / 总标记数 < 5%。

**Source hash 验证**:

1. 生成编译页面，记录 source hash
2. 修改 WARM 源文件内容
3. 运行 lint，验证 hash 不一致被检测到
4. 不修改内容只 touch 文件 (改 mtime 不改内容)，lint 不应误报

**贡献者 PR 验证流程**:

- wiki 相关 PR 必须包含：(a) 测试 WARM 文件集 (b) 期望的 index/编译页面结构 (c) 验证脚本或 checklist
- 结构化字段 (分数、状态、hash) 可精确验证，摘要文本做语义审查

---

## 15. 风险与缓解

| 风险 | 缓解 |
|------|------|
| **Index 膨胀** — 多项目 + 大量 WARM 文件 | 项目隔离分散负载; 单项目 200 行上限; 全局 300 行上限 |
| **编译错误** — LLM 推断的摘要不准确 | 结构化字段 (分数、状态) 从源文件提取而非推断; 摘要为辅助; mtime/hash 可校验 |
| **自动刷新性能** — PostToolUse 后刷新增加延迟 | index.md 只涉及读 frontmatter + 写一个文件，通常 <3 秒; 如超时则静默跳过 |
| **项目归属误判** — WARM 文件缺少 project 字段 | memory-management 自动根据 hot-cache 活跃项目补充标注; 未标注文件归入全局 |
| **轻度用户被引导干扰** — SessionStart 引导过于频繁 | 引导仅在 index 中存在 next_action 非空条目时触发; 用户可说"不用了"关闭当次引导 |
| **级联错误** (Phase 2) | 用户确认编译页面写入; source hash 校验; 随时可删除重建; 源文件不可变 |
| **贡献者门槛** (Phase 2) | 验证策略明确; 结构化字段可精确测试; wiki 功能集中在 memory-management 一个技能内 |
| **终态目标漂移** | 每阶段设评估门槛; 不达标不推进; Phase 3 为探索性质 |
| **Token 开销累积** | index.md 约 4-6KB; 自动刷新读 frontmatter 非全文; SessionStart 仅加载一个 index |
