#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "You must be root to run this script."
  exit 1
fi

# Define tasks and their corresponding commands
declare -A tasks
tasks=(
  [1]="Install ufw"
  [2]="Install unattended-upgrades"
  [3]="Install fail2ban"
  [4]="Add fail2ban and ufw to bashrc"
)

# Install UFW
install_ufw() {
  echo "Installing ufw..."
  apt-get update 1> /dev/null
  apt-get install ufw -y 1> /dev/null
  ufw default deny incoming 1> /dev/null
  ufw default allow outgoing 1> /dev/null
  read -p "Allow SSH incoming connections? (y/n): " allow_ssh
  [ "$allow_ssh" = "y" ] && ufw limit 22/tcp
  ufw enable
  systemctl enable ufw 1> /dev/null
  systemctl start ufw 1> /dev/null
}

# Install unattended-upgrades
install_unattended_upgrades() {
  echo "Installing unattended-upgrades..."
  apt-get update 1> /dev/null
  apt-get install unattended-upgrades -y 1> /dev/null
  systemctl enable unattended-upgrades 1> /dev/null
}

# Install fail2ban
install_fail2ban() {
  echo "Installing fail2ban..."
  apt-get update 1> /dev/null
  apt-get install fail2ban -y 1> /dev/null
  cat <<EOF >/etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
EOF
  systemctl enable fail2ban
  systemctl start fail2ban
}

# Monitor fail2ban and ufw status
monitor_services() {
      echo "Adding fail2ban and ufw status to bashrc..."


content=$(cat <<EOF
# Define color codes
GREEN='\\033[0;32m'
RED='\\033[0;31m'
NC='\\033[0m' # No Color

# Check if ufw.service is running
ufw_status=\$(systemctl is-active ufw.service)
if [ "\$ufw_status" = "active" ]; then
    echo -e "\${GREEN}ufw is running\${NC}"
else
    echo -e "\${RED}ufw is not running\${NC}"
fi

# Check if fail2ban.service is running
fail2ban_status=\$(systemctl is-active fail2ban.service)
if [ "\$fail2ban_status" = "active" ]; then
    echo -e "\${GREEN}fail2ban is running\${NC}"
else
    echo -e "\${RED}fail2ban is not running\${NC}"
fi
EOF
)

# Append the content to /etc/bash.bashrc
echo "$content" | tee -a /etc/bash.bashrc > /dev/null

# Print a message indicating success
echo "Content successfully appended to /etc/bash.bashrc"
}

# Create a temporary file to store the selected tasks
tempfile=$(mktemp)

# Display tasks and allow user to select
whiptail --title "Task Selection" --checklist \
  "Select tasks to apply:" 20 78 10 \
  "1" "${tasks[1]}" OFF \
  "2" "${tasks[2]}" OFF \
  "3" "${tasks[3]}" OFF \
  "4" "${tasks[4]}" OFF 2> "$tempfile"

# Read selected tasks
selected_tasks=$(<"$tempfile")
rm "$tempfile"

# Execute selected tasks
for task_number in $selected_tasks; do
  case $task_number in
    \"1\") install_ufw ;;
    \"2\") install_unattended_upgrades ;;
    \"3\") install_fail2ban ;;
    \"4\") monitor_services ;;
  esac
done

echo "All selected tasks completed."
