# seo-geo-claude-skills-x

本文档亦提供[英文版](./README.md)。

这是一个面向维护的 SEO 与 GEO 内容生产资产仓库，存放技能、智能体，以及面向 GitHub Copilot 工作流与 CMS 发布的辅助材料。

## 概览

这个仓库建立在上游项目 [seo-geo-claude-skills](https://github.com/aaron-he-zhu/seo-geo-claude-skills) 的思路和约定之上。它的实际用法很直接：把这里的本地 agents 和 skills 复制到目标工作区的 `.github/` 目录下，再安装上游项目的 skills，然后让 VS Code 里的 GitHub Copilot 通过 subagent 串联这些本地封装和上游能力。它本身不是一个可直接运行的应用，也不是根目录执行安装命令后就能启动的服务。

当前仓库的重点是一条围绕 SEO 与 GEO 内容生产的专题流程：

- 先做专题规划
- 再批量起草文章
- 在文中预留视觉证据位
- 汇总审核与交付产物
- 将最终 Markdown 同步到固定的 Strapi 草稿模型
- 通过 Copilot 的 subagent 顺序生成专题文章

## 与上游仓库的关系

这个仓库沿用了上游项目的 skill contract 风格和工作流拆分方式，并在此基础上增加了一层更贴近本地维护的辅助组织。

相较于上游仓库，这个工作区更强调：

- 在 [pipelines](./pipelines) 下按流程组织资产
- 同时维护可执行的智能体封装和技能定义，分别放在 [pipelines/agents](./pipelines/agents) 与 [pipelines/skills](./pipelines/skills)
- 这些本地流程封装是叠加在上游 skill 集合之上的，而不是替代上游
- 在 [pipelines/skills/strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher) 中提供面向固定本地内容模型的 Strapi 发布辅助能力

可以把它理解为：上游仓库提供基础 skill 集合，这个仓库则提供本地编排封装，以及下游发布支持。

## 仓库结构

| 路径 | 作用 |
| --- | --- |
| [pipelines/agents](./pipelines/agents) | 可执行的自定义智能体，用来编排或专注处理某一段流程。 |
| [pipelines/skills](./pipelines/skills) | 每个流程阶段对应的技能约定、提示词、参考文件与辅助脚本。 |

根目录故意保持简洁。这里没有构建系统，也没有包管理清单，因为仓库的主要交付物就是这些提示词与工作流资产本身。实际使用时，通常会把 [pipelines/agents](./pipelines/agents) 和 [pipelines/skills](./pipelines/skills) 分别复制到目标工作区的 `.github/agents` 与 `.github/skills`，而这个仓库则作为可编辑的源仓库保留。

## 主流程

如果要快速理解这个仓库，最好的入口就是内容专题流水线。

1. [series-research-planner](./pipelines/skills/series-research-planner/SKILL.md) 把一个主题转成结构化研究摘要和文章计划。
2. [article-batch-generator](./pipelines/skills/article-batch-generator/SKILL.md) 按计划批量起草文章、补内链，并执行逐篇审核。
3. [series-finalizer](./pipelines/skills/series-finalizer/SKILL.md) 生成交付层汇总，例如系列索引、发布清单和审核摘要。
4. [strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher/SKILL.md) 可以把整理好的 Markdown 文章包同步到固定的 Strapi 草稿模型。

如果你想从一个总入口开始，可以使用 [series-content-orchestrator](./pipelines/skills/series-content-orchestrator/SKILL.md)，或者在宿主支持可执行智能体时使用它对应的 [series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md)。

## 预期产物结构

这套流程依赖的是可预测的专题目录产物，而不是一次性的自由提示词。一次典型运行会生成如下结构：

```text
topics/<topic-slug>/
  research/
    00-series-research.md
    00-series-plan.json
  articles/
    NN-slug.md
  delivery/
    50-batch-summary.md
    99-series-index.md
    99-publish-checklist.md
    99-audit-summary.json
    internal-links/
      NN-slug.links.md
    audits/
      NN-slug.audit.json
```

这个约定很重要，因为多个技能都会直接依赖这些标准文件名和交接路径。

## 关键入口

| 入口 | 适用场景 |
| --- | --- |
| [pipelines/skills/series-content-orchestrator/SKILL.md](./pipelines/skills/series-content-orchestrator/SKILL.md) | 从一个主题一路走到系列交付结果的总控技能入口。 |
| [pipelines/agents/series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md) | 当宿主支持直接运行自定义智能体时，使用这个执行型总控封装。 |
| [pipelines/skills/series-research-planner/SKILL.md](./pipelines/skills/series-research-planner/SKILL.md) | 在开始写作前先做专题聚类与文章规划。 |
| [pipelines/skills/article-batch-generator/SKILL.md](./pipelines/skills/article-batch-generator/SKILL.md) | 基于已确认的系列计划批量起草与审核所有文章。 |
| [pipelines/skills/seo-image-placeholder/SKILL.md](./pipelines/skills/seo-image-placeholder/SKILL.md) | 在草稿中预留截图或图片占位块。 |
| [pipelines/skills/series-finalizer/SKILL.md](./pipelines/skills/series-finalizer/SKILL.md) | 不改正文，只构建交付摘要与检查清单。 |
| [pipelines/skills/strapi-cms-publisher/SKILL.md](./pipelines/skills/strapi-cms-publisher/SKILL.md) | 将整理好的文章包上传到已适配的 Strapi 草稿模型。 |

## 在 VS Code 中如何使用

这个仓库的推荐用法，是作为上游 skill 包之上的本地补充层来使用。

1. 把 [pipelines/agents](./pipelines/agents) 复制到目标工作区的 `.github/agents`。
2. 把 [pipelines/skills](./pipelines/skills) 复制到目标工作区的 `.github/skills`。
3. 安装上游项目 [seo-geo-claude-skills](https://github.com/aaron-he-zhu/seo-geo-claude-skills) 提供的 skills，让这些本地 agent 和 skill 能调用预期的下游能力。
4. 在启用了 GitHub Copilot 的 VS Code 中打开目标工作区。
5. 当你希望按顺序跑完整个专题流程时，从 [series-content-orchestrator](./pipelines/skills/series-content-orchestrator/SKILL.md) 或 [series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md) 开始。
6. 当你只想运行某一个阶段时，直接使用 [series-research-planner](./pipelines/skills/series-research-planner/SKILL.md) 或 [article-batch-generator](./pipelines/skills/article-batch-generator/SKILL.md) 这类阶段入口。

按这个结构接入后，Copilot 会把这些复制进 `.github/` 的本地 agent 和 skill 当作编排层，再通过 subagent 调用上游 skills，顺序完成专题文章的生成。

## 这个仓库里的本地定制点

这个工作区最明显的本地定制，是建立了一层面向 Copilot 的本地编排封装，并补了一段面向下游发布的流程。

### 面向 Copilot 的工作流封装

[pipelines](./pipelines) 下的 agent 与 skill 文件，设计目标就是复制进 `.github/` 后，作为 GitHub Copilot 的本地入口层使用。它们主要负责：

- 提供稳定的专题工作流入口提示
- 明确每个阶段的先后顺序
- 通过 subagent 把细分任务委托给上游 skills
- 让顺序生成专题文章这件事更容易重跑和维护

### Strapi 草稿发布支持

[pipelines/skills/strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher) 增加了一条从本地 Markdown 文章包进入固定 Strapi 草稿模型的下游桥接能力。它默认假设：

- Article、SEO、slug、source、category、tag 都有固定映射
- 文章与分类只写入草稿
- 缺失标签会在显式确认后以已发布状态创建
- 发布过程中会处理媒体上传与内链改写

## 这个仓库不是什么

这个仓库不是：

- 一个独立 Web 应用
- 一个带安装命令的 Python 或 Node 包
- 一个面向所有宿主环境的完整运行时发行版
- 一个可以脱离上游 skill 包单独成立的完整替代品
- 上游仓库完整文档的替代品

它本质上是一个服务于特定 SEO 与 GEO 内容生产流程的工作资产库。

## 维护说明

后续维护时，建议始终把下面几层保持一致：

- [pipelines/skills](./pipelines/skills) 里的技能约定
- [pipelines/agents](./pipelines/agents) 里的执行封装
- 目标工作区里复制后的 `.github/agents` 与 `.github/skills` 布局
- 当前 README 与对应中文文档 [README-zh.md](./README-zh.md)

如果某个工作流约定发生变化，优先更新对应 skill，再检查关联的 agent 封装，以及仓库级说明是否仍然准确描述了相同的产物路径、确认门槛和下游预期。
