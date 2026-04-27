#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./scripts/generate-content-hash.sh --title "..." --description "..." --content-file <article-markdown-file>

Generate a stable SHA-256 content hash from title, description, and content.
Pass the article Markdown file directly with --content-file.
The script reads file bytes as-is and prints only the hex digest.
EOF
}

die() {
    echo "$1" >&2
    usage >&2
    exit 1
}

title=""
description=""
content_file=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --title)
            [ "$#" -ge 2 ] || die "Missing value for --title"
            title="$2"
            shift 2
            ;;
        --description)
            [ "$#" -ge 2 ] || die "Missing value for --description"
            description="$2"
            shift 2
            ;;
        --content-file)
            [ "$#" -ge 2 ] || die "Missing value for --content-file"
            content_file="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "Unknown argument: $1"
            ;;
    esac
done

[ -n "$title" ] || die "--title is required"
[ -n "$description" ] || die "--description is required"
[ -n "$content_file" ] || die "--content-file is required"

if [ ! -f "$content_file" ]; then
    echo "Content file not found: $content_file" >&2
    exit 1
fi

{
    # Use explicit separators so title/description boundaries are deterministic.
    printf 'title\0%s\0description\0%s\0content\0' "$title" "$description"
    cat -- "$content_file"
} | shasum -a 256 | awk '{ print $1 }'