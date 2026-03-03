#!/bin/bash

clear

echo "======================================"
echo "      🚀 Veltrion Hosting Installer"
echo "======================================"
echo ""
echo "1) Motd Setup"
echo "2) Node Setup"
echo "3) Mirror Change"
echo "4) VPS Login Setup"
echo "5) Autobackup Setup"
echo ""
read -p "Select an option [1-5]: " main_choice

if [ "$main_choice" == "1" ]; then
    clear
    echo "======================================"
    echo "           Motd Setup"
    echo "======================================"
    echo ""
    echo "1) Debian"
    echo "2) Ubuntu"
    echo ""
    read -p "Select an option [1-2]: " motd_choice

    if [ "$motd_choice" == "1" ]; then
        echo "⚙️ Setting up MOTD for Debian..."

        # Install required packages
        apt update -y
        apt install -y curl pciutils

        # Backup profile (safety)
        cp /etc/profile /etc/profile.backup

        # Append MOTD (DO NOT overwrite)
        cat << 'EOF' >> /etc/profile

clear

# ==== SYSTEM INFO FETCH ====

OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
CPU_MODEL=$(lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ *//' | grep -v "i440fx" | head -n 1)
CPU_CORES=$(nproc)
GPU_INFO=$(lspci | grep -i 'vga\|3d\|2d' | awk -F': ' '{print $2}' | head -n 1)

HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

RAM_USED=$(free -m | awk '/Mem:/ {printf "%.1f", $3/1024}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {printf "%.1f", $2/1024}')

DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

IPV4=$(curl -4 -s ifconfig.me 2>/dev/null)
IPV6=$(curl -6 -s ifconfig.me 2>/dev/null)

# ==== BANNER ====

echo "██╗   ██╗███████╗██╗  ████████╗██████╗ ██╗ ██████╗ ███╗   ██╗    ██╗  ██╗ ██████╗ ███████╗████████╗██╗███╗   ██╗ ██████╗ "
echo "██║   ██║██╔════╝██║  ╚══██╔══╝██╔══██╗██║██╔═══██╗████╗  ██║    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝"
echo "██║   ██║█████╗  ██║     ██║   ██████╔╝██║██║   ██║██╔██╗ ██║    ███████║██║   ██║███████╗   ██║   ██║██╔██╗ ██║██║  ███╗"
echo "╚██╗ ██╔╝██╔══╝  ██║     ██║   ██╔══██╗██║██║   ██║██║╚██╗██║    ██╔══██║██║   ██║╚════██║   ██║   ██║██║╚██╗██║██║   ██║"
echo " ╚████╔╝ ███████╗███████╗██║   ██║  ██║██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝███████║   ██║   ██║██║ ╚████║╚██████╔╝"
echo "  ╚═══╝  ╚══════╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
echo ""
echo " OS        : $OS_NAME"
echo " Hosted on : Veltrion Hosting"
echo " Processor : $CPU_MODEL"
echo " Cores     : $CPU_CORES"
echo " GPU       : ${GPU_INFO:-Not detected}"
echo " Hostname  : $HOSTNAME"
echo " Uptime    : $UPTIME"
echo " RAM       : ${RAM_USED}GB / ${RAM_TOTAL}GB"
echo " Disk      : $DISK_USED / $DISK_TOTAL"
echo " IPv4      : ${IPV4:-Not detected}"
echo " IPv6      : ${IPV6:-Not detected}"
echo ""

EOF

        # Modify SSH config safely (append only)
        echo "" >> /etc/ssh/sshd_config
        echo "PrintLastLog no" >> /etc/ssh/sshd_config

        # Restart SSH
        systemctl restart ssh || systemctl restart sshd

        echo "✅ MOTD Setup Completed for Debian!"

elif [ "$motd_choice" == "2" ]; then
    echo "⚙️ Setting up MOTD for Ubuntu..."

    # Install required packages
    apt update -y
    apt install -y curl pciutils

    # Disable default MOTD scripts
    chmod -x /etc/update-motd.d/*

    # Create Veltrion MOTD
    cat << 'EOF' > /etc/update-motd.d/99-veltrion
#!/bin/bash

clear

# ==== SYSTEM INFO FETCH ====

OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
CPU_MODEL=$(lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ *//' | grep -v "i440fx" | head -n 1)
CPU_CORES=$(nproc)
GPU_INFO=$(lspci | grep -i 'vga\|3d\|2d' | awk -F': ' '{print $2}' | head -n 1)

HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

RAM_USED=$(free -m | awk '/Mem:/ {printf "%.1f", $3/1024}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {printf "%.1f", $2/1024}')

DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

IPV4=$(curl -4 -s ifconfig.me 2>/dev/null)
IPV6=$(curl -6 -s ifconfig.me 2>/dev/null)

# ==== BANNER ====

echo "██╗   ██╗███████╗██╗  ████████╗██████╗ ██╗ ██████╗ ███╗   ██╗    ██╗  ██╗ ██████╗ ███████╗████████╗██╗███╗   ██╗ ██████╗ "
echo "██║   ██║██╔════╝██║  ╚══██╔══╝██╔══██╗██║██╔═══██╗████╗  ██║    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝"
echo "██║   ██║█████╗  ██║     ██║   ██████╔╝██║██║   ██║██╔██╗ ██║    ███████║██║   ██║███████╗   ██║   ██║██╔██╗ ██║██║  ███╗"
echo "╚██╗ ██╔╝██╔══╝  ██║     ██║   ██╔══██╗██║██║   ██║██║╚██╗██║    ██╔══██║██║   ██║╚════██║   ██║   ██║██║╚██╗██║██║   ██║"
echo " ╚████╔╝ ███████╗███████╗██║   ██║  ██║██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝███████║   ██║   ██║██║ ╚████║╚██████╔╝"
echo "  ╚═══╝  ╚══════╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
echo ""
echo " OS        : $OS_NAME"
echo " Hosted on : Veltrion Hosting"
echo " Processor : $CPU_MODEL"
echo " Cores     : $CPU_CORES"
echo " GPU       : ${GPU_INFO:-Not detected}"
echo " Hostname  : $HOSTNAME"
echo " Uptime    : $UPTIME"
echo " RAM       : ${RAM_USED}GB / ${RAM_TOTAL}GB"
echo " Disk      : $DISK_USED / $DISK_TOTAL"
echo " IPv4      : ${IPV4:-Not detected}"
echo " IPv6      : ${IPV6:-Not detected}"
echo ""

EOF

    # Make executable
    chmod +x /etc/update-motd.d/99-veltrion

    # Disable last login message cleanly
    sed -i 's/^#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config
    echo "PrintLastLog no" >> /etc/ssh/sshd_config

    # Restart SSH
    systemctl restart ssh || systemctl restart sshd

    echo "✅ Veltrion Ubuntu MOTD Installed!"

    
    else
        echo "❌ Invalid option"

    fi

elif [ "$main_choice" == "2" ]; then
    clear
    echo "======================================"
    echo "        🚀 Node Setup (Pterodactyl)"
    echo "======================================"
    echo ""

    echo "⚙️ Running Pterodactyl Node Installer..."
    echo "👉 Follow the installer and complete all steps"
    echo ""

    sleep 2

    # Run installer normally (no expect)
    bash <(curl -s https://pterodactyl-installer.se)

    echo ""
    echo "======================================"
    echo "        Node Configuration"
    echo "======================================"
    echo ""

    echo "Paste your Wings configuration command:"
    read -p "> " USER_COMMAND

    echo ""
    echo "⚙️ Executing command..."
    bash -c "$USER_COMMAND"

    echo ""
    echo "⚙️ Starting Wings..."

    systemctl start wings
    systemctl enable wings

    echo ""
    echo "✅ Node Setup Completed!"

elif [ "$main_choice" == "3" ]; then
    clear
    echo "======================================"
    echo "        🌐 Mirror Change (India)"
    echo "======================================"
    echo ""

    echo "⚙️ Updating APT mirrors to India..."

    # Backup original file
    cp /etc/apt/sources.list /etc/apt/sources.list.backup

    # Replace de. with in.
    sed -i 's|http://de.|http://in.|g' /etc/apt/sources.list
    sed -i 's|https://de.|https://in.|g' /etc/apt/sources.list

    echo ""
    echo "🔄 Updating package lists..."
    apt update -y

    echo ""
    echo "✅ Mirror changed to India (in.) successfully!"

    elif [ "$main_choice" == "4" ]; then
    clear
    echo "======================================"
    echo "        🔐 VPS Login Setup"
    echo "======================================"
    echo ""
    echo "1) Root Pass Setup"
    echo "2) Key Setup"
    echo ""

    read -p "Select an option [1-2]: " login_choice

    # ================= ROOT PASSWORD SETUP =================
    if [ "$login_choice" == "1" ]; then
        echo "⚙️ Setting up Root Password Login..."

        apt update -y
        apt install --reinstall openssh-server -y

        mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak 2>/dev/null

        echo -e "Port 22
PermitRootLogin yes
PasswordAuthentication yes
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
Subsystem sftp /usr/lib/openssh/sftp-server" | tee /etc/ssh/sshd_config > /dev/null

        systemctl enable ssh
        systemctl restart ssh

        echo ""
        echo "✅ SSH configured. Now set root password:"
        passwd

    # ================= SSH KEY SETUP =================
    elif [ "$login_choice" == "2" ]; then
        echo "⚙️ Setting up SSH Key Authentication..."

        mkdir -p ~/.ssh
        chmod 700 ~/.ssh

        echo ""
        echo "Paste your SSH Public Key:"
        read -p "> " SSH_KEY

        echo "$SSH_KEY" > ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys

        systemctl restart ssh

        echo ""
        echo "✅ SSH Key added successfully!"

    else
        echo "❌ Invalid option"
    fi

    elif [ "$main_choice" == "5" ]; then
    clear
    echo "======================================"
    echo "        💾 Autobackup Setup"
    echo "======================================"
    echo ""
    echo "1) Rclone Setup"
    echo "2) Backup Setup"
    echo ""
    read -p "Select an option [1-2]: " backup_choice

    # ================= RCLONE SETUP =================
    if [ "$backup_choice" == "1" ]; then
        echo "⚙️ Installing Rclone..."

        sudo apt update
        sudo apt install unzip -y
        curl https://rclone.org/install.sh | sudo bash

        echo ""
        echo "⚙️ Starting Rclone Config..."
        echo "Follow these steps:"
        echo "n"
        echo "gdrive"
        echo "24"
        echo "Press Enter (client id blank)"
        echo "Press Enter (client secret blank)"
        echo "1"
        echo "Press Enter"
        echo "n"
        echo "n"
        echo "Paste your token JSON"
        echo "n"
        echo "y"
        echo "q"
        echo ""

        rclone config

        echo ""
        echo "✅ Rclone Setup Completed!"


    # ================= ENTERPRISE BACKUP SETUP =================
    elif [ "$backup_choice" == "2" ]; then
        clear
        echo "======================================"
        echo "        🚀 Enterprise Backup Setup"
        echo "======================================"
        echo ""

        read -p "Enter Node Name (e.g. BudgetNode1): " NODE_NAME_INPUT
        read -p "Enter Category (e.g. Budget/Performance): " CATEGORY_INPUT

        echo ""
        echo "⚙️ Installing Enterprise Backup Script..."

        cat << EOF > /root/veltrion-enterprise-backup.sh
#!/bin/bash

# ==============================
# Veltrion Enterprise Backup
# ==============================

NODE_NAME="$NODE_NAME_INPUT"
CATEGORY="$CATEGORY_INPUT"
SOURCE_DIR="/var/lib/pterodactyl"
DATE=\$(date +"%Y-%m-%d")
DRIVE_PATH="gdrive:Veltrion/Node/\$CATEGORY/\$NODE_NAME/\$DATE"

LOG_FILE="/root/enterprise-backup.log"

echo "===== Veltrion Enterprise Backup Starting =====" | tee -a \$LOG_FILE

# CPU LOAD CHECK
LOAD=\$(awk '{print \$1}' /proc/loadavg)
CPU_CORES=\$(nproc)
MAX_LOAD=\$(echo "\$CPU_CORES * 0.75" | bc)

if (( \$(echo "\$LOAD > \$MAX_LOAD" | bc -l) )); then
    echo "CPU load too high (\$LOAD). Aborting backup." | tee -a \$LOG_FILE
    exit 1
fi

echo "CPU load OK (\$LOAD)" | tee -a \$LOG_FILE

# AUTO BANDWIDTH DETECTION
NIC=\$(ip route | grep default | awk '{print \$5}')
SPEED=\$(cat /sys/class/net/\$NIC/speed 2>/dev/null)

if [ -z "\$SPEED" ]; then
    SPEED=100
fi

BW_LIMIT=\$(echo "\$SPEED * 0.20" | bc)
BW_LIMIT_MB=\$(echo "\$BW_LIMIT / 8" | bc)

if [ "\$BW_LIMIT_MB" -lt 5 ]; then
    BW_LIMIT_MB=5
fi

echo "Detected NIC: \$NIC (\$SPEED Mbps)" | tee -a \$LOG_FILE
echo "Using Upload Limit: \${BW_LIMIT_MB}M" | tee -a \$LOG_FILE

command -v pv >/dev/null 2>&1 || apt install -y pv
command -v bc >/dev/null 2>&1 || apt install -y bc

# STREAM VOLUMES
if [ -d "\$SOURCE_DIR/volumes" ]; then
    echo "Streaming volumes..." | tee -a \$LOG_FILE
    tar -cf - -C "\$SOURCE_DIR" volumes | \
    rclone rcat "\$DRIVE_PATH/volumes-\$DATE.tar" \
    --progress \
    --bwlimit \${BW_LIMIT_MB}M \
    --transfers 1 \
    --checkers 1 \
    --buffer-size 16M \
    --drive-chunk-size 16M \
    --low-level-retries 10 \
    --retries 5
fi

# STREAM BACKUPS
if [ -d "\$SOURCE_DIR/backups" ]; then
    echo "Streaming backups..." | tee -a \$LOG_FILE
    tar -cf - -C "\$SOURCE_DIR" backups | \
    rclone rcat "\$DRIVE_PATH/backups-\$DATE.tar" \
    --progress \
    --bwlimit \${BW_LIMIT_MB}M \
    --transfers 1 \
    --checkers 1 \
    --buffer-size 16M \
    --drive-chunk-size 16M \
    --low-level-retries 10 \
    --retries 5
fi

echo "===== Veltrion Enterprise Backup Completed =====" | tee -a \$LOG_FILE
EOF

        chmod +x /root/veltrion-enterprise-backup.sh

        echo ""
        echo "⚙️ Setting Daily Cron (2 AM)..."

        (crontab -l 2>/dev/null; echo "0 2 * * * /root/veltrion-enterprise-backup.sh >> /root/enterprise-backup.log 2>&1") | crontab -

        echo ""
        echo "✅ Enterprise Autobackup Installed Successfully!"

    else
        echo "❌ Invalid option"
    fi
fi
