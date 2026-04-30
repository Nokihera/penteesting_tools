# 🐚 Reverse Shell Generator & Listener

A versatile automation utility designed to rapidly generate various reverse shell payloads and instantly initialize a local listener. This tool is optimized for penetration testing workflows and CTF environments where speed and payload variety are critical.

---

## ✨ Features

*   **Multi-Language Payloads**: Supports a wide array of environments:
    *   **Bash**: Standard `/dev/tcp` redirection.
    *   **Python**: Interactive PTY spawn for enhanced shell stability.
    *   **Netcat**: Traditional FIFO pipe method for standard NC versions.
    *   **PHP**: System execution for web server exploitation.
    *   **Lua**: Socket-based payloads for specialized targets.
    *   **Busybox**: Minimalist NC execution for embedded systems.
*   **Integrated Listener**: Seamlessly transitions from payload generation to catching the shell using `netcat`.
*   **Interactive CLI**: Simple, prompt-based interface for entering `LHOST` and `LPORT`.
*   **Branded UI**: Features a clean ASCII art header and color-coded status updates.

---

## 🛠️ Requirements

Ensure the following utilities are installed on your attack machine:

*   **Bash**: The script is written for Bash 4.0+.
*   **Netcat (`nc`)**: Required both for the standard payload and to initialize the listener.
*   **Target Dependencies**: The payload execution depends on the presence of the respective language (Python, PHP, Lua, etc.) on the target system.

---

## 🚀 Installation & Usage

### 1. Set Permissions
Make the script executable after cloning:
```bash
chmod +x rev_gen.sh
