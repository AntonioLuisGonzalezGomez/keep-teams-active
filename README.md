# Keep Microsoft Teams Active (Linux)

A lightweight Bash-based solution to prevent **Microsoft Teams** from appearing idle on Linux systems by simulating periodic user interaction.

This project runs as a **user-level systemd service** and includes convenient shell aliases for control.

---

## 📌 Overview

The script:

- Prevents system suspension using `caffeine`
- Detects a running Microsoft Teams window
- Simulates a small mouse interaction inside the Teams window every 4 minutes
- Logs activity to `~/keep_teams_active.log`
- Automatically rotates the log file when it exceeds 1000 lines
- Runs continuously as a `systemd --user` service

---

## ⚙️ How It Works

### Configuration

```bash
INTERVAL=240        # Time between checks (seconds)
LOGFILE="$HOME/keep_teams_active.log"
MAX_LINES=1000      # Maximum log lines before rotation
```

### Execution Flow

Every `INTERVAL` seconds the script:

1. Searches for a window named **Microsoft Teams**
2. If found:
    - Stores the currently active window
    - Activates the Teams window
    - Calculates a safe cursor position inside the window
    - Simulates a mouse move and click
    - Restores the original mouse position
    - Restores the previously active window
    - Writes a log entry
3. If not found:
    - Logs that Teams was not detected
4. Ensures the log file does not exceed `MAX_LINES`

---

## 📦 Requirements

Install required dependencies:

```bash
sudo apt update
sudo apt install xdotool caffeine
```

Requirements:

- `xdotool`
- `caffeine`
- `systemd` (default in Ubuntu)
- X11 session (Wayland is not supported)

---

# 🚀 Installation Guide (Ubuntu)

---

## 1️⃣ Add the Script

Create a project directory:

```bash
mkdir -p ~/projects/keep-teams-active
cd ~/projects/keep-teams-active
```

Create the script:

```bash
nano keep_teams_active.sh
```

Paste the script content and save.

Make it executable:

```bash
chmod +x keep_teams_active.sh
```

---

## 2️⃣ Create a User Systemd Service

Create the user service directory if needed:

```bash
mkdir -p ~/.config/systemd/user
```

Create the service file:

```bash
nano ~/.config/systemd/user/keep_teams_active.service
```

Add:

```ini
[Unit]
Description=Keep Microsoft Teams Active
After=graphical.target

[Service]
Type=simple
ExecStart=/home/YOUR_USER/projects/keep-teams-active/keep_teams_active.sh
Restart=always
RestartSec=5
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
```

⚠️ Replace `YOUR_USER` with your actual Linux username.

Reload systemd:

```bash
systemctl --user daemon-reload
```

Enable service at login (optional):

```bash
systemctl --user enable keep_teams_active.service
```

---

## 3️⃣ Add Shell Aliases

Edit your shell config file:

### Bash
```bash
nano ~/.bashrc
```

### Zsh
```bash
nano ~/.zshrc
```

Add:

```bash
alias teams-start='systemctl --user start keep_teams_active.service'
alias teams-stop='systemctl --user stop keep_teams_active.service'
alias teams-status='systemctl --user status keep_teams_active.service'
alias teams-log='tail -f ~/keep_teams_active.log'
```

Reload shell:

```bash
source ~/.bashrc
```

(or `source ~/.zshrc`)

---

# 🖥 Usage

Start service:

```bash
teams-start
```

Stop service:

```bash
teams-stop
```

Check status:

```bash
teams-status
```

View live logs:

```bash
teams-log
```

---

# 🛠 Troubleshooting

### Teams window not detected

Verify window name:

```bash
xdotool search --name "Teams"
```

If necessary, adjust the search string inside the script.

---

### Service fails to start

Check logs:

```bash
journalctl --user -u keep_teams_active.service
```

Verify:

- `DISPLAY=:0` matches your session
- You are running X11 (not Wayland)

---

# 🔐 Notes

- Works only under X11.
- Does not interact with Teams APIs.
- Simulates basic user interaction.
- Use responsibly and in accordance with your organization’s policies.

---

# 📄 License

MIT License


---

# ✅ Summary

This project provides:

- A Bash automation script
- A user-level systemd service
- Convenient control aliases
- Log rotation
- Clean GitHub-ready documentation

---

**Author:**  
Antonio Luis González Gómez
2026
