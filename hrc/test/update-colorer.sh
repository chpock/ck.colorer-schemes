#!/bin/bash

set -e

if ! command -v 7z >/dev/null 2>&1; then
    echo "7z is not installed!" >&2
    exit 1
fi

while IFS= read -r line; do
    case "$line" in
        */colorer.x64.v*.7z)
            URL_WIN="$line"
            ;;
        */colorer.x64.v*.tar.gz)
            URL_LIN="$line"
            ;;
    esac
done < <(curl -s https://api.github.com/repos/colorer/Colorer-library/releases/latest | grep 'browser_download_url' | cut -d'"' -f4)

if [ -z "$URL_WIN" ]; then
    echo "Could not find Windows URL!" >&2
    exit 1
fi

if [ -z "$URL_LIN" ]; then
    echo "Could not find Linux URL!" >&2
    exit 1
fi

cd "$(dirname "$0")/bin"

echo "Downloading Windows binary from: $URL_WIN"
TEMP_FILE="$(mktemp)"
curl -s -L "$URL_WIN" > "$TEMP_FILE"
7z x -bd -bso0 -bsp0 -aoa "$TEMP_FILE"
rm -f "$TEMP_FILE"
chmod +x ./colorer.exe

echo "Downloading Linux binary from: $URL_LIN"
curl -s -L "$URL_LIN" | tar xz
chmod +x ./colorer


