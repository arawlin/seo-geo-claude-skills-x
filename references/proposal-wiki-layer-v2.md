# 提案 v2: Wiki 知识层

**状态**: 评审稿 (基于 v1 圆桌评审修订)
**日期**: 2026-04-05
**灵感来源**: [Karpathy — LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
**评审团**: Karpathy, Peter (OpenClaw), Dario Amodei (Anthropic), Simon Willison

---

## 圆桌讨论记录

**参会者**: Karpathy (K), Peter / OpenClaw (P), Dario Amodei (D), Simon Willison (S)

---

**K**: 我看完了 v1 提案。说实话，方向是对的，但架构错了。你们搞了四层——HOT、WIKI、WARM、COLD。这完全违背了我写 LLM Wiki 的初衷。Wiki 的意义就是**替代**那些零散的 WARM 文件，把碎片知识编译成结构化的、互相链接的页面。你加一层在中间，只是增加了复杂度，没有减少。

**P**: 等一下，Andrej。你说"替代 WARM"——你知道现在有多少用户在用这套 HOT/WARM/COLD 模型吗？16 个执行技能全部在往 `memory/` 写文件。如果我们把 WARM 砍掉换成 wiki，那就是一个 breaking change，所有现有用户的 `memory/` 目录结构全部失效。

**K**: 我不是说第一天就砍掉。但设计目标应该是三层——HOT、WIKI、COLD。Wiki 是 WARM 的演进形态，不是在 WARM 上面再加一层。四层模型注定会让 LLM 困惑："这条信息我该写 wiki 还是写 WARM？"

**S**: 这个问题其实可以绕过去。Phase 1 不碰 WARM。让 wiki 作为 WARM 的**只读编译视图**——它读 WARM 文件，编译出交叉引用页面，但不修改、不替代任何 WARM 文件。技能还是照常写 `memory/`，wiki 在后面默默编译。这样 Peter 的 16 个技能一行代码都不用改。

**K**: 那我的"替代"目标怎么实现？

**S**: Phase 2 或 Phase 3。你先证明 wiki 有价值——用户在用 `wiki/index.md`，跨技能查询确实通过 wiki 得到了更好的回答——然后再讨论让技能直接写 wiki 而不是写 WARM。这是渐进式迁移，不是大爆炸。

**D**: 我想回到一个更基本的问题。v1 方案里，PostToolUse hook 在每次写 WARM 文件后自动触发 wiki ingest。这意味着 LLM 在没有用户确认的情况下，默默地创建和修改 wiki 页面。这是级联错误的温床。假设 keyword-research 写了一个有误的竞品分析，wiki 自动 ingest，更新了 entity 页面，污染了 index.md——用户完全不知道。

**K**: 但我的 wiki 模式就是 LLM 自动维护的。你让用户每次都确认，wiki 就死了——没人会每次 ingest 都点"确认"。

**D**: 不需要每次都阻塞。我的要求是：**写之前给用户一个摘要**。"我准备更新 wiki/entities/acme-corp.md，新增域名权威变化记录。要继续吗？"用户说 yes 或者直接回车就行。但不能完全静默。

**S**: 这个我可以接受。甚至可以更简单——用一个配置开关。`wiki_confirm: true` 是默认值，每次 ingest 前要确认；用户熟悉了之后可以改成 `wiki_confirm: false` 切换成自动模式。Dario 你能接受这个方案吗？

**D**: 可以，但我还有一个要求：source hashing。每个 wiki 页面的 frontmatter 里必须记录源文件的 hash。这样如果源文件被修改了但 wiki 页面没更新，lint 可以检测到不一致。这是确定性的基础。

**P**: 好，我们现在有三个共识在形成。一，Phase 1 不动执行技能；二，wiki 是 WARM 的只读编译视图；三，ingest 默认需要用户确认。让我加一条：wiki 必须是**可选的**。不能把它写进核心 skill contract。如果用户不想用 wiki，`memory-management` 的现有行为不能有任何变化。

**K**: 那怎么触发 ingest？v1 的方案是在 16 个技能里加 `<!-- wiki-ingest -->` 信号。如果不改技能……

**S**: `memory-management` 自己就能做。它已经知道 `memory/` 目录结构。Ingest 操作就是：扫描 `memory/` 下所有文件，跟 `wiki/index.md` 对比，找到新增或更新的 WARM 文件，然后编译到 wiki。不需要任何 ingest signal。

**P**: 这样 16 个技能完全不用改。太好了。

**K**: 但这意味着你失去了结构化的元数据——哪些 entities、keywords、topics 跟这个 WARM 文件相关。LLM 要自己去推断。

**S**: 对，Phase 1 就让 LLM 推断。WARM 文件本身就有 frontmatter 里的 `name`、`description`、`type`。够用了。如果以后发现推断质量不够，Phase 2 再加 ingest signal——那是优化，不是必需品。

**D**: 我同意 Simon 的方向。最小可行方案。Phase 1 到底包含什么？

**S**: 就一个东西：**`wiki/index.md`**。一个自动生成的、按类别组织的 WARM 文件索引。每个条目包含文件路径、一行摘要、最后更新日期。SessionStart hook 加载它。就这样。不要 entity 页面，不要 topics 页面，不要 log.md，不要 lint 命令。先证明一个好的索引就能显著改善跨技能查询。

**K**: 只有 index.md？这离 wiki 差太远了。

**S**: 这是 wiki 的第一步。index.md 是 wiki 的脊椎。如果连索引都不能证明价值，那更复杂的编译页面也不会有价值。而且实现成本极低——只改 `memory-management` 的一个操作，加一条 SessionStart hook。两天就能做完。

**P**: 我很喜欢这个方案。发布成本低，回退成本也低——如果 index.md 出问题，用户删掉 `wiki/` 目录就行，系统回到完全一样的状态。

**D**: 回退方案是刚才最好的一句话。必须写进提案：**任何时候用户都可以删除 `wiki/` 目录，系统行为回到 v6.2.0 完全一致的状态**。这是安全底线。

**K**: 好吧，我接受 Phase 1 只做 index.md。但提案里必须明确 Phase 2 的目标是**编译页面**——entities、keywords、topics——以及 Phase 3 的目标是开始从 wiki 替代部分 WARM 功能。我要看到路线图，不只是一个索引。

**S**: 完全同意。Phase 1 是 index.md + 手动 ingest。Phase 2 是编译页面 + lint + 确认式自动 ingest。Phase 3 是技能直接读 wiki 代替读 WARM。每个 Phase 之间有明确的评估门槛。

**P**: 目录位置呢？v1 放在项目根目录的 `wiki/`。我倾向 `memory/wiki/`，因为这样它在 memory 的命名空间里，不会跟用户自己的项目文件冲突。

**K**: 不，wiki 应该是顶层的。它不是 memory 的子集——它是 memory 的编译产物。放在 `memory/wiki/` 暗示它是 WARM 的一部分。

**S**: 实际上我觉得 `memory/wiki/` 更安全。原因：`.gitignore` 通常已经忽略了 `memory/`。如果 wiki 在根目录，用户需要额外配置 gitignore。而且 `memory/` 已经是"LLM 管理的状态空间"的惯例。

**D**: 从安全角度，`memory/wiki/` 也更好。它明确属于 LLM 管理的区域，用户不会误以为这是他们需要手动维护的项目文件。

**K**: ……好吧。我能接受 `memory/wiki/`，但路线图里 Phase 3 可以讨论把它提升到根目录。

**P**: 最后一个问题：lint。Phase 1 需要 lint 吗？

**S**: Phase 1 不需要 `/seo:wiki-lint` 命令。但 `memory-management` 在生成 index.md 的时候，可以顺便做两个简单检查：一是有没有 WARM 文件缺少 frontmatter；二是有没有 WARM 文件超过 90 天没更新。这些已经在 memory-management 的现有职责范围内，不算新功能。

**D**: 把这个叫做"索引健康检查"而不是"lint"。Lint 是 Phase 2 的名字。

**K**: 行。我总结一下我听到的共识：Phase 1——`memory/wiki/index.md`，手动触发，用户确认，零技能改动，随时可删。Phase 2——编译页面、source hash、lint、confirm-or-auto 开关。Phase 3——技能开始读 wiki，逐步退役部分 WARM 路径。三层模型是终态目标，但不是 Phase 1 的要求。

**S**: 完美。

**P**: 我签字。

**D**: 加上"wiki 操作永远不删除 WARM 源文件"，我就同意。

**K**: 同意。Wiki 是编译产物，源文件不可动。这是基本原则。

---

## 1. 背景与动机

当前记忆系统 (HOT/WARM/COLD) 是生命周期管理的缓存。每个技能独立写入 `memory/` 子目录，晋升/降级规则按引用频率运作。这在检索层面有效，但存在三个缺口：

1. **无综合层**: 运行 keyword-research、competitor-analysis、serp-analysis 会产生三份独立文件。没有制品能将它们合并成一幅演进中的全景。
2. **无矛盾检测**: 一月审计可能说"网站速度正常"，三月 technical-seo-checker 发现 Core Web Vitals 退化。两份文件共存于 `memory/audits/` 而无机制标记冲突。
3. **无可导航索引**: hot-cache (80 行) 能容纳约 15 条指针。一个包含 50+ 关键词、5 个竞品、数月审计的战役很快超出其容量。技能必须猜测加载哪些 WARM 文件——或者不加载而丢失上下文。

v1 提案建议在 HOT 和 WARM 之间插入一个独立 wiki 层。圆桌评审后，v2 做了以下关键调整：

- Wiki 定位为 WARM 的**只读编译视图**，而非独立层级
- Phase 1 缩减到仅 `index.md`，零技能改动
- 默认需要用户确认，不允许静默修改
- 随时可删除回退

---

## 2. 核心设计原则

| 编号 | 原则 | 来源 |
|------|------|------|
| P1 | **编译而非复制** — wiki 是 WARM 文件的编译产物，不存储原始数据 | Karpathy |
| P2 | **零技能侵入** — 16 个执行技能的 SKILL.md 和写入路径不做任何修改 | Peter |
| P3 | **用户可见性** — wiki 操作默认在写入前向用户展示摘要并获得确认 | Dario |
| P4 | **增量证明** — 每个阶段必须证明价值后才启动下一阶段 | Simon |
| P5 | **安全回退** — 删除 `memory/wiki/` 目录即可回到 v6.2.0 完全一致的行为 | 全体共识 |
| P6 | **源文件不可变** — wiki 操作永远不修改、不删除 WARM 源文件 | 全体共识 |
| P7 | **三层为终态** — 长期目标是 HOT/WIKI/COLD 三层模型，但通过渐进式迁移实现，不强制于 Phase 1 | Karpathy + Simon |

---

## 3. 架构

### 3.1 Phase 1 架构 (当前层模型不变)

```
┌─────────────────────────────────────────────────────────┐
│  HOT    memory/hot-cache.md   (80 行, 自动加载)          │
├─────────────────────────────────────────────────────────┤
│  WARM   memory/<category>/    (按技能/类别, 按需加载)     │
│    └── wiki/                  (编译视图, 只读)     [新增] │
├─────────────────────────────────────────────────────────┤
│  COLD   memory/archive/       (按日期, 仅查询)           │
└─────────────────────────────────────────────────────────┘
```

Wiki 位于 `memory/wiki/`，**逻辑上是 WARM 的派生层**，而非独立温度层。它读取 WARM 文件并生成编译索引。WARM 的现有生命周期规则 (晋升、降级、归档) 完全不变。

### 3.2 终态架构 (Phase 3+，待评估)

```
┌─────────────────────────────────────────────────────────┐
│  HOT    memory/hot-cache.md   (80 行, 自动加载)          │
├─────────────────────────────────────────────────────────┤
│  WIKI   memory/wiki/          (编译, 互链, 按需加载)      │
├─────────────────────────────────────────────────────────┤
│  COLD   memory/archive/       (按日期, 仅查询)           │
└─────────────────────────────────────────────────────────┘
```

终态中，wiki 吸收当前 WARM 的核心功能，技能直接向 wiki 页面贡献结构化结论。原始 WARM 文件归入 COLD 或由 wiki 页面的 `sources` 字段引用。此架构需在 Phase 2 证明 wiki 价值后方可推进。

---

## 4. 目录结构

### Phase 1 (最小)

```
memory/
└── wiki/
    └── index.md
```

### Phase 2 (编译页面)

```
memory/
└── wiki/
    ├── index.md
    ├── log.md
    ├── entities/
    ├── keywords/
    └── topics/
```

### Phase 3 (扩展)

```
memory/
└── wiki/
    ├── index.md
    ├── log.md
    ├── entities/
    ├── keywords/
    ├── topics/
    ├── comparisons/
    └── synthesis/
```

子目录不预先创建——页面平铺在 `memory/wiki/` 根目录，超过 30 页后再按 `type` frontmatter 拆分子目录。

---

## 5. 操作定义

### 5.1 Ingest (编译)

| 属性 | Phase 1 | Phase 2+ |
|------|---------|----------|
| **触发方式** | 用户手动调用 memory-management | 用户手动 + PostToolUse hook 推荐 (需确认) |
| **输入** | 扫描 `memory/` 目录下所有含 frontmatter 的文件 | 同左 + 技能可选的 ingest signal |
| **输出** | 更新 `memory/wiki/index.md` | 更新 index.md + 相关编译页面 + log.md |
| **用户确认** | 默认: 写入前展示变更摘要 | 可配置: `wiki_confirm: true` (默认) / `false` |
| **源文件影响** | 无 (只读) | 无 (只读) |

**用户确认流程** (Phase 1):

```
LLM: 我扫描了 memory/ 目录，发现 3 个新文件、2 个更新文件。
     准备更新 wiki/index.md，新增 5 个条目。要继续吗？
User: yes
LLM: [执行写入]
```

### 5.2 Query (查询)

用户提出跨技能问题时，LLM 先读取 `memory/wiki/index.md` 定位相关 WARM 文件，再读取这些文件综合回答。

Phase 1 中 query 不产生新 wiki 页面。Phase 2+ 中，有价值的查询回答可以作为新页面归档回 wiki。

### 5.3 Lint (健康检查)

| 属性 | Phase 1 | Phase 2+ |
|------|---------|----------|
| **名称** | 索引健康检查 (index.md 生成时顺便执行) | `/seo:wiki-lint` 命令 |
| **检查项** | 缺少 frontmatter 的 WARM 文件; >90 天未更新的 WARM 文件 | + 矛盾检测; 孤儿页; 缺失页; HOT 漂移; 陈旧引用 |
| **输出** | 终端内提示 | 结构化报告 + log.md 记录 |

**Phase 2 矛盾解决策略**:
- 同一实体的时间序列数据 (如 DR 值)：默认采用最新值，旧值保留为 changelog
- 两个技能对同一判断有分歧：触发 reconciliation prompt，LLM 做出裁定并记录理由
- 解决结果写入编译页面，不修改 WARM 源文件

---

## 6. 页面格式

### 6.1 index.md (Phase 1)

```markdown
---
name: wiki-index
type: index
last_compiled: 2026-04-05
source_count: 47
---

# Wiki Index

> 自动编译自 memory/ 目录。不要手动编辑此文件。
> 删除 memory/wiki/ 目录可安全回退到 v6.2.0 行为。

## Research
| 文件 | 摘要 | 更新日期 |
|------|------|----------|
| `memory/research/keywords/hero-kws.md` | 10 个核心关键词，KD 25-45 | 2026-03-15 |
| `memory/research/competitors/acme.md` | Acme Corp, DR 72, 内容差距 12 条 | 2026-03-20 |

## Audits
| 文件 | 摘要 | 更新日期 |
|------|------|----------|
| `memory/audits/content/homepage.md` | CORE-EEAT 72/100, 2 项否决 | 2026-04-01 |

## Monitoring
| 文件 | 摘要 | 更新日期 |
|------|------|----------|
| `memory/monitoring/rank-history/ranks.md` | 8/10 核心词排名上升 | 2026-04-03 |

## Entities
| 文件 | 摘要 | 更新日期 |
|------|------|----------|
| `memory/entities/acme-corp.md` | 主竞品, DR 72 | 2026-03-20 |

---
文件总数: 47 | 缺少 frontmatter: 3 | 超过 90 天未更新: 2
```

### 6.2 编译页面格式 (Phase 2+)

```markdown
---
name: competitor-acme-corp
type: entity
sources:
  - path: memory/research/competitors/acme.md
    hash: a1b2c3d4
  - path: memory/audits/domain/acme-cite.md
    hash: e5f6g7h8
last_compiled: 2026-04-05
---

# Acme Corp

## Profile
...

## Keyword Overlap
<!-- 交叉引用 wiki/keywords/ 页面 -->

## Audit History
<!-- 链接到有日期的审计摘要 -->

## Open Questions
- [ ] 反向链接分析未完成 (见 memory/open-loops.md#acme-backlinks)
```

**`sources.hash`**: WARM 文件内容的前 8 位 SHA-256。Lint 时对比当前文件 hash 与记录 hash，不一致则标记为需要重新编译。

---

## 7. 与现有系统的集成

### 7.1 Hook 变更

| Hook | 当前行为 | Phase 1 变更 |
|------|----------|-------------|
| **SessionStart** | 加载 hot-cache.md; 检查 open-loops | **新增**: 若 `memory/wiki/index.md` 存在，静默加载。不存在则跳过，零报错 |
| **PostToolUse** | 推荐 content-quality-auditor | **Phase 1 无变更**。Phase 2: 检测到 WARM 写入后提示"要更新 wiki 吗？" |
| **Stop** | 保存否决项; 提示保存结果 | **Phase 1 无变更**。Phase 2: 追加会话活动到 `wiki/log.md` |
| **FileChanged** | 监控 hot-cache.md | **Phase 1 无变更** |

### 7.2 Skill Contract 影响

**Phase 1: 零变更。** skill-contract.md 不做任何修改。16 个执行技能不做任何修改。

**Phase 2 (可选增强)**: skill-contract.md 的 "Writes" 部分增加可选字段：

```
Writes: deliverable + handoff summary [+ optional wiki ingest signal]
```

Ingest signal 格式采用 handoff summary 中的**可见字段** (非 HTML 注释)：

```markdown
### Handoff Summary

- **Status**: DONE
- **Wiki Entities**: [Acme Corp]
- **Wiki Keywords**: [best crm software, crm comparison]
```

此信号为**可选的**。不发出信号的技能照常工作——`memory-management` 通过扫描 `memory/` 目录自行检测变更。

### 7.3 memory-management 变更

新增一条操作:

```
8. **Wiki Index 维护**: 扫描 memory/ 目录，编译生成 memory/wiki/index.md。
   用户确认后写入。随时可通过删除 memory/wiki/ 目录回退。
```

触发短语: "生成 wiki 索引"、"刷新 wiki 索引"、"build wiki index"

### 7.4 state-model.md 变更

在 WARM 小节之后新增：

```markdown
### WIKI 编译视图 — `memory/wiki/`

- 性质: WARM 文件的只读编译索引
- 自动加载: SessionStart 加载 `memory/wiki/index.md` (若存在)
- 写入者: 仅 `memory-management` 技能
- 回退: 删除 `memory/wiki/` 目录即可回到无 wiki 状态，零副作用
- 不参与晋升/降级生命周期 (wiki 文件不适用温度规则)
```

### 7.5 迁移

**从 v6.2.0 升级到 v6.3.0 (Phase 1)**:

1. 用户无需做任何操作。`memory/wiki/` 在首次运行生成索引时自动创建
2. `memory/wiki/index.md` 不存在时，SessionStart hook 静默跳过，行为与 v6.2.0 完全一致
3. 无数据迁移。无文件重命名。无目录重组

---

## 8. 容量规则

| 文件 | 限制 | 理由 |
|------|------|------|
| `memory/wiki/index.md` | 300 行 | 保持 LLM 单次读取可扫描 |
| `memory/wiki/log.md` (Phase 2) | 500 行 | 旧条目归档到 `memory/wiki/log-archive/YYYY.md` |
| 编译页面 (Phase 2) | 200 行/页 | 与 WARM 文件限制一致 |
| `memory/wiki/` 总页数 | 无硬性限制 | index.md 是瓶颈；通过 lint 清理孤儿页 |

---

## 9. 手动回退方案

在任何阶段，用户都可以执行以下操作回退到无 wiki 状态：

```bash
rm -rf memory/wiki/
```

**回退后的行为**:

- SessionStart hook 检测到 `memory/wiki/index.md` 不存在，静默跳过，零报错
- 所有 WARM 文件完好无损 (wiki 从未修改它们)
- HOT cache 完好无损
- 16 个执行技能行为不变
- `memory-management` 的所有现有功能不变
- 唯一丢失的是编译索引本身——下次运行时可重新生成

**此回退方案必须在所有阶段保持有效。** 如果某个 Phase 2+ 功能会导致回退不干净 (例如技能开始依赖 wiki 页面作为输入)，则该功能必须在设计时提供降级路径。

---

## 10. 实施计划

### Phase 1 — 编译索引 (v6.3.0)

**目标**: 证明一个好的 WARM 文件索引能改善跨技能上下文获取。

**交付物**:
- `memory-management` 新增"生成 wiki 索引"操作
- `memory/wiki/index.md` 格式定义 (见第 6.1 节)
- SessionStart hook 增加一行: 加载 `memory/wiki/index.md` (若存在)
- `references/state-model.md` 增加 wiki 编译视图小节

**不包含**: 编译页面、log.md、lint 命令、ingest signal、任何技能改动。

**评估门槛 (进入 Phase 2 的条件)**:
- [ ] index.md 被 SessionStart 加载后，跨技能查询的回答质量有可感知的提升
- [ ] 用户不需要手动指定 WARM 文件路径即可获得综合回答
- [ ] 零回退投诉: 不使用 wiki 的用户体验不受影响

### Phase 2 — 编译页面与健康检查 (v6.4.0)

**前提**: Phase 1 评估门槛全部达标。

**交付物**:
- 编译页面: 平铺在 `memory/wiki/`，用 frontmatter type 分类
- `log.md` 追加式时间线
- Source hash 写入编译页面 frontmatter
- `/seo:wiki-lint` 命令: 矛盾检测、孤儿页、陈旧引用、缺失页
- PostToolUse hook: WARM 写入后提示"要更新 wiki 吗？"
- Stop hook: 追加会话活动到 log.md
- 配置开关 `wiki_confirm`: true (默认) / false
- skill-contract.md 增加可选的 wiki ingest signal 描述

**评估门槛 (进入 Phase 3 的条件)**:
- [ ] lint 能可靠检测出手工构造的矛盾测试用例
- [ ] 编译页面被用户实际查阅 (非仅 LLM 读取)
- [ ] source hash 不一致检测的误报率 < 5%

### Phase 3 — 技能集成与 WARM 退役评估 (v6.5.0+)

**前提**: Phase 2 评估门槛全部达标。

**交付物**:
- 技能 "Reads" 部分可选增加 `memory/wiki/` 路径
- `comparisons/` 和 `synthesis/` 子目录
- 评估 WARM 部分路径退役可行性
- Query-to-wiki: 有价值的查询回答归档为新 wiki 页面

**此阶段为探索性质**，不预设交付日期。

---

## 11. 不变的部分

| 组件 | 状态 |
|------|------|
| HOT/WARM/COLD 温度生命周期 | 不变 |
| 16 个执行技能的 SKILL.md | Phase 1-2 不变。Phase 3 可选增强 |
| 4 个协议层技能的角色定义 | 不变 |
| CORE-EEAT 和 CITE 评分框架 | 不变 |
| 工具连接器占位模式 (~~category) | 不变 |
| Handoff summary 格式 | 不变 |
| 否决项自动写入 HOT 的规则 | 不变 |
| `memory/` 目录下的所有现有子目录 | 不变 |
| hooks.json 中的现有 hook | 不变 (仅 SessionStart 新增一条) |

---

## 12. 成功标准

| 编号 | 标准 | 阶段 |
|------|------|------|
| S1 | 运行 3+ 技能后，用户可以问"我们对 Competitor X 了解多少？"并获得综合回答 | Phase 1 |
| S2 | 用户无需记住 WARM 文件路径即可获得跨类别上下文 | Phase 1 |
| S3 | 一月审计与三月审计之间的矛盾在一次 lint 中被自动标记 | Phase 2 |
| S4 | `memory/wiki/index.md` 作为战役知识库的可靠目录 | Phase 1 |
| S5 | 删除 `memory/wiki/` 后系统行为回到 v6.2.0 完全一致 | 所有阶段 |
| S6 | 不使用 wiki 功能的用户体验零退化 | 所有阶段 |

---

## 13. 风险与缓解

| 风险 | 缓解 |
|------|------|
| **Index 膨胀** — WARM 文件过多导致 index.md 超过 300 行 | 按类别折叠; 仅索引含 frontmatter 的文件; 300 行硬限制触发归档建议 |
| **编译错误** — LLM 在 index 摘要中引入不准确信息 | index.md 每次重新生成而非增量更新; 用户确认后写入; 来源可追溯 |
| **采用阻力** — 用户不习惯手动触发 | Phase 1 保持极低摩擦; 只需说"刷新 wiki 索引"即可 |
| **Wiki 与 WARM 不同步** | SessionStart 检查 `last_compiled` 日期，超过 7 天提示刷新 |
| **贡献者复杂度** | Phase 1 仅改 memory-management; 贡献者无需了解 wiki |
| **Session token 开销** | index.md 在 300 行约 4-6KB，可忽略 |
| **级联错误** (Phase 2+) | 用户确认写入; source hash 验证; 随时可删除重建; wiki 永远不修改 WARM 源文件 |
| **终态目标漂移** | Phase 2 评估门槛明确列出"编译页面实际被使用"的指标; 不满足则不推进 |
