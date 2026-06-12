# Strapi CMS Publisher — Frontmatter Contract

Use this contract for Markdown article bundles that will be published by `strapi-cms-publisher`.

---

## Scope

This contract fixes the field names for:

- category
- tags
- image inputs
- SEO override inputs

Anything outside this contract is optional editorial metadata and may be ignored by the publishing workflow unless the skill explicitly documents support for it.

---

## Required Fields

These fields should exist on every publishable article:

```yaml
title: "..."
slug: "..."
description: "..."
```

### Rules

- `title`: final article title sent to `Article.title`
- `slug`: final article slug sent to `slug.label`
- `description`: summary sent to both `Article.description` and the default `seo.metaDescription`

---

## Category

The canonical field name is `category`.

### Canonical shape

```yaml
category:
  slug: "bi-quan-jiao-yi-xue-xi"
  name: "币圈交易学习"
```

### Backward-compatible shorthand

```yaml
category: "bi-quan-jiao-yi-xue-xi"
```

### Rules

- `category.slug` is taxonomy metadata for the category relation; rewritten internal article links no longer use category segments
- `category.name` is required when the category does not already exist in Strapi
- If only the shorthand string is present and the category is missing in Strapi, the workflow must stop and ask for `name` before creation

---

## Tags

The canonical field name is `tags`.

### Canonical shape

```yaml
tags:
  - name: "合约交易风险"
    slug: "heyue-jiaoyi-fengxian"
  - name: "现货交易风险"
```

### Backward-compatible shorthand

```yaml
tags:
  - "合约交易风险"
  - "现货交易风险"
```

### Rules

- `tags` must be an array
- `tag.name` is the canonical display name
- `tag.slug` is optional; if omitted, the workflow may derive a slug when it needs to create a missing tag
- String shorthand is allowed, but object form is preferred for deterministic creation

---

## Image Fields

The publishing workflow reserves these exact field names:

```yaml
cover_image: "./images/cover.webp"
cover_image_alt: "合约和现货风险差异图"
preview_images:
  - "./images/detail-1.webp"
  - "https://example.com/detail-2.jpg"
og_image: "./images/og-cover.webp"
og_image_alt: "合约和现货哪个风险大封面图"
```

### Mapping rules

- `cover_image` → `Article.icon`
- `preview_images[]` → `Article.previews`
- `og_image` → `seo.metaImage` and `seo.openGraph.ogImage`
- `cover_image_alt` and `og_image_alt` are used as upload metadata when the runtime supports media alt text

### Supported values

- local relative paths, resolved from the article file location
- absolute local paths when explicitly provided
- remote HTTP(S) URLs

### Runtime behavior

- local images are uploaded directly
- remote images are downloaded to temporary local storage, then uploaded
- after successful upload, the Markdown body and mapped image fields should use the returned Strapi media URL or media relation

---

## SEO Override Fields

The publishing workflow reserves these exact field names:

```yaml
meta_title: "合约和现货哪个风险大？新手风险差别详解"
meta_description: "合约和现货哪个风险大？本文拆开讲清 6 个关键风险差别。"
meta_keywords:
  - "合约和现货哪个风险大"
  - "合约交易风险"
og_title: "合约和现货哪个风险大？"
og_description: "6 个风险差别，帮新手快速判断。"
og_type: "article"
```

### Mapping rules

- `meta_title` → `seo.metaTitle`
- `meta_description` → `seo.metaDescription`
- `meta_keywords` → `seo.keywords`
- `og_title` → `seo.openGraph.ogTitle`
- `og_description` → `seo.openGraph.ogDescription`
- `og_type` → `seo.openGraph.ogType`

### Fallback rules

- if `meta_title` is absent, fallback to `title`
- if `meta_description` is absent, fallback to `description`
- if `meta_keywords` is absent, derive from `primary_keyword` plus `secondary_keywords`
- if `og_title` is absent, fallback to `meta_title`
- if `og_description` is absent, fallback to `meta_description`
- if `og_type` is absent, default to `article`

`canonical_url` is intentionally not part of this contract. This workflow keeps links relative and does not inject a base URL.

---

## Editorial Fields Still Allowed

These fields are still useful, but they do not override the fixed image and SEO field names above:

```yaml
date: "2026-04-25"
primary_keyword: "合约和现货哪个风险大"
secondary_keywords:
  - "合约交易风险"
  - "现货交易风险"
```

### Rules

- `date` may stay in frontmatter for editorial context, but it is not mapped to `source.releaseAt`
- `primary_keyword` and `secondary_keywords` remain valid content-planning inputs and fallback inputs for `seo.keywords`

---

## Unknown Fields

- Unknown frontmatter keys should not be assumed to map into Strapi automatically
- If a new field needs runtime behavior, add it to this contract first, then update the skill workflow

---

## Recommended Canonical Example

```yaml
---
title: "合约和现货哪个风险大？新手最容易忽略的 6 个风险差别"
slug: "heyue-he-xianhuo-nage-fengxian-da"
description: "合约和现货哪个风险更大？本文从波动承受、杠杆、爆仓、仓位控制、持仓周期和情绪压力 6 个方面讲清楚。"
date: "2026-04-24"
category:
  slug: "bi-quan-jiao-yi-xue-xi"
  name: "币圈交易学习"
tags:
  - name: "合约交易风险"
  - name: "现货交易风险"
primary_keyword: "合约和现货哪个风险大"
secondary_keywords:
  - "合约和现货的区别"
  - "现货和合约哪个好"
cover_image: "./images/cover.webp"
cover_image_alt: "合约和现货风险差别封面图"
preview_images:
  - "./images/detail-1.webp"
og_image: "./images/og-cover.webp"
og_image_alt: "OG 封面图"
meta_title: "合约和现货哪个风险大？新手风险差别详解"
meta_description: "合约和现货哪个风险大？本文拆开讲清 6 个关键风险差别。"
meta_keywords:
  - "合约和现货哪个风险大"
  - "合约交易风险"
og_title: "合约和现货哪个风险大？"
og_description: "6 个风险差别，帮新手快速判断。"
og_type: "article"
---
```