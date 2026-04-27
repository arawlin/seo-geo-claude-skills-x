#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./scripts/generate-content-hash.sh --title "..." --description "..." (--content "..." | --content-file path)

Generate a stable SHA-256 content hash from title, description, and content.
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
    local inline_content="$1"
    local file_path="$2"

    printf 'content<<EOF\n'
    if [ -n "$file_path" ]; then
        normalize_stream < "$file_path"
    else
        printf '%s' "$inline_content" | normalize_stream
    fi
    printf '\nEOF\n'
}

title=""
description=""
content=""
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
        --content)
            [ "$#" -ge 2 ] || die "Missing value for --content"
            content="$2"
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

if [ -n "$content" ] && [ -n "$content_file" ]; then
    die "Use either --content or --content-file, not both"
fi

if [ -z "$content" ] && [ -z "$content_file" ]; then
    die "One of --content or --content-file is required"
fi

if [ -n "$content_file" ] && [ ! -f "$content_file" ]; then
    echo "Content file not found: $content_file" >&2
    exit 1
fi

{
    emit_field "title" "$title"
    emit_field "description" "$description"
    emit_content_field "$content" "$content_file"
} | shasum -a 256 | awk '{ print $1 }'