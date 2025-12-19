# KOReader Custom Translator

这是一个为 KOReader 设计的自定义翻译插件，旨在替换内置的翻译后端。它将翻译请求重定向到一个自定义的 API 端点（基于 Cloudflare Worker），通常用于解决官方翻译接口在某些网络环境下不可用或受限的问题，或者为了获得更好的翻译质量。

本项目作为一个 KUAL (Kindle Unified Application Launcher) 插件分发，但也支持在其他运行 KOReader 的设备（如 Kobo、Android）上通过脚本手动安装。

## ✨ 功能特点

- **自定义翻译源**：使用自定义的 API 端点 (`translate.api.tokisaki.top`) 替代默认后端。
- **广泛的语言支持**：支持多达 249 种语言，保留了 KOReader 原生的自动检测和拼音/罗马音功能。
- **一键安装/恢复**：
  - **Kindle**: 通过 KUAL 菜单一键安装补丁或恢复原版。
  - **其他设备**: 提供了自动化的 Shell 脚本进行安装和恢复。
- **安全备份**：安装脚本会自动检测并备份原有的 `translator.lua` 文件，确保可以随时还原。

## 📋 前置要求

- 已安装 **KOReader** (建议最新版本)。
- **Kindle 用户**: 需要越狱并安装 **KUAL** (Kindle Unified Application Launcher) 和 **MRPI** (MobileRead Package Installer)。
- **其他设备**: 需要有访问文件系统和运行 Shell 脚本的权限（通常通过终端或 SSH）。

## 🚀 安装指南

### 方法一：Kindle (通过 KUAL)

1. [下载本项目的最新Release版本](https://github.com/Tokisaki-Galaxy/kindle-koreader-custom-translator/releases)。
2. 将解压后的 `kindle-koreader-custom-translator` 复制到 Kindle 根目录下的 `extensions` 文件夹中。
   - 路径应为：`/mnt/us/extensions/kindle-koreader-custom-translator/`
4. 拔掉数据线，在 Kindle 上打开 **KUAL**。
5. 找到 **KOReader Custom Translator** 菜单。
6. 点击 **Install**。
   - 屏幕上方会显示安装状态。
   - 安装完成后，重启 KOReader 即可生效。

### 方法二：手动覆盖核心文件
如果你不使用 KUAL，可以手动替换 KOReader 的核心翻译文件。将项目文件夹中的 `translator.lua` 复制到 KOReader 的安装目录下的相应位置`pathtokoreader/frontend/ui/translator.lua`，覆盖原文件。

例如如果你使用Kindle，路径可能是 `/mnt/us/koreader/frontend/ui/translator.lua`。

### 方法三：手动安装 (Kobo, Android, Linux)

如果你无法使用 KUAL，可以通过终端手动运行安装脚本。脚本会自动检测常见的 KOReader 安装路径。

1. 将项目文件复制到设备上的任意位置。
2. 通过 SSH 或终端进入项目目录下的 `bin` 文件夹。
3. 运行安装脚本：
   ```bash
   sh install.sh
   ```
   或者，如果你需要指定 KOReader 的安装路径：
   ```bash
   export KO_DIR=/path/to/your/koreader
   sh install.sh
   ```

## 📖 使用方法

安装完成后，在 KOReader 中阅读文档时：
1. 长按选中一段文本。
2. 点击弹出菜单中的 **翻译 (Translate)** 按钮。
3. 翻译结果将通过自定义的 API 获取并显示。

## 🔄 恢复原版 (卸载)

如果你想恢复 KOReader 自带的翻译功能：

### Kindle (KUAL)
1. 打开 **KUAL** -> **KOReader Custom Translator**。
2. 点击 **Restore**。
3. 提示恢复成功后，重启 KOReader。

### 手动恢复
运行 `bin` 目录下的恢复脚本：
```bash
sh restore.sh
```

## ⚠️ 注意事项

- **文件覆盖**：本插件通过替换 KOReader 的核心文件 `frontend/ui/translator.lua` 工作。虽然有备份机制，但在更新 KOReader 主程序后，该文件会被官方版本覆盖，你需要重新运行安装脚本。
- **网络连接**：请确保你的设备连接到了互联网，且能够访问自定义的翻译 API 域名。

## 🛠️ 故障排除

- **安装后 KOReader 崩溃**：
  - 可能是版本不兼容。请尝试运行 **Restore** 恢复原版。
  - 检查 `install.log` (位于插件目录下) 获取详细错误信息。
- **翻译显示“网络错误”**：
  - 检查 Wi-Fi 连接。
  - 确认 API 端点是否在线。

## 📄 许可证

MIT License
