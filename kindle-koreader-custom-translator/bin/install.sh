#!/bin/sh
# Redirect all output to a log file in the extension directory
LOG_FILE="$(dirname "$0")/../install.log"
exec >> "$LOG_FILE" 2>&1

echo "------------------------------------------------"
echo "Install script started at $(date)"
echo "Running as user: $(whoami)"
echo "Current directory: $(pwd)"

# Try to show message on Kindle screen
msg() {
    echo "$1"
    if command -v eips >/dev/null 2>&1; then
        eips 10 35 "$1"
    fi
}

msg "Installing..."

set -e

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

SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_FILE="${SRC_DIR}/translator.lua"
TMP_DOWNLOAD="${SRC_DIR}/translator.lua.download"
DEST_DIR="${KO_DIR}/frontend/ui"
DEST_FILE="${DEST_DIR}/translator.lua"
BACKUP_FILE="${SRC_DIR}/translator.lua.bak"

# Try to fetch the latest release version from GitHub; fall back to local file if offline.
if command -v wget >/dev/null 2>&1; then
    GITHUB_API="https://api.github.com/repos/Tokisaki-Galaxy/kindle-koreader-custom-translator/releases/latest"
    TAG_NAME="$(wget -qO- --timeout=5 "$GITHUB_API" | sed -n 's/  "tag_name": "\(.*\)",/\1/p' | head -n 1)"
    if [ -n "$TAG_NAME" ]; then
        REMOTE_URL="https://raw.githubusercontent.com/Tokisaki-Galaxy/kindle-koreader-custom-translator/${TAG_NAME}/kindle-koreader-custom-translator/translator.lua"
        msg "Online detected. Trying release ${TAG_NAME}"
        if wget -qO "$TMP_DOWNLOAD" --timeout=15 "$REMOTE_URL"; then
            if [ -s "$TMP_DOWNLOAD" ]; then
                SRC_FILE="$TMP_DOWNLOAD"
                msg "Downloaded latest translator.lua from release ${TAG_NAME}"
            else
                msg "Downloaded file is empty, using local translator.lua"
                rm -f "$TMP_DOWNLOAD"
            fi
        else
            msg "Download failed, using local translator.lua"
        fi
    else
        msg "Cannot read release tag, using local translator.lua"
    fi
else
    msg "wget not found, using local translator.lua"
fi

msg "Install start"
[ -f "${SRC_FILE}" ] || { msg "Source file not found: ${SRC_FILE}"; exit 1; }

mkdir -p "${DEST_DIR}"

if [ -f "${DEST_FILE}" ]; then
    # Check if the file is already our custom translator
    if head -n 3 "${DEST_FILE}" | grep -q "This module translates text using Custom Translate"; then
        msg "Custom translator detected. Skipping backup."
    else
        # Always backup if the destination is NOT our custom file.
        # This ensures we save the current state (e.g. after a KOReader update).
        msg "Backup original file -> ${BACKUP_FILE}"
        cp -p "${DEST_FILE}" "${BACKUP_FILE}"
    fi
fi

msg "Deploy custom translator -> ${DEST_FILE}"
cp -p "${SRC_FILE}" "${DEST_FILE}"
sync
# Cleanup temp download if any
[ -f "$TMP_DOWNLOAD" ] && rm -f "$TMP_DOWNLOAD"
msg "Install complete"
