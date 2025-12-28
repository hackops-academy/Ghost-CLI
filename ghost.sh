#!/usr/bin/env bash
# ===============================================================
# GhostArchive-CLI v2.0 - Professional Recon & Secret Scanner
# Optimized for Kali Linux & Termux (Universal)
# ===============================================================

# --- COLORS ---
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'

# --- GLOBALS ---
TARGET="$1"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULT_DIR="ghost_results/${TARGET}_${TIMESTAMP}"

banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
  ________  .__                     __      
 /  _____/  |  |__    ____   ______/  |_    
/   \  ___  |  |  \  /  _ \ /  ___/\   __\   
\    \_\  \ |   Y  \(  <_> )\___ \  |  |     
 \______  / |___|  / \____//____  > |__|     
        \/       \/             \/         

        Made by Hackops Academy | _hack_ops_
EOF
    echo -e "${BLUE}  [+] Workspace: ${WHITE}$RESULT_DIR"
    echo -e "${BLUE}  [+] Mode: Passive Recon + Secret Scanning"
    echo -e "${CYAN}---------------------------------------------------------------${NC}"
}

prepare_env() {
    echo -e "${YELLOW}[*] Preparing Workspace...${NC}"
    mkdir -p "$RESULT_DIR"
    # Check for jq dependency
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}[!] jq not found. Installing...${NC}"
        [ -n "$PREFIX" ] && pkg install -y jq || sudo apt install -y jq
    fi
}

fetch_subdomains() {
    echo -e "${YELLOW}[*] Scraping Certificate Transparency Logs...${NC}"
    curl -s "https://crt.sh/?q=%25.${TARGET}&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > "$RESULT_DIR/subdomains.txt"
    echo -e "${GREEN}[✔] $(wc -l < "$RESULT_DIR/subdomains.txt") Subdomains saved to subdomains.txt${NC}"
}

fetch_archive_urls() {
    echo -e "${YELLOW}[*] Pulling History from Wayback Machine...${NC}"
    curl -s "http://web.archive.org/cdx/search/cdx?url=*.${TARGET}/*&output=text&fl=original&collapse=urlkey" > "$RESULT_DIR/all_urls.txt"
    echo -e "${GREEN}[✔] $(wc -l < "$RESULT_DIR/all_urls.txt") URLs saved to all_urls.txt${NC}"
}

scan_secrets() {
    echo -e "${YELLOW}[*] Scanning for Secrets & Sensitive Endpoints...${NC}"
    
    # 1. Filter Sensitive Files
    grep -E "\.php|\.log|\.json|\.bak|\.conf|\.env|\.yaml|\.sql" "$RESULT_DIR/all_urls.txt" | sort -u > "$RESULT_DIR/sensitive_paths.txt"
    
    # 2. Look for API Keys/Tokens in URL strings
    grep -Ei "api_key|token|secret|password|bearer|aws" "$RESULT_DIR/all_urls.txt" | sort -u > "$RESULT_DIR/potential_secrets.txt"
    
    echo -e "${GREEN}[✔] Secret Analysis Complete.${NC}"
}

# --- MAIN ---
if [ -z "$1" ]; then
    banner
    echo -e "${RED}Usage: ./ghost.sh target.com${NC}"
    exit 1
fi

prepare_env
banner
fetch_subdomains
echo ""
fetch_archive_urls
echo ""
scan_secrets

echo -e "${CYAN}---------------------------------------------------------------${NC}"
echo -e "${GREEN}[DONE] Results available in: ${WHITE}$RESULT_DIR/${NC}"
echo -e "${BLUE}Files created: subdomains.txt, all_urls.txt, sensitive_paths.txt, potential_secrets.txt${NC}"

