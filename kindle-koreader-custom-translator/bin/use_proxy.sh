#!/bin/sh
# Redirect all output to a log file in the extension directory
LOG_FILE="$(dirname "$0")/../proxy.log"
exec >> "$LOG_FILE" 2>&1

echo "------------------------------------------------"
echo "Use proxy script started at $(date)"

tmp_cleanup() {
    [ -f "$1" ] && rm -f "$1"
}

# Try to show message on Kindle screen
msg() {
    echo "$1"
    if command -v eips >/dev/null 2>&1; then
        eips 10 35 "$1"
    fi
}

msg "Apply proxy..."

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Always ensure latest install before switching endpoint
msg "Running install first..."
sh "${SCRIPT_DIR}/install.sh"

# Auto-detect KOReader directory if not set
if [ -z "${KO_DIR}" ]; then
    if [ -d "/mnt/onboard/.adds/koreader" ]; then
        KO_DIR="/mnt/onboard/.adds/koreader" # Kobo
    elif [ -d "/koreader" ]; then
        KO_DIR="/koreader" # Some Linux/Android setups
    else
        KO_DIR="/mnt/us/koreader" # Kindle default
    fi
fi

DEST_FILE="${KO_DIR}/frontend/ui/translator.lua"
TMP_PATCH="${PARENT_DIR}/translator.lua.proxy.tmp"
ORIG_ENDPOINT='local CUSTOM_ENDPOINT = "https://translate.api.tokisaki.top/translate"'
PROXY_ENDPOINT='local CUSTOM_ENDPOINT = "https://translate-proxy.api.tokisaki.top/translate"'

[ -f "$DEST_FILE" ] || { msg "translator.lua not found: ${DEST_FILE}"; exit 1; }

if grep -q "$PROXY_ENDPOINT" "$DEST_FILE"; then
    msg "Proxy endpoint already applied"
    exit 0
fi

if grep -q "$ORIG_ENDPOINT" "$DEST_FILE"; then
    if sed "s|$ORIG_ENDPOINT|$PROXY_ENDPOINT|" "$DEST_FILE" > "$TMP_PATCH"; then
        mv "$TMP_PATCH" "$DEST_FILE"
        sync
        msg "Switched to proxy endpoint"
    else
        tmp_cleanup "$TMP_PATCH"
        msg "Failed to patch endpoint"
        exit 1
    fi
else
    msg "Original endpoint not found; no changes made"
fi

tmp_cleanup "$TMP_PATCH"
msg "Done"
