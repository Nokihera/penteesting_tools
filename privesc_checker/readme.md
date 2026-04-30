# 🐧 Linux Privilege Escalation Checker

A specialized security auditing script designed to identify common local privilege escalation vectors on Linux systems. This tool automates the tedious process of searching for misconfigurations, vulnerable binaries, and weak permissions.

---

## ⚠️ Legal Disclaimer

**WARNING: This tool is provided for educational and authorized security testing purposes only.**

- ✅ **DO USE** this script on systems you own or have explicit written permission to test.
- ✅ **DO USE** in authorized CTF environments (TryHackMe, HackTheBox, etc.).
- ❌ **DO NOT USE** on production systems or networks without proper authorization.

The author assumes **NO liability** for any damage or legal issues caused by the misuse of this script.

---

## ✨ Key Features

*   **Kernel Version Audit**: Automatically compares the current kernel version against a known list of vulnerable kernels (e.g., Dirty COW, etc.).
*   **SUID Binary Analysis**: Scans the filesystem for SUID binaries and cross-references them with a built-in "dangerous list" for GTFOBins exploitation.
*   **Capabilities Check**: Inspects file capabilities to find non-standard privileges that could lead to escalation.
*   **Path & Python Environment**: Audits the system `PATH` and Python `sys.path` to identify potential hijacking or injection points.
*   **Cronjob & User Discovery**: Lists active cronjobs and identifies all users with valid Bash access.
*   **Sudo Rights Enumeration**: Executes `sudo -l` to check for passwordless command execution.
*   **Deep Filesystem Audit**: Optional feature to find globally writable directories and files (excluding `/proc`, `/sys`, and `/dev`).

---

## 🛠️ Requirements

*   **Operating System**: Linux (Tested on Arch Linux, Ubuntu, Kali).
*   **Shell**: Bash 4.0+.
*   **Dependencies**: `getcap`, `grep`, `find`, `python3`, and `sudo`.

---

## 🚀 Installation & Usage

### 1. Set Execution Permissions
```bash
chmod +x privesc.sh
