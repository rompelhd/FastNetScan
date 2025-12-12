#!/usr/bin/env bash

set -e

URL="https://raw.githubusercontent.com/rompelhd/FastNetScan/refs/heads/main/src/fastnetscan.sh"
DEST="/usr/bin/fastnetscan"

echo "[+] Downloading fastnetscan from GitHub..."
curl -fsSL "$URL" -o /tmp/fastnetscan || {
    echo "[!] Error downloading file."
    exit 1
}

echo "[+] Installing to $DEST..."
sudo mv /tmp/fastnetscan "$DEST"
sudo chmod +x "$DEST"

echo "[+] Installation complete."
echo "[+] You can now use the command: fastnetscan"
