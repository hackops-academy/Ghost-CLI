# Ghost-CLI v2.0 

**Ghost-CLI** is a high-speed, passive OSINT and reconnaissance tool designed to bypass search engine restrictions. By leveraging historical archives and SSL certificate transparency logs, it uncovers subdomains, forgotten endpoints, and sensitive files without ever sending a single packet to the target server or being blocked by Google CAPTCHAs.

---

# 🚀 Key Features

**🛡️ Passive Recon:** Gathers data from 3rd-party archives so your IP never touches the target.

**🔎 Wayback Crawler:** Pulls thousands of historical URLs to find old config, backup, and admin paths.

**🔐 Cert-Log Discovery:** Uses Certificate Transparency logs to find subdomains that aren't even indexed on Google.

**⚡ Secret Scanner:** Built-in regex engine to scan archived URLs for potential API keys and tokens.

**📂 Auto-Workspace:** Automatically organizes every scan into a dedicated ghost_results/ folder.

---

# 📥 Installation

**1. Clone & Set Permissions**
```bash
git clone https://github.com/hackops-academy/Ghost-CLI.git
cd Ghost-CLI
chmod +x ghost.sh
```
**2. Run the tool**
```bash
./ghost.sh target.com
```

---

# 📂 Output Structure
Every scan creates a timestamped folder to keep your data organized:
```text

ghost_results/example.com_20251228/
├── subdomains.txt       # Discovered subdomains from SSL logs
├── all_urls.txt         # Full history from Wayback Machine
├── sensitive_paths.txt  # Filtered list (.php, .env, .sql, etc.)
└── potential_secrets.txt # Flagged URLs containing 'token' or 'key'
```

---

# 🛡️ Disclaimer
This tool is for educational purposes and authorized security auditing only. The author is not responsible for any misuse. Always respect the legal boundaries of OSINT gathering.

**Developed by Hackops Academy**
