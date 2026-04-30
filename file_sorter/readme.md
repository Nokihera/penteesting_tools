# 📂 File Sorter (SortMe)

A minimalist, automated file organization script designed to keep your Downloads folder clean and structured. It uses efficient one-liner move operations combined with a visual progress bar and desktop notifications to provide a smooth, "ultra-clean" terminal experience.

---

## ✨ Features

*   **Automated Categorization**: Instantly identifies and moves files based on their extensions:
    *   **Images**: `.jpg`, `.png` ➔ `~/Pictures`
    *   **Documents**: `.pdf`, `.txt` ➔ `~/Documents`
    *   **Videos**: `.mp4` ➔ `~/Videos`
    *   **Music**: `.mp3`, `.flac` ➔ `~/Music`
*   **Visual Progress Bar**: Features a color-coded ASCII progress bar to provide real-time feedback during the sorting process.
*   **Desktop Integration**: Sends a system-level notification via `notify-send` upon completion, perfect for headless or background execution.
*   **Minimalist UI**: Branded with a custom ASCII "PC" header and clean, bold color definitions.
*   **Error Suppression**: Silently handles cases where specific file types are missing, ensuring a crash-free experience.

---

## 🛠️ Requirements

*   **Operating System**: Linux (Optimized for Arch Linux/GNOME).
*   **Shell**: Bash.
*   **Dependencies**: 
    *   `libnotify`: Required for the `notify-send` command to work.
    *   Standard Linux core utilities (`mv`, `mkdir`, `sleep`).

---

## 🚀 Installation & Usage

### 1. Set Permissions
Make the script executable:
```bash
chmod +x autosorter.sh
