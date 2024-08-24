# SecLin (Secure Linux)

**SecLin** is a Bash script designed to enhance the security of Linux servers by installing and configuring essential security tools. This script simplifies the process of setting up a secure environment with tools like UFW (Uncomplicated Firewall), Fail2Ban, and automated security tasks.

## Features

- **UFW Installation**: Install and configure UFW to manage firewall rules.
- **Unattended Upgrades**: Ensure your system receives automatic security updates.
- **Fail2Ban**: Install and configure Fail2Ban to protect against brute-force attacks.
- **Status Monitoring**: Add status checks for UFW and Fail2Ban to your bash profile.
- **Task Selection**: Choose and execute specific security tasks interactively.

## Usage

1. **Clone the Repository**

   ```bash
   sudo apt install git -y
   git clone https://github.com/nuri-it/seclin.git
   cd seclin
   chmod +x seclin.sh
   sudo bash ./seclin.sh

2. Follow the On-Screen Prompts

   The script will guide you through selecting and executing various security tasks.

## Requirements

- whiptail for interactive task selection
- Root privileges to install and configure security tools

## License

This project is licensed under the MIT License - see the LICENSE file for details.
