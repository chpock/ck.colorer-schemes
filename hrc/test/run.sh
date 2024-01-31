#!/usr/bin/env bash

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
! command -v cygpath >/dev/null 2>&1 || SELF_DIR="$(cygpath -m "$SELF_DIR")"

BIN_DIR="$SELF_DIR/bin"
SOURCE_DIR="$SELF_DIR/source"
OUT_DIR="$SELF_DIR/_out"
VALID_DIR="$SELF_DIR/valid"

[ -z "$1" ] || MODE_CREATE=1

set -- "$BIN_DIR/colorer" -c "$BIN_DIR"/catalog.xml -el debug -ed "$OUT_DIR"

LOG_FILE="$OUT_DIR"/consoletools.log
HRD_FILE="$BIN_DIR"/blue.hrd

rm -f "$OUT_DIR"/*

print_color() {
    local NAME="$1" COL
    if [ "$NAME" = "fg" -o "$NAME" = "bg" ]; then
        COL="$2"
        if [ -z "$2" ]; then
            print_color "def:Text" "$NAME"
            return 0
        fi
        printf '\033['
        [ "$NAME" = "fg" ] && printf '38' || printf '48'
        printf ';2'
        printf ';%d' $((16#${COL:0:2}))
        printf ';%d' $((16#${COL:2:2}))
        printf ';%d' $((16#${COL:4:2}))
        printf 'm'
        return 0
    elif [ -z "$NAME" ]; then
        printf '\033[0m'
        return 0
    fi
    COL="${HTML2CONS["$NAME"]}"
    #if [ -z "$COL" ]; then
    #    echo "Warning: color name was not found: '$NAME'" >&2
    #    return 0
    #fi
    [ -n "$2" -a "$2" = "bg" ] || print_color fg "${COL%|*}"
    [ -n "$2" -a "$2" = "fg" ] || print_color bg "${COL#*|}"
}

print_string() {
    local LINE="$1"
    LINE="${LINE//$'\t'/ }"
    LINE="${LINE//&amp;/\&}"
    LINE="${LINE//&apos;/\'}"
    LINE="${LINE//&quot;/\"}"
    LINE="${LINE//&lt;/\<}"
    LINE="${LINE//&gt;/\>}"
    printf '%s' "$LINE"
    LINE_LENGTH=$(( LINE_LENGTH + ${#LINE} ))
}

load_hrd() {
    local LINE
    if ! declare -p HTML2CONS >/dev/null 2>&1; then
        declare -gA HTML2CONS
        while read -r LINE || [ -n "$LINE" ]; do
            local X="${LINE#*<assign name=\"}"
            [ "$X" != "$LINE" ] || continue
            local C_NAME="${X%%\"*}"
            LINE="${X#*\"}"
            local C_FORE="" C_BACK=""
            X="${LINE#*fore=\"#}"
            [ "$X" = "$LINE" ] || C_FORE="${X%%\"*}"
            X="${LINE#*back=\"#}"
            [ "$X" = "$LINE" ] || C_BACK="${X%%\"*}"
            HTML2CONS["$C_NAME"]="$C_FORE|$C_BACK"
        done < "$HRD_FILE"
    fi
}

filter_diff() {
    local LINE
    load_hrd
    while IFS= read -r LINE; do
        # strip line numbers
        LINE="${LINE#*: }"
        local X="${LINE%%<span class=\'*}"
        while [ "$X" != "$LINE" ]; do

            printf '%s' "$X"

            printf '%s' "${LINE:${#X}:13}"
            LINE="${LINE:$((13+${#X}))}"
            X="${LINE%%\'*}"

            local C_NAME="${X##* }" ORIG="$X"
            C_NAME="${C_NAME//-/:}"
            while [ -n "$C_NAME" -a -z "${HTML2CONS["$C_NAME"]}" ]; do
                [ "${X% *}" = "$X" ] && X="" || X="${X% *}"
                C_NAME="${X##* }"
                C_NAME="${C_NAME//-/:}"
            done
            printf '%s' "${C_NAME//:/-}"

            printf '%s' "${LINE:${#ORIG}:2}"
            LINE="${LINE:$((2+${#ORIG}))}"
            X="${LINE%%</span>*}"
            printf '%s' "$X"

            printf '%s' "${LINE:${#X}:7}"
            LINE="${LINE:$((7+${#X}))}"

            X="${LINE%%<span class=\'*}"
        done
        printf '%s' "$LINE"
        echo
    done
}

html2console() {
    local LINE
    load_hrd
    while IFS= read -r LINE; do
        LINE_LENGTH=0
        local PRE="${LINE%% *}"
        [ "$PRE" = "---" -o "$PRE" = "+++" -o "$PRE" = "@@" ] || print_color "def:Text"
        local X="${LINE%%<span class=\'*}"
        while [ "$X" != "$LINE" ]; do

            print_string "$X"

            LINE="${LINE:$((13+${#X}))}"
            X="${LINE%%\'*}"

            local C_NAME="${X##* }" ORIG="$X"
            C_NAME="${C_NAME//-/:}"
            while [ -n "$C_NAME" -a -z "${HTML2CONS["$C_NAME"]}" ]; do
                [ "${X% *}" = "$X" ] && X="" || X="${X% *}"
                C_NAME="${X##* }"
                C_NAME="${C_NAME//-/:}"
            done
            if [ -z "$C_NAME" ]; then
                print_string "(Not found: $ORIG)"
            else
                print_color "$C_NAME"
            fi

            LINE="${LINE:$((2+${#ORIG}))}"
            X="${LINE%%</span>*}"
            print_string "$X"

            LINE="${LINE:$((7+${#X}))}"
            print_color "def:Text"

            X="${LINE%%<span class=\'*}"
        done
        print_string "$LINE"
        [ "$PRE" = "---" -o "$PRE" = "+++" -o "$PRE" = "@@" ] || print_color "def:Text"
        [ $LINE_LENGTH -ge $COLUMNS ] || print_string "$(printf "%$(( COLUMNS - LINE_LENGTH ))s")"
        print_color
        echo
    done
}

for SOURCE in "$SOURCE_DIR"/*; do

    if [ "${SOURCE##*.}" = "template" ]; then
        [ ! -e "${SOURCE%.*}" ] || continue
        SOURCE="${SOURCE%.*}"
    fi

    BASE="${SOURCE##*/}"
    OUT="$OUT_DIR/${BASE}.html"
    DIFF="$OUT_DIR/${BASE}.diff"
    VALID="$VALID_DIR/${BASE}.html"
    TEMPLATE="${SOURCE}.template"

    printf "Generate: %s ..." "$BASE"
    [ ! -e "$TEMPLATE" ] || (cd "$SOURCE_DIR" && sh "$TEMPLATE") > "$SOURCE"
    "$@" -ht "$SOURCE" -dc -dh -ln -o "$OUT_DIR"/${BASE}.html
    printf " OK"
    [ ! -e "$TEMPLATE" ] || rm -f "$SOURCE"

    if [ -n "$MODE_CREATE" ]; then
        printf "; Save ..."
        cp -f "$OUT" "$VALID"
        echo " OK"
        continue
    fi

    printf "; Check ..."
    filter_diff < "$VALID" > "${VALID}.filtered"
    filter_diff < "$OUT" > "${OUT}.filtered"
    if diff -rubBaN -U10 "${VALID}.filtered" "${OUT}.filtered" >"$DIFF"; then
        echo " OK"
        rm -f "${VALID}.filtered" "${OUT}.filtered" "$DIFF"
        continue
    fi
    rm -f "${VALID}.filtered" "${OUT}.filtered"

    echo " NOT OK"
    echo "Raw diff:"
    cat "$DIFF"
    echo "Preview diff:"
    cat "$DIFF" | html2console

done

echo
printf "Check logs ..."
if grep -q -E '\[(warning|error)\]' "$LOG_FILE"; then
    echo " NOT OK"
    grep --color=auto -E '\[(warning|error)\]' "$LOG_FILE"
else
    echo " OK"
fi
