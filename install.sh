#!/bin/bash

clear

echo "======================================"
echo "      🚀 Veltrion Hosting Installer"
echo "======================================"
echo ""
echo "1) Motd Setup"
echo "2) Node Setup"
echo "3) Mirror Change"
echo ""
read -p "Select an option [1-2]: " main_choice

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

fi
