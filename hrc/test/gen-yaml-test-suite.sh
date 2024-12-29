#!/bin/bash

# Generate test cases from:
# https://github.com/yaml/yaml-test-suite

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_DIR="$SELF_DIR/source/yaml-yaml-test-suite"
TEMP_DIR="$(mktemp --directory)"

[ -d "$OUT_DIR" ] || mkdir -p "$OUT_DIR"

( # run in subshell to keep pwd

cd "$TEMP_DIR"
git clone --depth 1 -b main https://github.com/yaml/yaml-test-suite.git
cd yaml-test-suite/src
#cd /tmp/tmp.Xqo5wLe24B/yaml-test-suite/src

for fn in *.yaml; do
    COUNT="$(yq '. | length' "$fn")"
    echo "Process '$fn'; Documents count: $COUNT"
    DOC_NUMBER=0
    PREFIX="${fn%.*}"
    while [ $DOC_NUMBER -lt $COUNT ]; do
        {
            yq -o=props '.[0] | del(.yaml, .json, .tree, .from, .tags, .also, .dump, .emit)' "$fn" | sed 's/^/# /'
            echo
            yq ".[${DOC_NUMBER}].yaml" "$fn"
            yq ".[${DOC_NUMBER}].tree" "$fn" | grep -v '^$' | sed 's/^/# /'
        } >"$OUT_DIR/${PREFIX}-${DOC_NUMBER}.yaml"
        DOC_NUMBER=$(( DOC_NUMBER + 1 ))
    done
done

)

rm -rf "$TEMP_DIR"
