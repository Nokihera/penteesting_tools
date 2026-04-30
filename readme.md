## 👤 Author

**Min Zar Ni Htut (touchme)**
- **TryHackMe**: Master (Level 11) | Top 10 National Rank in Myanmar (April 2026).
- **Specialization**: Cybersecurity Research, Linux Automation, and Penetration Testing.
- **GitHub**: [@Nokihera](https://github.com/Nokihera)

---

## 📝 License

This project is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for the full text.

---
*Last updated: April 2026*Here is the complete, professionally structured **Main README.md** file for your repository. It reflects your new organized folder structure and follows a professional documentation style while maintaining your unique branding.
```markdown
# 🔒 Pentesting Tools Collection

A professional collection of custom penetration testing scripts and automation tools developed for security research, CTF challenges, and ethical hacking workflows.

---

## ⚠️ Legal Disclaimer

**WARNING: These tools are provided for educational and authorized security testing purposes only.**

- ✅ **DO USE** these tools on systems you own or have explicit written permission to test.
- ✅ **DO USE** in authorized penetration testing engagements and controlled lab environments.
- ❌ **DO NOT USE** on systems without proper authorization or for illegal activities.

**Unauthorized access to computer systems is illegal.** The author assumes **NO liability** and is **NOT responsible** for any misuse or damage caused by these scripts.

---

## 📋 Repository Overview

This repository is organized into specialized modules to enhance modularity and ease of use. Each directory contains a dedicated README with specific usage instructions.

### 🛠️ Modules & Tools

*   **[recon_tool](./recon_tool/)**: High-speed network reconnaissance and automated web enumeration using Nmap and Gobuster.
*   **[note_taking](./note_taking/)**: A secure, GPG-encrypted CLI note-taking utility designed for sensitive data persistence.
*   **[file_sorter](./file_sorter/)**: A minimalist Downloads folder organizer featuring an ASCII progress bar and system automation.
*   **[privesc_checker](./privesc_checker/)**: Scripts and utilities for identifying local privilege escalation vectors on Linux systems.
*   **[downloader](./downloader/)**: Specialized automation for streamlined file and resource retrieval.
*   **[reverse_shell_generator](./reverse_shell_generator/)**: A utility for rapidly generating various reverse shell payloads (Bash, Python, PHP, etc.).

---

## 🚀 Getting Started

### Prerequisites
Ensure your system has the following core utilities installed (specific to individual scripts):
- `bash` (4.0+)
- `gpg` (for note_taking)
- `nmap` & `gobuster` (for recon_tool)

### Installation
Clone the repository and set execution permissions for all modules:

```bash
git clone https://github.com/Nokihera/penteesting_tools.git
cd penteesting_tools
chmod +x */*.sh
