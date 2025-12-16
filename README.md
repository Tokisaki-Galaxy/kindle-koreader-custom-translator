# [WIP]KOReader Custom Translator

Custom translation backend for KOReader that swaps the built-in translator with a Cloudflare Worker–powered endpoint. Includes menu actions to install or restore the patched `translator.lua` directly from KOReader.

## Features
- 249-language support with auto-detect and romanization toggles (leverages KOReader's existing translator UI).
- One-tap install/restore via KOReader menu (`Install` to deploy, `Restore` to revert from backup).
- Safe deployment: first install backs up the original `translator.lua` to `translator.lua.bak` before overwriting.

## Requirements
- KOReader installed on the device (expected path `/mnt/us/koreader`).
- Network access to `https://translate.api.tokisaki.top/translate` (Cloudflare Worker endpoint).
- Shell execution available inside KOReader (used by the menu actions).

## Folder Structure
```
kindle-koreader-custom-translator/
├── config.xml           # Extension manifest
├── menu.json            # Adds Install/Restore entries to the KOReader menu
├── translator.lua       # Custom translator implementation
└── bin/
    ├── install.sh       # Deploys translator.lua, backing up the original
    └── restore.sh       # Restores translator.lua from .bak if present
```

## Installation (KOReader menu)
1. Copy the whole `koreader-custom-translator` directory into KOReader's extensions folder, e.g. `/mnt/us/koreader/extensions/`.
2. In KOReader, open the Extensions menu and tap **Install** under **KOReader Custom Translator**.
3. First run creates `translator.lua.bak` in `frontend/ui/` and deploys the custom `translator.lua`.

## Restore / Uninstall
- From the same menu, tap **Restore** to copy `translator.lua.bak` back over `translator.lua`.
- To fully remove, delete the extension folder after restoring, or manually replace `frontend/ui/translator.lua` with your preferred version.

## Manual install (fallback)
If the menu actions cannot run, deploy manually:
```sh
# on the device / over SSH
KO_DIR=/mnt/us/koreader
cp -p translator.lua "$KO_DIR/frontend/ui/translator.lua"
# create a backup yourself before overwriting if needed
```

## Configuration
- `KO_DIR` environment variable: override the KOReader root when running the scripts (default `/mnt/us/koreader`).
- Endpoint is hardcoded in `translator.lua` as `https://translate.api.tokisaki.top/translate`.

## Notes
- Scripts use `set -e`; they stop on the first error. Check the console/logs if an action exits unexpectedly.
- Ensure the `.sh` files remain executable on the device (e.g., `chmod +x bin/*.sh`).
