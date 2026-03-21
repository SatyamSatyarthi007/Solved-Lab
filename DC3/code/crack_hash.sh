#!/bin/bash
###############################################################################
# Hashcat Cracking Script for DC-3 CTF
# bcrypt hash from Joomla database
###############################################################################

# Hash extracted from Joomla database
# Format: $2y$10$ (bcrypt)
HASH_FILE="../cracking/hash.txt"
WORDLIST="/usr/share/wordlists/rockyou.txt"

# Hash mode for bcrypt
HASH_MODE=3200

echo "[*] DC-3 Password Cracking"
echo "[*] Hash Type: bcrypt (\$2y\$10\$)"
echo "[*] Hash Mode: $HASH_MODE"
echo "[*] Wordlist: $WORDLIST"
echo ""

# Check if hash file exists
if [ ! -f "$HASH_FILE" ]; then
    echo "[-] Hash file not found: $HASH_FILE"
    echo "[*] Creating hash file..."
    echo '$2y$10$DpfpYjADpejngxNh9GnmCeyIHCWpL97CVRnGeZsVJwR0kWFlfB1Zu' > "$HASH_FILE"
fi

echo "[*] Starting hashcat..."

# Run hashcat
hashcat -m $HASH_MODE "$HASH_FILE" "$WORDLIST" --force --show 2>/dev/null

if [ $? -ne 0 ]; then
    echo "[*] Running full crack..."
    hashcat -m $HASH_MODE "$HASH_FILE" "$WORDLIST" --force
fi

echo ""
echo "[*] To view cracked hash:"
echo "hashcat -m $HASH_MODE '$HASH_FILE' --show"
