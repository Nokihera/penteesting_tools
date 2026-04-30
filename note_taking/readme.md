# 🔐 Secure Encrypted Notes

A minimalist, CLI-based note-taking utility designed for security-conscious users. This tool uses **GPG (GNU Privacy Guard)** to ensure that your notes are never stored in plain text, providing a secure vault for sensitive information directly in your terminal.

---

## ✨ Features

*   **Asymmetric Encryption**: Leverages GPG to encrypt data using a specific GPG ID.
*   **Persistence with Security**: Automatically decrypts existing notes, appends new entries, and re-encrypts the entire database in one seamless workflow.
*   **Zero-Trace Design**: Uses temporary file handling and automated cleanup (`trap` signals) to ensure plain-text data is removed if the process is interrupted.
*   **Configuration Management**: Remembers your GPG ID after the first setup to streamline future note-taking.
*   **Robust Error Handling**: Validates passphrases during the decryption phase to prevent data corruption or unauthorized access.

---

## 🛠️ Requirements

*   **Operating System**: Linux (Tested on Arch Linux).
*   **Shell**: Bash.
*   **Dependencies**: 
    *   `gpg`: GNU Privacy Guard must be installed and configured with at least one valid key pair.

---

## 🚀 Installation & Usage

### 1. Set Permissions
Make the script executable:
```bash
chmod +x note.sh
