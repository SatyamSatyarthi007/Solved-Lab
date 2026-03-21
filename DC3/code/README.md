# Code Files for DC-3 CTF

This directory contains all the code, scripts, and payloads used during the DC-3 CTF exploitation.

## Files Overview

| File | Description | Usage |
|------|-------------|-------|
| `php_reverse_shell.php` | PHP reverse shell payload | Injected into Joomla template |
| `kernel_exploit_39772.c` | Kernel privilege escalation exploit | Compiled to get root |
| `compile.sh` | Compilation script for the kernel exploit | `./compile.sh` |
| `sqlmap_commands.sh` | SQLMap command reference | `./sqlmap_commands.sh` |
| `crack_hash.sh` | Hashcat cracking script | `./crack_hash.sh` |
| `netcat_listener.sh` | Netcat listener for reverse shell | `./netcat_listener.sh` |
| `privesc_check.sh` | Privilege escalation enumeration | `./privesc_check.sh` |

## Usage

### 1. PHP Reverse Shell

```bash
# Copy content and paste into Joomla template editor
# Extensions → Templates → Templates → Protostar → index.php

cat php_reverse_shell.php
```

**Don't forget to:**
- Update the `$ip` variable with your attacker IP
- Update the `$port` variable with your listening port

### 2. Kernel Exploit

```bash
# Compile the exploit
./compile.sh

# Run it on the target
./doubleput
```

### 3. SQLMap Commands

```bash
# View the commands
./sqlmap_commands.sh

# Then run manually with the target URL
```

### 4. Hash Cracking

```bash
# Crack the extracted bcrypt hash
./crack_hash.sh

# Or manually:
hashcat -m 3200 hash.txt /usr/share/wordlists/rockyou.txt --force
```

### 5. Netcat Listener

```bash
# Start listener before triggering reverse shell
./netcat_listener.sh

# Or manually:
nc -lvnp 4444
```

### 6. Privilege Escalation Check

```bash
# Run on target to find privesc vectors
./privesc_check.sh
```

## Workflow

```
1. SQL Injection → Extract hash
2. Crack Hash → Get admin password
3. Login to Joomla → Template Editor
4. Inject PHP Shell → Get reverse shell (www-data)
5. Run privesc_check.sh → Find kernel exploit
6. Upload & compile kernel_exploit_39772.c
7. Execute → Get root shell
```

## References

- [CVE-2017-8917](https://nvd.nist.gov/vuln/detail/CVE-2017-8917) - Joomla SQL Injection
- [Exploit 39772](https://www.exploit-db.com/exploits/39772) - Kernel Privilege Escalation
- [PHP Reverse Shell](https://github.com/pentestmonkey/php-reverse-shell) - Pentest Monkey