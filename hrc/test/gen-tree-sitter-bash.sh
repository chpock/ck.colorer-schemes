#!/bin/bash

# Generate test cases from:
# https://github.com/tree-sitter/tree-sitter-bash/tree/master/test/corpus

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_DIR="$SELF_DIR/source/tree-sitter-bash"
TEMP_DIR="$(mktemp --directory)"

[ -d "$OUT_DIR" ] || mkdir -p "$OUT_DIR"

cd "$TEMP_DIR"
git clone --depth 1 -b master https://github.com/tree-sitter/tree-sitter-bash.git
cd tree-sitter-bash/test/corpus

for fn in *.txt; do
    prefix="${fn%.*}"
    state="none"
    while IFS= read -r line; do
        case "$line" in
            ========*)
                if [ "$state" = "none" ]; then
                    state="name"
                elif [ "$state" = "name" ]; then
                    state="body"
                elif [ "$state" = "result" ]; then
                    state="name"
                else
                    echo "$line"
                    echo "Unexpected state for '==='!" >&2
                    exit 1
                fi
                continue
                ;;
            ---*)
                if [ "$state" = "body" ]; then
                    state="result"
                else
                    echo "$line"
                    echo "Unexpected state for '---'!" >&2
                    exit 1
                fi
                continue
                ;;
        esac
        case "$state" in
            name|none)
                name="$line"
                output="$OUT_DIR/${prefix}-$(echo "$name" \
                    | sed \
                        -e 's/[^[:alnum:][:space:]]//g' \
                        -e 's/[[:space:]]\+/_/g' \
                        -e 's/_*$//' \
                    ).bash"
                rm -f "$output"
                echo "Create: $output"
                [ "$state" != "none" ] || state="name"
                ;;
            body)
                printf '\n%s' "$line" >>"$output"
                ;;
            result)
                : no-op
                ;;
            *)
                echo "$line"
                echo "Unexpected state: $state!" >&2
                exit 1
                ;;
        esac
    done < $fn
done

cd
rm -rf "$TEMP_DIR"
