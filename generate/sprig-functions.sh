#!/bin/sh

# Generate Sprig function list from:
# https://github.com/Masterminds/sprig/blob/master/functions.go

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
OUT_FILE="$SELF_DIR/../hrc/hrc/misc/go-template-sprig.ent.hrc"

TEMP_DIR="$(mktemp --directory)"
# Write to a temp file to avoid override of existing file in case of failure
TEMP_OUT="$TEMP_DIR/output"

# execute in subshell to preserve PWD
(

    cd "$TEMP_DIR"
    git clone --depth 1 -b master https://github.com/Masterminds/sprig.git
    cd sprig
    SPRIG_RELEASE="$(grep --max-count=1 '^## Release' CHANGELOG.md | sed 's/^##[[:space:]]*//')"
    if [ -z "$SPRIG_RELEASE" ]; then
        echo "ERROR: something wrong, could not detect Sprig release version."
        exit 1
    fi
    echo "<!--"
    echo "    This file was generated on: $(date --iso-8601=seconds)"
    echo "    Sprig version: $SPRIG_RELEASE"
    echo "-->"
    echo
    sed -n '/^var genericMap/,/^}/p' functions.go \
        | grep -oP '^\s+"\K[^"]+' \
        | sed 's#.*#<word name="&"/>#'

) >"$TEMP_OUT" && RC=0 || RC=$?

if [ "$RC" -eq 0 ]; then
    echo "Write to output: $OUT_FILE"
    mv -f "$TEMP_OUT" "$OUT_FILE"

fi

rm -rf "$TEMP_DIR"
exit $RC



