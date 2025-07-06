#!/bin/sh

# Generate Helm function list from:
# https://github.com/helm/helm/blob/main/pkg/engine/funcs.go

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_FILE="$SELF_DIR/../hrc/hrc/misc/helm-tpl.ent.hrc"

TEMP_DIR="$(mktemp --directory)"
# Write to a temp file to avoid override of existing file in case of failure
TEMP_OUT="$TEMP_DIR/output"

# execute in subshell to preserve PWD
(

    cd "$TEMP_DIR"
    git clone https://github.com/helm/helm.git
    cd helm
    # This was copypasted from Helm CI scripts:
    # https://github.com/helm/helm/blob/bbea98ed6be8069ddda2c228ae58b52e078f41c2/.github/workflows/release.yml#L50
    HELM_RELEASE="$(git tag | sort -r --version-sort | grep '^v[0-9]' | grep -v '-' | head -n1)"
    if [ -z "$HELM_RELEASE" ]; then
        echo "ERROR: something wrong, could not detect Helm release version."
        exit 1
    fi
    echo "<!--"
    echo "    This file was generated on: $(date --iso-8601=seconds)"
    echo "    Helm version: $HELM_RELEASE"
    echo "-->"
    echo

    sed -n '/^[[:space:]]*extra := template.FuncMap/,/^[[:space:]]*}$/p' pkg/engine/funcs.go \
        | grep -oP '^\s+"\K[^"]+' \
        | sed 's#.*#<word name="&"/>#'

) >"$TEMP_OUT" && RC=0 || RC=$?

if [ "$RC" -eq 0 ]; then
    echo "Write to output: $OUT_FILE"
    mv -f "$TEMP_OUT" "$OUT_FILE"

fi

rm -rf "$TEMP_DIR"
exit $RC



