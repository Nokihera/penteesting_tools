# 🎬 Movie Downloader (Wget-Resume)

A lightweight, robust CLI utility built to handle large video downloads with ease. This script leverages the power of `wget` to provide a "resume-capable" download experience, ensuring that network interruptions don't force you to restart your progress from zero.

---

## ✨ Features

*   **Resume Support**: Uses the `-c` (continue) flag to pick up exactly where a download left off after a disconnect.
*   **Optimized Progress Bar**: Features a clean, forced-bar progress interface (`--progress=bar:force:noscroll`) for a better terminal experience.
*   **Custom Naming**: Allows you to define the output filename immediately, keeping your library organized from the start.
*   **Desktop Notifications**: Integrates with `notify-send` to alert you when a long download is finally finished.
*   **Organized Storage**: Automatically routes all completed downloads to your `~/Videos/` directory.
*   **Branded UI**: Includes a custom ASCII "Monitor" header and color-coded interactive prompts.

---

## 🛠️ Requirements

*   **Operating System**: Linux (Tested on Arch Linux).
*   **Shell**: Bash.
*   **Dependencies**: 
    *   `wget`: The primary download engine.
    *   `libnotify`: Required for desktop notifications.

---

## 🚀 Installation & Usage

### 1. Set Permissions
Make the script executable:
```bash
chmod +x downloader.sh
