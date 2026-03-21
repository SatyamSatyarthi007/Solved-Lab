#!/bin/bash
###############################################################################
# Compilation script for kernel exploit 39772
# DC-3 CTF Privilege Escalation
###############################################################################

echo "[*] Compiling kernel exploit..."
echo "[*] Target: Linux 4.4.0-21-generic (Ubuntu 16.04)"
echo ""

# Compile the exploit
gcc -o doubleput kernel_exploit_39772.c -Wall \
    -I/usr/include \
    -O2 \
    -static \
    2>&1

if [ $? -eq 0 ]; then
    echo "[+] Compilation successful!"
    echo "[+] Output: ./doubleput"
    echo ""
    echo "[*] Run with: ./doubleput"
else
    echo "[-] Compilation failed!"
    exit 1
fi