#!/usr/bin/env bash

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
! command -v cygpath >/dev/null 2>&1 || SELF_DIR="$(cygpath -m "$SELF_DIR")"

BIN_DIR="$SELF_DIR/bin"
SOURCE_DIR="$SELF_DIR/source"
OUT_DIR="$SELF_DIR/_out"
VALID_DIR="$SELF_DIR/valid"
PREVIEW_DIR="$SELF_DIR/../../preview"

if [ "$1" = "show" ]; then
    MODE_SHOW=1
    shift
elif [ "$1" = "save" ]; then
    MODE_CREATE=1
    shift
elif [ "$1" = "preview" ]; then
    MODE_PREVIEW=1
    shift
elif [ "$1" = "test" ]; then
    # normal mode
    shift
elif [ -n "$1" ]; then
    echo "Error: unknown mode: '$1'"
    exit 1
fi

MASKS="$1"

if [ "$(uname -o)" = "Cygwin" ]; then
    COLORER_BIN="colorer.exe"
else
    COLORER_BIN="colorer"
fi

set -- "$BIN_DIR/$COLORER_BIN" -c "$BIN_DIR"/catalog.xml -i gruvbox_dark_hard

LOG_FILE="$OUT_DIR"/consoletools.log
HRD_FILE="$BIN_DIR"/gruvbox_dark_hard.hrd

rm -fr "$OUT_DIR"/*

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

            local C_NAME="${X%% *}" ORIG="$X"
            C_NAME="${C_NAME//-/:}"
            while [ -n "$C_NAME" -a -z "${HTML2CONS["$C_NAME"]}" ]; do
                [ "${X#* }" = "$X" ] && X="" || X="${X#* }"
                C_NAME="${X%% *}"
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

style2color() {
    local LINE="$1" X OUT_FG="$2" OUT_BG="$3" _FG="" _BG=""
    local X="${LINE#*style=\'}"
    if [ "$X" = "$LINE" ]; then
        echo "Error: could not find style in the line: '$LINE'" >&2
        exit 1
    fi
    LINE="${X%%\'*}"
    X="${LINE#*color:#}"
    [ "$X" = "$LINE" ] || _FG="${X:0:6}"
    X="${LINE#*background:#}"
    [ "$X" = "$LINE" ] || _BG="${X:0:6}"
    printf -v "$OUT_FG" '%s' "$_FG"
    printf -v "$OUT_BG" '%s' "$_BG"
}

html2ans() {
    local MAX_LENGTH="$1" LINE X DEF_FG DEF_BG FG BG
    while IFS= read -r LINE; do
        if [ "${LINE:0:6}" = "<html>" ]; then
            style2color "$LINE" DEF_FG DEF_BG
            continue
        elif [ "${LINE:0:6}" = "</pre>" ]; then
            continue
        fi
        LINE_LENGTH=0
        print_color fg "$DEF_FG"
        print_color bg "$DEF_BG"
        local X="${LINE%%<span *}"
        while [ "$X" != "$LINE" ]; do
            print_string "$X"

            LINE="${LINE:$((6+${#X}))}"
            X="${LINE%%>*}"
            style2color "$X" FG BG
            print_color fg "${FG:-$DEF_FG}"
            print_color bg "${BG:-$DEF_BG}"

            LINE="${LINE#*>}"

            X="${LINE%%</span>*}"
            print_string "$X"
            LINE="${LINE:$((7+${#X}))}"

            print_color fg "$DEF_FG"
            print_color bg "$DEF_BG"

            X="${LINE%%<span style=\'*}"
        done
        print_string "$LINE"
        [ $LINE_LENGTH -ge $MAX_LENGTH ] || print_string "$(printf "%$(( MAX_LENGTH - LINE_LENGTH ))s")"
        print_color
        echo
    done
}

for SOURCE in "$SOURCE_DIR"/* "$SOURCE_DIR"/*/*; do

    # Skip directories
    [ ! -d "$SOURCE" ] || continue

    if [ -n "$MASKS" ]; then
        case "$SOURCE" in
        *$MASKS*)
            : noop
            ;;
        *)
            continue
            ;;
        esac
    fi

    if [ "${SOURCE##*.}" = "template" ]; then
        [ ! -e "${SOURCE%.*}" ] || continue
        SOURCE="${SOURCE%.*}"
    fi

    BASE="${SOURCE##$SOURCE_DIR/}"

    BASE_DIR="${BASE%/*}"
    [ "$BASE" != "$BASE_DIR" ] || BASE_DIR=""
    BASE_DIR="$OUT_DIR/$BASE_DIR"
    [ -d "$BASE_DIR" ] || mkdir -p "$BASE_DIR"
    OUT="$OUT_DIR/${BASE}.html"
    DIFF="$OUT_DIR/${BASE}.diff"
    VALID="$VALID_DIR/${BASE}.html"
    TEMPLATE="${SOURCE}.template"

    printf "Generate: %s ..." "$BASE"
    [ ! -e "$TEMPLATE" ] || (cd "$SOURCE_DIR" && sh "$TEMPLATE") > "$SOURCE"
    if [ -n "$MODE_SHOW" ]; then
        echo
        MAX_LENGTH=$(( $(wc -L "$SOURCE" | awk '{print $1}') + 2 ))
        "$@" -h "$SOURCE" -db | tr -d '\r' | html2ans "$MAX_LENGTH"
        continue
    fi
    if [ -n "$MODE_PREVIEW" ]; then
        if [ -e "$TEMPLATE" ]; then
            echo " Skip."
            rm -f "$SOURCE"
            continue
        fi
        MAX_LENGTH=$(( $(wc -L "$SOURCE" | awk '{print $1}') + 2 ))
        PREVIEW_ANS="$PREVIEW_DIR/${BASE}.ans"
        if [ ! -e "$PREVIEW_ANS" ]; then
            echo " Preview doesn't exist. Skip as not needed."
            continue
        fi
        "$@" -h "$SOURCE" -db | tr -d '\r' | html2ans "$MAX_LENGTH" >"$PREVIEW_ANS"
    else
        "$@" -ht "$SOURCE" -dc -dh -ln -o "$OUT_DIR"/${BASE}.html -el debug -ed "$OUT_DIR"
    fi
    printf " OK"
    [ ! -e "$TEMPLATE" ] || rm -f "$SOURCE"

    if [ -n "$MODE_PREVIEW" ]; then
       printf "; Convert to SVG ..."
       PREVIEW_SVG="$PREVIEW_DIR/${BASE}.svg"
       if command -v ansisvg >/dev/null 2>&1; then
           ansisvg < "$PREVIEW_ANS" > "$PREVIEW_SVG"
           echo " OK"
       else
           echo " Failed. ansisvg not found."
       fi
       continue
    fi

    if [ -n "$MODE_CREATE" ]; then
        printf "; Save ..."
        cp -f "$OUT" "$VALID"
        echo " OK"
        continue
    fi

    if [ ! -e "$VALID" ]; then
        echo "; Skip."
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

[ -z "$MODE_PREVIEW" ] || exit 0

echo
printf "Check logs ..."
if grep -q -E '\[(warning|error)\]' "$LOG_FILE"; then
    echo " NOT OK"
    grep --color=auto -E '\[(warning|error)\]' "$LOG_FILE"
else
    echo " OK"
fi
