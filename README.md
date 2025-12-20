<p align="center">
  <h1 align="center">KOReader Custom Translator</h1>
  <p align="center">
    Replace built-in Google Translate with a custom API for better accessibility and quality.
    <br />
    <a href="README_zh.md"><strong>中文说明</strong></a>
    ·
    <a href="https://github.com/Tokisaki-Galaxy/kindle-koreader-custom-translator/issues">Report Bug</a>
    ·
    <a href="https://github.com/Tokisaki-Galaxy/kindle-koreader-custom-translator/issues">Request Feature</a>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/license/Tokisaki-Galaxy/kindle-koreader-custom-translator?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/v/release/Tokisaki-Galaxy/kindle-koreader-custom-translator?style=for-the-badge" alt="Release">
  <img src="https://img.shields.io/badge/Platform-Kindle%20%7C%20Kobo%20%7C%20Android%20%7C%20Linux-orange?style=for-the-badge" alt="Platform">
</p>

---

A custom translation plugin for KOReader designed to replace the built-in Google Translate backend. It redirects translation requests to a [custom API translation project](https://github.com/Tokisaki-Galaxy/translate-api/blob/master/README.md) to solve issues where the official Google Translate interface is unavailable or restricted in certain network environments, or to achieve better translation quality.

This project is distributed as a KUAL (Kindle Unified Application Launcher) extension, but also supports manual installation via scripts on other devices running KOReader (e.g., Kobo, Android).

## ✨ Features

- **Custom Translation Source**: Uses a custom API endpoint (`translate.api.tokisaki.top`) instead of the default backend.
- **Wide Language Support**: Supports up to 249 languages, preserving KOReader's native auto-detection and Pinyin/Romaji features.
- **One-click Install/Restore**:
  - **Kindle**: Install patches or restore the original version with one click via the KUAL menu.
  - **Other Devices**: Automated Shell scripts provided for installation and restoration.
- **Safe Backup**: The installation script automatically detects and backs up the original `translator.lua` file, ensuring you can revert at any time.

## 📋 Prerequisites

- **KOReader** installed (latest version recommended).
- **Kindle Users**: Jailbroken with **KUAL** (Kindle Unified Application Launcher) and **MRPI** (MobileRead Package Installer) installed.
- **Other Devices**: Permission to access the file system and run Shell scripts (usually via terminal or SSH).

## 🚀 Installation Guide

### Method 1: Kindle (via KUAL)

1. [Download the latest Release](https://github.com/Tokisaki-Galaxy/kindle-koreader-custom-translator/releases).
2. Copy the extracted `kindle-koreader-custom-translator` folder to the `extensions` folder on your Kindle's root directory.
   - Path should be: `/mnt/us/extensions/kindle-koreader-custom-translator/`
3. Unplug the USB cable and open **KUAL** on your Kindle.
4. Locate the **KOReader Custom Translator** menu.
5. Click **Install**.
   - Installation status will be displayed at the top of the screen.
   - After installation, restart KOReader for changes to take effect.

### Method 2: Manual Core File Replacement
If you don't use KUAL, you can manually replace KOReader's core translation file. Copy `translator.lua` from the project folder to the corresponding location in your KOReader installation directory: `pathtokoreader/frontend/ui/translator.lua`, overwriting the original file.

For example, on Kindle, the path might be `/mnt/us/koreader/frontend/ui/translator.lua`.

### Method 3: Manual Installation (Kobo, Android, Linux)

If you cannot use KUAL, you can run the installation script manually via terminal. The script automatically detects common KOReader installation paths.

1. Copy the project files to any location on your device.
2. Enter the `bin` folder in the project directory via SSH or terminal.
3. Run the installation script:
   ```bash
   sh install.sh
   ```
   Alternatively, if you need to specify the KOReader installation path:
   ```bash
   export KO_DIR=/path/to/your/koreader
   sh install.sh
   ```

## 📖 Usage

Once installed, while reading a document in KOReader:
1. Long-press to select a piece of text.
2. Click the **Translate** button in the popup menu.
3. Translation results will be fetched and displayed via the custom API.

## 🔄 Restore Original (Uninstall)

To restore KOReader's built-in translation functionality:

### Kindle (KUAL)
1. Open **KUAL** -> **KOReader Custom Translator**.
2. Click **Restore**.
3. After the success message, restart KOReader.

### Manual Restore
Run the restore script in the `bin` directory:
```bash
sh restore.sh
```

## ⚠️ Notes

- **File Overwrite**: This plugin works by replacing KOReader's core file `frontend/ui/translator.lua`. While there is a backup mechanism, this file will be overwritten by the official version after updating KOReader, and you will need to run the installation script again.
- **Network Connection**: Ensure your device is connected to the internet and can access the custom translation API domain.

## 🛠️ Troubleshooting

- **KOReader crashes after installation**:
  - Possible version incompatibility. Try running **Restore** to revert to the original.
  - Check `install.log` (in the plugin directory) for detailed error messages.
- **Translation shows "Network Error"**:
  - Check Wi-Fi connection.
  - Confirm if the API endpoint is online.

## 📄 License

MIT License

