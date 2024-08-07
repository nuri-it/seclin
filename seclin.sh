#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "You should be admin to start this script."
  exit 1
fi

# Define tasks
tasks=(
  "Install ufw"
  "Install unattended-upgrades"
  "Install fail2ban"
  "Monitor fail2ban and ufw"
  "Task 5: Task 5 description"
  "Task 6: Task 6 description"
  "Task 7: Task 7 description"
  "Task 8: Task 8 description"
  "Task 9: Task 9 description"
  "Task 10: Task 10 description"
)

# Create a temporary file to store the selected tasks
tempfile=$(mktemp)

# Display tasks and allow user to select
whiptail --title "Task Selection" --checklist \
"Select tasks to apply (use arrow keys to navigate and space to select):" 20 78 10 \
"1" "${tasks[0]}" OFF \
"2" "${tasks[1]}" OFF \
"3" "${tasks[2]}" OFF \
"4" "${tasks[3]}" OFF \
"5" "${tasks[4]}" OFF \
"6" "${tasks[5]}" OFF \
"7" "${tasks[6]}" OFF \
"8" "${tasks[7]}" OFF \
"9" "${tasks[8]}" OFF \
"10" "${tasks[9]}" OFF 2> "$tempfile"

# Read selected tasks
selected_tasks=$(<"$tempfile")
rm "$tempfile"

# Execute selected tasks
for task_number in $selected_tasks; do
  case $task_number in
    \"1\")
      echo "Installing ufw..."
      apt-get update && apt install ufw -y
      ufw default deny incoming
      ufw default allow outgoing
      # Prompt the user to allow SSH incoming connections
      read -p "Do you want to allow SSH incoming connections? (y/n): " allow_ssh
      if [ "$allow_ssh" = "y" ]; then
          ufw limit 22/tcp
      fi
      systemctl enable ufw
      ufw enable
      ;;
    \"2\")
      echo "Installing unattended-upgrades..."
      apt-get update && apt install unattended-upgrades -y
      systemctl enable unattended-upgrades.service 
      ;;
    \"3\")
      echo "Installing fail2ban..."
      apt-get update && apt install fail2ban -y
      echo -e "[DEFAULT]\nignoreip = 127.0.0.1/8 ::1\nbantime = 3600\nfindtime = 600\nmaxretry = 5\n\n[sshd]\nenabled = true \nport = ssh \nlogpath = /var/log/auth.log"| tee /etc/fail2ban/jail.local > /dev/null
      touch /var/log/auth.log
      systemctl enable fail2ban
      systemctl start fail2ban
      ;;
    \"4\")
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



      
      ;;
    \"5\")
      echo "Running Task 5..."
      # Add your command here
      ;;
    \"6\")
      echo "Running Task 6..."
      # Add your command here
      ;;
    \"7\")
      echo "Running Task 7..."
      # Add your command here
      ;;
    \"8\")
      echo "Running Task 8..."
      # Add your command here
      ;;
    \"9\")
      echo "Running Task 9..."
      # Add your command here
      ;;
    \"10\")
      echo "Running Task 10..."
      # Add your command here
      ;;
  esac
done

echo "All selected tasks completed."
