#!/bin/bash

# Generate test cases from:
# https://github.com/dlang-community/D-YAML

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_DIR="$SELF_DIR/source/yaml-d-yaml"
OUT_DIR_SPEC="$SELF_DIR/source/yaml-d-yaml-spec"
TEMP_DIR="$(mktemp --directory)"

[ -d "$OUT_DIR" ] || mkdir -p "$OUT_DIR"
[ -d "$OUT_DIR_SPEC" ] || mkdir -p "$OUT_DIR_SPEC"

( # run in subshell to keep pwd

cd "$TEMP_DIR"
git clone --depth 1 -b master https://github.com/dlang-community/D-YAML.git
cd D-YAML/test
#cd /tmp/tmp.Xqo5wLe24B/D-YAML/test

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

cd "spec 1.1"

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
        } >"$OUT_DIR_SPEC/${PREFIX}-${DOC_NUMBER}.yaml"
        DOC_NUMBER=$(( DOC_NUMBER + 1 ))
    done
done

)

rm -rf "$TEMP_DIR"
