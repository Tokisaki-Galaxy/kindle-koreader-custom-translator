#!/bin/sh
# Redirect all output to a log file in the extension directory
LOG_FILE="$(dirname "$0")/../restore.log"
exec >> "$LOG_FILE" 2>&1

echo "------------------------------------------------"
echo "Restore script started at $(date)"

# Try to show message on Kindle screen
msg() {
    echo "$1"
    if command -v eips >/dev/null 2>&1; then
        eips 10 35 "$1"
    fi
}

msg "Restoring..."

set -e

# Auto-detect KOReader directory if not set
if [ -z "${KO_DIR}" ]; then
    if [ -d "/mnt/onboard/.adds/koreader" ]; then
        KO_DIR="/mnt/onboard/.adds/koreader" # Kobo
    elif [ -d "/koreader" ]; then
        KO_DIR="/koreader"
    else
        KO_DIR="/mnt/us/koreader" # Kindle default
    fi
fi

BACKUP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEST_FILE="${KO_DIR}/frontend/ui/translator.lua"
BACKUP_FILE="${BACKUP_DIR}/translator.lua.bak"

echo "Restore start"
if [ -f "${BACKUP_FILE}" ]; then
    echo "Restore backup -> ${DEST_FILE}"
    cp -p "${BACKUP_FILE}" "${DEST_FILE}"
    sync
    msg "Restore complete"
else
    msg "Backup file not found: ${BACKUP_FILE}"
    exit 1
fi