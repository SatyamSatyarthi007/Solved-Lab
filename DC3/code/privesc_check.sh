#!/bin/bash
###############################################################################
# Privilege Escalation Enumeration Script
# DC-3 CTF Post-Exploitation Checklist
###############################################################################

echo "==================================="
echo "DC-3 Privilege Escalation Checklist"
echo "==================================="
echo ""

echo "[+] Current User:"
id
echo ""

echo "[+] Kernel Information:"
uname -a
echo ""

echo "[+] Distribution:"
cat /etc/os-release 2>/dev/null || lsb_release -a 2>/dev/null
echo ""

echo "[+] Sudo Permissions:"
sudo -l 2>/dev/null || echo "No sudo access"
echo ""

echo "[+] SUID Files:"
find / -perm -4000 -type f 2>/dev/null | head -20
echo ""

echo "[+] Kernel Exploits to Try:"
echo "  - CVE-2017-16995 (double-fdput) - Kernel 4.4.x"
echo "  - CVE-2016-5195 (Dirty COW) - Kernel < 4.8.3"
echo ""

echo "[+] Check for installed compilers:"
which gcc python python3 perl
echo ""

echo "[+] Writable directories:"
find / -type d -writable 2>/dev/null | head -10
echo ""

echo "[+] Cron jobs:"
cat /etc/crontab 2>/dev/null
cat /etc/cron.d/* 2>/dev/null
echo ""

echo "==================================="
echo "Enumeration Complete"
echo "==================================="