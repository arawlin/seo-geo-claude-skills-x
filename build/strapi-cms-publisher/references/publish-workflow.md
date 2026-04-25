# Strapi CMS Publisher — Publish Workflow

Detailed mapping and execution notes for the `strapi-cms-publisher` skill.

---

## Fixed Content Model

The workflow targets a fixed Strapi setup with these entry points:

| Strapi node | Purpose | Notes |
|-------------|---------|-------|
| `Article.title` | Article headline | Required |
| `Article.description` | Summary / dek | Use frontmatter description or explicit summary |
| `Article.content` | Markdown body | Store Markdown after stripping inline JSON-LD blocks and rewriting links or images |
| `slug.label` | Article slug | Unique, used for create/update lookup |
| `seo.metaTitle` | SERP title | Prefer explicit value; fallback to article title |
| `seo.metaDescription` | SERP description | Prefer explicit value; fallback to article description |
| `seo.keywords` | Keyword list | Join primary and secondary keywords into text |
| `seo.structuredData` | JSON-LD | Merged inline plus sidecar schema payload |
| `seo.openGraph` | OG title and description | Optional; omit URL fields when only relative paths are known |
| `Article.icon` | Cover image media | Mapped from `cover_image` when present |
| `Article.previews` | Preview media list | Mapped from `preview_images[]` when present |
| `seo.metaImage` / `seo.openGraph.ogImage` | SEO image media | Mapped from `og_image` when present |
| `source.contentHash` | Content fingerprint | Use normalized Markdown plus merged schema digest |
| `source.origin` | Source channel | Example: `workspace-file` |
| `source.referer` | Source file hint | Example: workspace-relative article path |
| `category` | Many-to-one relation | Used for taxonomy only; not used in rewritten internal article URLs |
| `tags` | Many-to-many relation | Attach by resolved `documentId` values |

`source.releaseAt` is intentionally omitted. Strapi-managed timestamps (`createdAt`, `updatedAt`) are the source of truth.

---

## Supported Input Bundle

### Article Markdown

Expected inputs:

- Frontmatter with at least `title`, `slug`, `description`
- Optional `category`, `tags`, `primary_keyword`, `secondary_keywords`, `meta_title`, `meta_description`
- Markdown body that may contain local article links, remote links, local images, remote images, and inline JSON-LD blocks

Use the fixed field names in [frontmatter-contract.md](./frontmatter-contract.md) for category, tags, image inputs, and SEO overrides.

### Inline JSON-LD

Supported form inside the Markdown body:

```html
<script type="application/ld+json">
{ ... }
</script>
```

or

```html
<script type="application/ld+json">
[
  { ... },
  { ... }
]
</script>
```

Extract every block, parse it as JSON, merge it into the schema set, then remove the script block from the Markdown saved to `Article.content`.

### Sidecar JSON-LD

Sidecar schema can be supplied explicitly by the user or auto-discovered next to the article, for example:

- `article-name.faq.schema.jsonld`
- `article-name.article.schema.jsonld`
- `article-name.schema.jsonld`

---

## Schema Merge Rules

1. Collect inline JSON-LD blocks in article order.
2. Collect sidecar JSON-LD files in the order provided by the user, then lexical filename order for auto-discovery.
3. Normalize every payload to an array of schema objects.
4. De-duplicate by semantic identity using this preference order:
   - `@id`
   - `@type` + `name`
   - `@type` + `headline`
   - full-object hash as a last resort
5. On direct field conflicts, prefer sidecar schema over inline schema.
6. Write the merged result to `seo.structuredData` as an array when more than one object remains, otherwise as a single object.

---

## Internal Link Rewrite Rules

Target shape:

```text
/article/{articleSlug}
```

### Rewrite algorithm

1. Identify Markdown links that target local article files such as `./foo.md`, `../bar/baz.md`, or `foo.md#section`.
2. Resolve the target slug from the filename without extension.
3. Rewrite the link directly to `/article/{articleSlug}` without checking whether the linked article already exists in Strapi.
4. Preserve anchors, for example:
  - `./foo.md#section-1` → `/article/foo#section-1`

### Non-target links

Do not rewrite:

- external HTTP(S) links
- `mailto:` links
- pure hash anchors
- asset downloads that are not article Markdown files

---

## Image Handling Rules

### Local images

1. Resolve the file path relative to the article file.
2. Upload the file to Strapi media.
3. Replace the Markdown image URL with the returned media URL.

### Remote images

1. Download the remote image to temporary local storage.
2. Upload the downloaded file to Strapi media.
3. Replace the Markdown image URL with the returned media URL.
4. Delete the temporary local copy after upload.

### Runtime note

If the connected upload tool only accepts URL-based ingestion rather than raw local files, materialize the local temp file at a reachable URL or file URL that the runtime supports before calling upload.

---

## Taxonomy and Update Rules

### Category

- Look up existing categories before writing the article.
- `Category.slug.label` is taxonomy metadata only and is not used for rewritten internal article links.
- If the category is missing, stage a category create in the review summary.
- If the input only provides a bare slug and not a display name, ask for the missing name before approval.

### Tags

- Look up tags before writing the article.
- Batch every missing tag into the review summary.
- Create missing tags only after approval, then attach the returned `documentId` values to the article payload.

### Existing articles

- Query by `slug.label`.
- If a draft already exists, stage the action as `update`.
- Show the diff summary or at least the intent summary before asking for approval.
- Never overwrite an existing article silently.

---

## Confirmation Matrix

Summarize all pending writes in one confirmation block.

| Pending action | Confirm before write? | Notes |
|----------------|-----------------------|-------|
| Create category | Yes | Batch all missing categories together |
| Create tag | Yes | Batch all missing tags together |
| Update article | Yes | Required even if only content changed |
| Create article | Yes | Covered by the same approval block |
| Upload media | Yes | Covered by the same approval block |

Recommended review block:

```text
Draft publish summary
- Articles to create: X
- Articles to update: Y
- Categories to create: ...
- Tags to create: ...
- Images to upload: ...
- Unresolved links: ...
```

---

## Payload Skeleton

```json
{
  "data": {
    "title": "...",
    "description": "...",
    "content": "# Markdown body after rewrites",
    "slug": {
      "label": "article-slug"
    },
    "seo": {
      "metaTitle": "...",
      "metaDescription": "...",
      "keywords": "keyword a, keyword b",
      "structuredData": [
        { "@type": "BlogPosting" },
        { "@type": "FAQPage" }
      ],
      "openGraph": {
        "ogTitle": "...",
        "ogDescription": "..."
      }
    },
    "source": {
      "contentHash": "...",
      "origin": "workspace-file",
      "referer": "vendors/cms-server-1/example.md"
    },
    "category": "<category documentId>",
    "tags": ["<tag documentId>", "<tag documentId>"]
  }
}
```

Read the saved draft back after writing and verify the stored slug, taxonomy, schema, and rewritten Markdown.