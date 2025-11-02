#!/bin/bash
# linux-hardening v2.0 - Server Security Hardening Script
# Author: YourName | White Hat Hacker
# Tested on: Ubuntu 22.04, Debian 12, CentOS 9

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG="logs/hardening_$(date +%Y%m%d_%H%M%S).log"
BACKUP_DIR="backup"
REPORT="reports/before_after.html"

mkdir -p logs backup reports

log() { echo -e "${BLUE}[*] $1${NC}" | tee -a "$LOG"; }
success() { echo -e "${GREEN}[✔] $1${NC}" | tee -a "$ trainedLOG"; }
warn() { echo -e "${YELLOW}[!] $1${NC}" | tee -a "$LOG"; }
error() { echo -e "${RED}[✘] $1${NC}" | tee -a "$LOG"; }

log "Starting Linux Hardening Script..."

# 1. Update System
log "Updating system packages..."
if command -v apt >/dev/null; then
    apt update && apt upgrade -y
elif command -v yum >/dev/null; then
    yum update -y
fi
success "System updated"

# 2. Disable Root Login
log "Disabling root SSH login..."
cp /etc/ssh/sshd_config $BACKUP_DIR/sshd_config.bak
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
success "Root login disabled"

# 3. Change SSH Port (optional: 2222)
read -p "Change SSH port to 2222? (y/n): " change_port
if [[ $change_port == "y" ]]; then
    sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
    success "SSH port changed to 2222"
fi

# 4. Install Fail2Ban
log "Installing fail2ban..."
if command -v apt >/dev/null; then
    apt install fail2ban -y
elif command -v yum >/dev/null; then
    yum install epel-release -y && yum install fail2ban -y
fi
systemctl enable fail2ban
success "Fail2Ban installed & enabled"

# 5. Disable Unused Services
log "Stopping unnecessary services..."
services=("telnet" "ftp" "vsftpd" "nginx" "apache2")
for svc in "${services[@]}"; do
    if systemctl is-active --quiet $svc; then
        systemctl stop $svc
        systemctl disable $svc
        warn "$svc stopped & disabled"
    fi
done

# 6. Enable Firewall (UFW or Firewalld)
log "Configuring firewall..."
if command -v ufw >/dev/null; then
    ufw allow 2222/tcp 2>/dev/null || ufw allow 22/tcp
    ufw --force enable
    success "UFW enabled"
elif command -v firewall-cmd >/dev/null; then
    firewall-cmd --add-port=2222/tcp --permanent 2>/dev/null || firewall-cmd --add-port=22/tcp --permanent
    firewall-cmd --reload
    success "Firewalld configured"
fi

# 7. Secure Shared Memory
log "Securing /tmp and shared memory..."
echo "tmpfs /tmp tmpfs defaults,noexec,nosuid,nodev 0 0" >> /etc/fstab
mount -o remount /tmp
success "/tmp secured"

# 8. Generate Report
generate_report() {
    cat > "$REPORT" <<EOF
<!DOCTYPE html>
<html><head><title>Hardening Report</title><style>
body {font-family: monospace; background: #0d1117; color: #c9d1d9;}
.container {max-width: 800px; margin: 40px auto; padding: 20px; background: #161b22; border-radius: 10px;}
table {width: 100%; border-collapse: collapse; margin: 20px 0;}
th, td {padding: 12px; border: 1px solid #30363d; text-align: left;}
th {background: #21262d;}
.success {color: #7ee787;}
.warn {color: #f0b72c;}
</style></head><body>
<div class="container">
<h1>Server Hardening Report</h1>
<p><strong>Date:</strong> $(date)</p>
<table>
<tr><th>Action</th><th>Status</th></tr>
<tr><td>System Update</td><td class="success">Done</td></tr>
<tr><td>Root Login</td><td class="success">Disabled</td></tr>
<tr><td>Fail2Ban</td><td class="success">Installed</td></tr>
<tr><td>Firewall</td><td class="success">Enabled</td></tr>
</table>
</div></body></html>
EOF
    success "Report generated: $REPORT"
}

generate_report
success "Hardening completed! Check $REPORT"