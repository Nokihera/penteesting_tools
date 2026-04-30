# 🔍 Recon Tool v1.4 (Fixed Logic)

A high-performance automated network reconnaissance and web enumeration script designed for security researchers and penetration testers. This tool automates the workflow from initial port discovery to deep service analysis and web directory brute-forcing.

---

## ✨ Features

*   **Fast Port Discovery**: Scans all 65,335 TCP ports using high-speed synchronization (`--min-rate 5000`).
*   **Precision Extraction**: Uses advanced regex logic to extract open ports from grepable Nmap output for the next phase.
*   **Deep Enumeration**: Automatically runs a detailed scan (`-A`) targeting only identified open ports to save time and bandwidth.
*   **Intelligent Web Detection**: Identifies HTTP and HTTPS services (including SSL/TLS detection) to determine the correct protocol for further testing.
*   **Automated Brute-Forcing**: Integrates with `gobuster` to perform directory enumeration if web services are detected.
*   **Organized Output**: Automatically manages results in the `~/outputfiles/` directory with clean naming conventions.

---

## 🛠️ Requirements

Before running the script, ensure the following tools are installed on your Linux system:

*   **Nmap**: The core engine for network discovery.
*   **Gobuster**: Used for URI (directory and file) brute-forcing.
*   **Sudo Privileges**: Required for Nmap raw socket scans and advanced service detection.
*   **Wordlists**: A valid path to a wordlist (e.g., SecLists or `/usr/share/wordlists/dirb/common.txt`) for directory discovery.

---

## 🚀 Installation & Usage

### 1. Set Permissions
Make the script executable after cloning or downloading:
```bash
chmod +x recon.sh
