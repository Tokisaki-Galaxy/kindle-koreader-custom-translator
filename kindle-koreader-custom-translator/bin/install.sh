#!/bin/sh
set -e

KO_DIR="${KO_DIR:-/mnt/us/koreader}"
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_FILE="${SRC_DIR}/translator.lua"
DEST_DIR="${KO_DIR}/frontend/ui"
DEST_FILE="${DEST_DIR}/translator.lua"
BACKUP_FILE="${DEST_FILE}.bak"

echo "[Custom Translator] Install start"
[ -f "${SRC_FILE}" ] || { echo "Source file not found: ${SRC_FILE}"; exit 1; }

mkdir -p "${DEST_DIR}"

if [ ! -f "${BACKUP_FILE}" ] && [ -f "${DEST_FILE}" ]; then
    echo "Backup original file -> ${BACKUP_FILE}"
    cp -p "${DEST_FILE}" "${BACKUP_FILE}"
fi

echo "Deploy custom translator -> ${DEST_FILE}"
cp -p "${SRC_FILE}" "${DEST_FILE}"
sync
echo "[Custom Translator] Install complete"