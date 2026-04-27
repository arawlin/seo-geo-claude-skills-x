# Schema.org JSON-LD Templates

Compact starter blocks. Replace placeholders, remove unused fields, and validate before ship.

## Shared Rules

- Use absolute URLs and values that match visible page content.
- Use ISO 8601 for dates and durations.
- Omit empty optional fields instead of leaving placeholders live.
- Only emit `aggregateRating` or `review` when the values come from visible, verifiable user reviews.

## FAQPage

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "[Question text]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Answer text]"
      }
    },
    {
      "@type": "Question",
      "name": "[Question 2]",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "[Answer 2]"
      }
    }
  ]
}
```

## HowTo

```json
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "[How-to title]",
  "description": "[Brief description]",
  "totalTime": "PT[hours]H[minutes]M",
  "supply": [
    { "@type": "HowToSupply", "name": "[Supply item]" }
  ],
  "tool": [
    { "@type": "HowToTool", "name": "[Tool]" }
  ],
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "[Step 1 title]",
      "text": "[Step 1 instructions]",
      "url": "[Page URL]#step1"
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "[Step 2 title]",
      "text": "[Step 2 instructions]",
      "url": "[Page URL]#step2"
    }
  ]
}
```

## Article / BlogPosting

Use `Article`, `BlogPosting`, `NewsArticle`, or `TechArticle` as `@type`.

```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "headline": "[Title]",
  "description": "[Summary]",
  "image": ["[Image URL]"],
  "datePublished": "[ISO 8601 publish date-time]",
  "dateModified": "[ISO 8601 modified date-time]",
  "author": {
    "@type": "Person",
    "name": "[Author Name]"
  },
  "publisher": {
    "@type": "Organization",
    "name": "[Publisher Name]",
    "logo": {
      "@type": "ImageObject",
      "url": "[Logo URL]"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "[Canonical URL]"
  }
}
```

## Product

Use `aggregateRating` and `review` only when counts and values match visible, verified user reviews.

```json
{
  "@context": "https://schema.org",
  "@type": "Product",
  "name": "[Product Name]",
  "image": ["[Image URL]"],
  "description": "[Product description]",
  "sku": "[SKU]",
  "brand": {
    "@type": "Brand",
    "name": "[Brand Name]"
  },
  "offers": {
    "@type": "Offer",
    "url": "[Product page URL]",
    "priceCurrency": "[ISO 4217 currency code]",
    "price": "[price]",
    "availability": "https://schema.org/[InStock/OutOfStock/PreOrder]"
  }
}
```

**Optional review extension**: add this only when the page shows visible, verifiable user reviews that match the numbers you publish.

```json
"aggregateRating": {
  "@type": "AggregateRating",
  "ratingValue": "[rating value]",
  "reviewCount": "[review count]",
  "bestRating": "5",
  "worstRating": "1"
},
"review": [
  {
    "@type": "Review",
    "author": {
      "@type": "Person",
      "name": "[Reviewer Name]"
    },
    "reviewRating": {
      "@type": "Rating",
      "ratingValue": "[rating value]",
      "bestRating": "5"
    },
    "reviewBody": "[Review text]",
    "datePublished": "[ISO 8601 review date]"
  }
]
```

## LocalBusiness

Use a more specific subtype when possible: `Restaurant`, `Store`, `LegalService`, `AutoRepair`, and so on.

```json
{
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  "@id": "[Business page URL]",
  "name": "[Business Name]",
  "url": "[Website URL]",
  "telephone": "[phone number]",
  "priceRange": "[price range]",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "[Street]",
    "addressLocality": "[City]",
    "addressRegion": "[State]",
    "postalCode": "[ZIP]",
    "addressCountry": "[ISO country code]"
  },
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["[DayOfWeek]"],
      "opens": "[HH:MM]",
      "closes": "[HH:MM]"
    }
  ]
}
```

**Optional review extension**: reuse the Product review fragment above when the business page qualifies for star-rating markup.

## Organization

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "[Organization Name]",
  "url": "[Website URL]",
  "logo": "[Logo URL]",
  "description": "[Company description]",
  "sameAs": ["[LinkedIn URL]", "[YouTube URL]"],
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "[Phone]",
    "contactType": "[contact type]"
  }
}
```

## BreadcrumbList

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "[Homepage URL]" },
    { "@type": "ListItem", "position": 2, "name": "[Category]", "item": "[Category URL]" },
    { "@type": "ListItem", "position": 3, "name": "[Current Page]", "item": "[Page URL]" }
  ]
}
```

## VideoObject

```json
{
  "@context": "https://schema.org",
  "@type": "VideoObject",
  "name": "[Video title]",
  "description": "[Description]",
  "thumbnailUrl": "[Thumbnail URL]",
  "uploadDate": "[ISO 8601 upload date]",
  "duration": "PT[minutes]M[seconds]S",
  "embedUrl": "[Embed URL]"
}
```

## Event

```json
{
  "@context": "https://schema.org",
  "@type": "Event",
  "name": "[Event Name]",
  "description": "[Description]",
  "startDate": "[ISO 8601 event start date-time]",
  "eventStatus": "https://schema.org/[EventScheduled/EventCancelled/EventPostponed]",
  "eventAttendanceMode": "https://schema.org/[OfflineEventAttendanceMode/OnlineEventAttendanceMode/MixedEventAttendanceMode]",
  "location": {
    "@type": "Place",
    "name": "[Venue Name]",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "[Street]",
      "addressLocality": "[City]",
      "addressRegion": "[State]",
      "postalCode": "[ZIP]",
      "addressCountry": "[ISO country code]"
    }
  },
  "organizer": {
    "@type": "Organization",
    "name": "[Organizer Name]"
  }
}
```

## Course

```json
{
  "@context": "https://schema.org",
  "@type": "Course",
  "name": "[Course Name]",
  "description": "[Description]",
  "provider": {
    "@type": "Organization",
    "name": "[Provider Name]",
    "sameAs": "[Provider URL]"
  },
  "hasCourseInstance": {
    "@type": "CourseInstance",
    "courseMode": "[online/onsite/blended]",
    "courseWorkload": "PT[hours]H"
  }
}
```

## Recipe

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "[Recipe name]",
  "image": "[Image URL]",
  "author": {
    "@type": "Person",
    "name": "[Author]"
  },
  "description": "[Description]",
  "prepTime": "PT[minutes]M",
  "cookTime": "PT[minutes]M",
  "recipeYield": "[4 servings]",
  "recipeIngredient": ["[Ingredient 1]", "[Ingredient 2]"],
  "recipeInstructions": [
    { "@type": "HowToStep", "text": "[Step 1]" },
    { "@type": "HowToStep", "text": "[Step 2]" }
  ]
}
```

**Optional review extension**: reuse the Product review fragment above when the recipe page includes visible, eligible user ratings.

## SoftwareApplication

```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "[Software name]",
  "operatingSystem": "[Windows, macOS, iOS, Android, Web]",
  "applicationCategory": "[Schema.org application category]",
  "offers": {
    "@type": "Offer",
    "price": "[price or 0]",
    "priceCurrency": "[ISO 4217 currency code]"
  },
  "softwareVersion": "[version]",
  "downloadUrl": "[Download URL]"
}
```

**Optional review extension**: reuse the Product review fragment above when the software page qualifies for review rich results.

## Combined Array

Place multiple complete objects inside one array in a single `<script type="application/ld+json">` block when a page needs more than one schema type.

## Preflight Checklist

- Validate with `validator.schema.org` and Google's Rich Results Test.
- Use truthful review data only; if unsure, omit review properties.
- Keep URLs canonical and accessible.
- Remove trailing commas and placeholder text before publishing.
