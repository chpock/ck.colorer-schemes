#!/usr/bin/env bash

set -e

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"
! command -v cygpath >/dev/null 2>&1 || SELF_DIR="$(cygpath -m "$SELF_DIR")"

BIN_DIR="$SELF_DIR/bin"
SOURCE_DIR="$SELF_DIR/source"
OUT_DIR="$SELF_DIR/_out"
SCHEMES_DIR="$SELF_DIR/../hrc"
LOG_FILE="$OUT_DIR"/consoletools.log

MASKS="$1"

if [ -z "$MASKS" ]; then
    echo "Usage: $0 <sample file to watch>"
    exit 1
fi

if [ "$(uname -o)" = "Cygwin" ]; then
    COLORER_BIN="colorer.exe"
else
    COLORER_BIN="colorer"
fi

set -- "$BIN_DIR/$COLORER_BIN" -c "$BIN_DIR"/catalog.xml -i gruvbox_dark_hard -el debug -ed "$OUT_DIR"

HRD_FILE="$BIN_DIR"/gruvbox_dark_hard.hrd

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

    if [ -n "$BASE" ] && [ -z "$FAIL_MULTIPLE_BASE" ]; then
        echo "Error - multiple files match specified mask:"
        echo "  $BASE"
        FAIL_MULTIPLE_BASE=1
    fi

    BASE="${SOURCE##$SOURCE_DIR/}"

    BASE_DIR="${BASE%/*}"
    # Skip tree-sitter-bash tests as for now
    [ "$BASE_DIR" != "tree-sitter-bash" ] || continue
    [ "$BASE" != "$BASE_DIR" ] || BASE_DIR=""
    BASE_DIR="$OUT_DIR/$BASE_DIR"
    [ -d "$BASE_DIR" ] || mkdir -p "$BASE_DIR"
    OUT="$OUT_DIR/${BASE}.html"
    DIFF="$OUT_DIR/${BASE}.diff"
    VALID="$VALID_DIR/${BASE}.html"
    TEMPLATE="${SOURCE}.template"

    if [ -n "$FAIL_MULTIPLE_BASE" ]; then
        echo "  $BASE"
    fi

    SOURCE_LIVE="$SOURCE"

done

if [ -n "$FAIL_MULTIPLE_BASE" ]; then
    echo
    exit 1
fi

if [ -z "$SOURCE_LIVE" ]; then
    echo
    echo "Error - could not find source for mask '$MASKS'"
    exit 1
fi

MAX_LENGTH=$(( $(wc -L "$SOURCE" | awk '{print $1}') + 2 ))

while true; do
    CURRENT_STATE="$(/bin/ls -Rla "$SCHEMES_DIR")$(/bin/ls -la "$SOURCE_LIVE")"
    if [ "$CURRENT_STATE" != "$OLD_STATE" ]; then
        rm -f "$LOG_FILE"
        clear
        "$@" -h "$SOURCE_LIVE" -db | tr -d '\r' | html2ans "$MAX_LENGTH" | head -n $(( $(tput lines) - 1 ))
        if grep -q -P '\[(warning|error)\](?!\s+Duplicate prototype\s+)' "$LOG_FILE"; then
            grep --color=auto -P '\[(warning|error)\](?!\s+Duplicate prototype\s+)' "$LOG_FILE"
        fi
        OLD_STATE="$CURRENT_STATE"
    fi
    sleep 1
done


