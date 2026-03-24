# 🔒 Pentesting Tools Collection

A collection of custom penetration testing scripts and automation tools for security research and ethical hacking purposes.

## ⚠️ Legal Disclaimer

**WARNING: These tools are provided for educational and authorized security testing purposes only.**

- ✅ **DO USE** these tools on systems you own or have explicit written permission to test
- ✅ **DO USE** in authorized penetration testing engagements
- ✅ **DO USE** in controlled lab environments for learning
- ❌ **DO NOT USE** on systems without proper authorization
- ❌ **DO NOT USE** for any illegal or malicious activities

**Unauthorized access to computer systems is illegal in most jurisdictions.** The author(s) of these tools assume **NO liability** and are **NOT responsible** for any misuse or damage caused by these scripts. By using these tools, you agree to use them responsibly and legally.

## 📋 About

This repository contains custom-built scripts developed for penetration testing workflows, including:

- Network reconnaissance and enumeration
- Information gathering automation
- Security assessment utilities
- Target analysis tools

**Note:** These scripts are works in progress and may contain bugs or incomplete features. Use at your own risk in production environments.

## 🛠️ Current Tools

### `recon`
Automated network reconnaissance and web enumeration tool

**Features:**
- 🎨 Custom ASCII banner display
- 🚀 Fast full port scanning (all 65535 ports)
- 🔍 Detailed service detection and enumeration
- 🌐 Intelligent web service detection (HTTP/HTTPS)
- 📁 Automatic directory brute-forcing with Gobuster
- 💾 Organized output file management
- ⚡ Multi-threaded scanning for speed

**Requirements:**
- `nmap` - Network reconnaissance tool
- `gobuster` - Directory/file brute-forcing tool
- `sudo` privileges for advanced scanning
- Wordlist file (e.g., `/usr/share/wordlists/dirb/common.txt`)

**Installation:**
```bash
# Install required tools (Debian/Ubuntu)
sudo apt update
sudo apt install nmap gobuster -y

# Make script executable
chmod +x recon
```

**Usage:**
```bash
# Run the script
./recon

# Follow the prompts:
# 1. Enter target IP/hostname
# 2. Enter output filename
# 3. If web services found, enter wordlist path
```

**Example Session:**
```bash
touchme@Lenovo-Yoga:~/pentesting_tools/myscripts$ ./recon

           [+] TOUCHME RECON TOOL v1.1
------------------------------------------------
Enter your target machine: 192.168.1.100
Enter your output file name: target_scan

[+] Step 1: Scanning 192.168.1.100 for all ports (Fast Scan)...
[+] Open ports found: 22,80,443

[+] Step 2: Running Detailed Scan (-A) on ports: 22,80,443
[!] Web services detected on ports: 80 443

Enter your wordlist path: /usr/share/wordlists/dirb/common.txt
[+] Starting Gobuster on port 80...
[+] Starting Gobuster on port 443...

------------------------------------------------
[*] All processes finished! Happy Hunting!
```

**Output Files:**
All scan results are saved in `~/outputfiles/`:
- `<filename>` - Initial fast port scan results
- `<filename>_detailed.txt` - Detailed service enumeration
- `<filename>_gobuster_port_<port>.txt` - Directory brute-force results per web port

**Workflow:**
1. **Fast Scan**: Quick discovery of all open ports (--min-rate 5000)
2. **Port Extraction**: Automatically parse open ports from results
3. **Detailed Scan**: Deep enumeration with `-A` flag (service detection, OS detection, scripts)
4. **Web Detection**: Identifies HTTP/HTTPS services on any port
5. **Directory Enumeration**: Runs Gobuster against detected web services

## 📦 Installation

```bash
# Clone the repository
git clone https://github.com/Nokihera/penteesting_tools.git

# Navigate to the directory
cd penteesting_tools

# Make scripts executable
chmod +x recon
```

## 🔧 Requirements

- **Operating System**: Linux/Unix environment (tested on Ubuntu/Kali)
- **Shell**: Bash 4.0+
- **Tools**:
  - `nmap` - Network scanner
  - `gobuster` - Directory/file brute-forcer
  - `sudo` - Root privileges for advanced scans
- **Other**:
  - Wordlists for directory enumeration (e.g., SecLists, dirb wordlists)
  - Active network connection
  - Proper authorization for target systems

## 📚 Resources

For learning ethical hacking and penetration testing:
- [OWASP](https://owasp.org/)
- [HackTheBox](https://www.hackthebox.com/)
- [TryHackMe](https://tryhackme.com/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📝 License

This project is provided as-is for educational purposes. Use responsibly.

## 👤 Author

**Nokihera**
- GitHub: [@Nokihera](https://github.com/Nokihera)

## 🙏 Acknowledgments

- The infosec community for knowledge sharing
- All the researchers and developers whose tools inspired this project

---

**Remember:** With great power comes great responsibility. Always obtain proper authorization before testing any system.

*Last updated: March 2026*
