#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./scripts/generate-content-hash.sh --title "..." --description "..." --content-file path/to/article.md

Generate a stable SHA-256 content hash from title, description, and content.
Pass the article Markdown file directly with --content-file.
The script normalizes CRLF to LF before hashing and prints only the hex digest.
EOF
}

die() {
    echo "$1" >&2
    usage >&2
    exit 1
}

normalize_stream() {
    awk 'BEGIN { RS = "\0"; ORS = "" } { gsub(/\r\n/, "\n"); gsub(/\r/, "\n"); print }'
}

emit_field() {
    local key="$1"
    local value="$2"

    printf '%s<<EOF\n' "$key"
    printf '%s' "$value" | normalize_stream
    printf '\nEOF\n'
}

emit_content_field() {
    local file_path="$1"

    printf 'content<<EOF\n'
    normalize_stream < "$file_path"
    printf '\nEOF\n'
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
    emit_field "title" "$title"
    emit_field "description" "$description"
    emit_content_field "$content_file"
} | shasum -a 256 | awk '{ print $1 }'