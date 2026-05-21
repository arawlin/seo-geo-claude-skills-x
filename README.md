# seo-geo-claude-skills-x

This document is also available in [Chinese](./README-zh.md).

Derivative workspace for SEO and GEO content-production skills and agents for GitHub Copilot workflows.

## Overview

This repository is a maintenance-first asset repo built around the ideas and contracts from the upstream [seo-geo-claude-skills project](https://github.com/aaron-he-zhu/seo-geo-claude-skills). Its practical use is to copy the local agent and skill assets into a target workspace's `.github/` directory, install the upstream project's skills, and let GitHub Copilot in VS Code run the local wrappers together with upstream skills through subagent chaining. It is not a packaged application and it does not ship a runnable service from the repository root.

The current focus is a content-series pipeline for SEO and GEO work:

- plan a topic cluster
- draft article batches
- insert visual placeholders
- audit delivery artifacts
- publish finalized Markdown into a fixed Strapi draft model
- orchestrate sequential topic-article generation through Copilot subagents

## Relationship to the Upstream Repository

This repository follows the upstream project's skill-contract style and workflow decomposition, then adds a local maintenance layer around it.

Compared with the upstream repository, this workspace emphasizes:

- pipeline-oriented organization under [pipelines](./pipelines)
- runnable agent wrappers alongside skill definitions under [pipelines/agents](./pipelines/agents) and [pipelines/skills](./pipelines/skills)
- local workflow wrappers intended to sit on top of the upstream skill set, not replace it
- a Strapi publishing helper tuned to a fixed local content model in [pipelines/skills/strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher)

In short: the upstream repository provides the base skill set, while this repository provides the local wrappers and workflow additions used to drive sequential article generation and downstream publishing.

## Repository Layout

| Path | Purpose |
| --- | --- |
| [pipelines/agents](./pipelines/agents) | Runnable custom agents that coordinate or specialize parts of the workflow. |
| [pipelines/skills](./pipelines/skills) | Reusable skill contracts, prompts, references, and helper scripts for each pipeline stage. |

The repository root intentionally stays small. There is no build system or package manifest here because the main deliverable is the prompt and workflow asset set itself. In normal use, the contents of [pipelines/agents](./pipelines/agents) and [pipelines/skills](./pipelines/skills) are copied into `.github/agents` and `.github/skills` inside the target workspace, while this repository remains the editable source.

## Main Workflow

The content-series path is the clearest way to read the repo.

1. [series-research-planner](./pipelines/skills/series-research-planner/SKILL.md) turns one topic into a normalized research brief and article plan.
2. [article-batch-generator](./pipelines/skills/article-batch-generator/SKILL.md) drafts all planned articles, applies internal linking, and runs final per-article audits.
3. [series-finalizer](./pipelines/skills/series-finalizer/SKILL.md) compiles delivery-facing rollups such as the series index, publish checklist, and audit summary.
4. [strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher/SKILL.md) can then sync finalized Markdown bundles into a fixed Strapi draft model.

If you want one top-level entrypoint, use [series-content-orchestrator](./pipelines/skills/series-content-orchestrator/SKILL.md) or its runnable agent companion [series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md), depending on what your host supports.

## Expected Artifact Shape

The pipeline is organized around predictable topic-directory outputs rather than ad hoc prompts. A typical series run writes artifacts in this shape:

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

That contract matters because several skills assume the same canonical file names and handoff paths.

## Key Entry Points

| Entry point | Use it for |
| --- | --- |
| [pipelines/skills/series-content-orchestrator/SKILL.md](./pipelines/skills/series-content-orchestrator/SKILL.md) | One-entry skill wrapper from topic to finalized series outputs. |
| [pipelines/agents/series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md) | Runnable orchestration agent when the host supports direct agent execution. |
| [pipelines/skills/series-research-planner/SKILL.md](./pipelines/skills/series-research-planner/SKILL.md) | Planning a topic cluster before any drafting starts. |
| [pipelines/skills/article-batch-generator/SKILL.md](./pipelines/skills/article-batch-generator/SKILL.md) | Drafting and auditing all articles from an approved series plan. |
| [pipelines/skills/seo-image-placeholder/SKILL.md](./pipelines/skills/seo-image-placeholder/SKILL.md) | Reserving screenshot or image blocks inside drafts. |
| [pipelines/skills/series-finalizer/SKILL.md](./pipelines/skills/series-finalizer/SKILL.md) | Building delivery summaries without touching article bodies. |
| [pipelines/skills/strapi-cms-publisher/SKILL.md](./pipelines/skills/strapi-cms-publisher/SKILL.md) | Uploading finalized article bundles to the adapted Strapi draft model. |

## Using This Repository in VS Code

Use this repository as a companion layer on top of the upstream skill pack.

1. Copy [pipelines/agents](./pipelines/agents) into `.github/agents` in the target workspace.
2. Copy [pipelines/skills](./pipelines/skills) into `.github/skills` in the target workspace.
3. Install the upstream skills from [seo-geo-claude-skills](https://github.com/aaron-he-zhu/seo-geo-claude-skills) so the local agents and wrappers can call the expected downstream capabilities.
4. Open the target workspace in VS Code with GitHub Copilot enabled.
5. Start from [series-content-orchestrator](./pipelines/skills/series-content-orchestrator/SKILL.md) or [series-content-orchestrator.agent.md](./pipelines/agents/series-content-orchestrator.agent.md) when you want Copilot to drive the topic workflow through subagents in sequence.
6. Use stage-specific entries such as [series-research-planner](./pipelines/skills/series-research-planner/SKILL.md) or [article-batch-generator](./pipelines/skills/article-batch-generator/SKILL.md) when you want to run only one part of the pipeline.

In the intended setup, Copilot uses the copied local agents and skills as the orchestration layer, then calls upstream skills as subagents to generate themed article batches step by step.

## Local Customizations in This Repo

The main customization in this workspace is a local orchestration layer that is meant to work with the upstream skill set, plus a downstream publishing flow.

### Copilot-Oriented Workflow Wrappers

The agent and skill files under [pipelines](./pipelines) are designed to be copied into `.github/` and used as the local entrypoints for GitHub Copilot. Their job is to:

- provide stable top-level prompts for topic workflows
- keep stage order explicit
- delegate specialized work to upstream skills through subagents
- make sequential article generation easier to rerun and maintain

### Strapi Draft Publishing Support

[pipelines/skills/strapi-cms-publisher](./pipelines/skills/strapi-cms-publisher) adds a downstream publishing bridge from local Markdown bundles to a fixed Strapi draft model. The helper assumes:

- a known article, SEO, slug, source, category, and tag mapping
- draft-only writes for articles and categories
- published creation for missing tags after explicit confirmation
- media upload and internal-link rewriting as part of the publish flow

## What This Repository Is Not

This repository is not:

- a standalone web application
- a Python or Node package with install commands
- a complete runtime distribution for every supported host
- a self-sufficient replacement for the upstream skill pack
- a replacement for the upstream repository's full documentation

It is the working asset library for a specific SEO and GEO production setup.

## Maintenance Notes

When updating this repository, keep these relationships aligned:

- skill-level contracts in [pipelines/skills](./pipelines/skills)
- runnable wrappers in [pipelines/agents](./pipelines/agents)
- the copied `.github/agents` and `.github/skills` layout used in the target workspace
- this README and its Chinese counterpart [README-zh.md](./README-zh.md)

If a workflow contract changes, update the skill first, then make sure any matching agent wrapper and repository-level explanation still describe the same artifact paths, gating rules, and downstream expectations.
