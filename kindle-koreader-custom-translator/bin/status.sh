#!/bin/sh
# Redirect all output to a log file in the extension directory
LOG_FILE="$(dirname "$0")/../status.log"
exec >> "$LOG_FILE" 2>&1

# --- eips/fbink helpers (borrowed from NiLuJe's multi-line display helpers) ---
EIPS_SLEEP=false

kmfc="$(cut -c1 /proc/usid 2>/dev/null || true)"
if [ "${kmfc}" = "B" ] || [ "${kmfc}" = "9" ]; then
    kmodel="$(cut -c3-4 /proc/usid 2>/dev/null || true)"
    case "${kmodel}" in
        13|54|2A|4F|52|53)
            SCREEN_X_RES=1088
            SCREEN_Y_RES=1448
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        24|1B|1D|1F|1C|20|D4|5A|D5|D6|D7|D8|F2|17|60|F4|F9|62|61|5F)
            SCREEN_X_RES=768
            SCREEN_Y_RES=1024
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        C6|DD)
            SCREEN_X_RES=608
            SCREEN_Y_RES=800
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        0F|11|10|12)
            SCREEN_X_RES=600
            SCREEN_Y_RES=800
            EIPS_X_RES=12
            EIPS_Y_RES=20
        ;;
        *)
            SCREEN_X_RES=600
            SCREEN_Y_RES=800
            EIPS_X_RES=12
            EIPS_Y_RES=20
        ;;
    esac
else
    kmodel="$(cut -c4-6 /proc/usid 2>/dev/null || true)"
    case "${kmodel}" in
        0G1|0G2|0G4|0G5|0G6|0G7|0KB|0KC|0KD|0KE|0KF|0KG|0LK|0LL)
            SCREEN_X_RES=1088
            SCREEN_Y_RES=1448
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        0GC|0GD|0GR|0GS|0GT|0GU)
            SCREEN_X_RES=1088
            SCREEN_Y_RES=1448
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        0DU|0K9|0KA)
            SCREEN_X_RES=608
            SCREEN_Y_RES=800
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        0LM|0LN|0LP|0LQ|0P1|0P2|0P6|0P7|0P8|0S1|0S2|0S3|0S4|0S7|0SA)
            SCREEN_X_RES=1280
            SCREEN_Y_RES=1680
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        0PP|0T1|0T2|0T3|0T4|0T5|0T6|0T7|0TJ|0TK|0TL|0TM|0TN|102|103|16Q|16R|16S|16T|16U|16V)
            SCREEN_X_RES=1088
            SCREEN_Y_RES=1448
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        10L|0WF|0WG|0WH|0WJ|0VB)
            SCREEN_X_RES=608
            SCREEN_Y_RES=800
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        11L|0WQ|0WP|0WN|0WM|0WL)
            SCREEN_X_RES=1280
            SCREEN_Y_RES=1680
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        1LG|1Q0|1PX|1VD|219|21A|2BH|2BJ|2DK)
            SCREEN_X_RES=1236
            SCREEN_Y_RES=1648
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        22D|25T|23A|2AQ|2AP|1XH|22C)
            SCREEN_X_RES=1848
            SCREEN_Y_RES=2464
            EIPS_X_RES=16
            EIPS_Y_RES=24
        ;;
        *)
            SCREEN_X_RES=600
            SCREEN_Y_RES=800
            EIPS_X_RES=12
            EIPS_Y_RES=20
        ;;
    esac
fi

EIPS_MAXCHARS=$((SCREEN_X_RES / EIPS_X_RES))
EIPS_MAXLINES=$((SCREEN_Y_RES / EIPS_Y_RES))

FBINK_BIN=true
for my_hackdir in linkss linkfonts libkh usbnet; do
    my_fbink="/mnt/us/${my_hackdir}/bin/fbink"
    if [ -x "${my_fbink}" ]; then
        FBINK_BIN="${my_fbink}"
        break
    fi
done

has_fbink() {
    [ "${FBINK_BIN}" != "true" ]
}

do_fbink_print() {
    # $1 = string, $2 = y-shift-up
    ${FBINK_BIN} -qpm -y $((-4 - $2)) "$1"
}

do_eips_print() {
    kh_eips_string="$1"
    kh_eips_y_shift_up="$2"
    kh_eips_strlen=${#kh_eips_string}
    kh_padlen=$(((EIPS_MAXCHARS - kh_eips_strlen) / 2))
    while [ ${#kh_eips_string} -lt $((kh_eips_strlen + kh_padlen)) ]; do
        kh_eips_string=" ${kh_eips_string}"
    done
    while [ ${#kh_eips_string} -lt ${EIPS_MAXCHARS} ]; do
        kh_eips_string="${kh_eips_string} "
    done
    eips 0 $((EIPS_MAXLINES - 2 - kh_eips_y_shift_up)) "${kh_eips_string}" >/dev/null
}

eips_print_bottom_centered() {
    [ $# -lt 2 ] && return
    kh_eips_string="$1"
    kh_eips_y_shift_up="$2"
    if [ "${EIPS_SLEEP}" = "true" ]; then
        usleep 150000
    fi
    if has_fbink; then
        do_fbink_print "${kh_eips_string}" ${kh_eips_y_shift_up}
    else
        do_eips_print "${kh_eips_string}" ${kh_eips_y_shift_up}
    fi
}

msg() {
    text="$1"
    # Convert literal \n into real newlines for both stdout and eips/fbink
    normalized="$(printf "%s" "$text" | sed 's/\\n/\n/g')"
    printf "%s\n" "$normalized"
    if command -v eips >/dev/null 2>&1; then
        offset=0
        printf "%s\n" "$normalized" | while IFS= read -r ln; do
            eips_print_bottom_centered "$ln" "$offset"
            offset=$((offset + 1))
        done
    fi
}

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
DEST_DIR="${KO_DIR}/frontend/ui"
DEST_FILE="${DEST_DIR}/translator.lua"
BACKUP_FILE="${SRC_DIR}/translator.lua.bak"
dest_status="missing"
backup_status="missing"
showmsg=""

msg "Checking installation status..."

if [ -f "${DEST_FILE}" ]; then
    dest_status="existing"
fi

if [ -f "${BACKUP_FILE}" ]; then
    backup_status="existing"
fi

showmsg="DEST_FILE: ${dest_status}\n"
showmsg="BACKUP_FILE: ${backup_status}\n${showmsg}"

if [ ! -f "${DEST_FILE}" ]; then
    showmsg="translator.lua not found; cannot determine version${showmsg}"
    msg "$showmsg"
    exit 1
else
    if head -n 3 "${DEST_FILE}" | tr -d '\r' | grep -q "Custom Translate"; then
        showmsg="Custom translator detected\n${showmsg}"
    else
        showmsg="Original translator detected\n${showmsg}"
    fi
    msg "$showmsg"
fi
