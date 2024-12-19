#!/bin/bash

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

# Backup the sshd_config file
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of sshd_config created at $BACKUP_FILE"
fi

# Comment out existing lines for ClientAliveInterval and ClientAliveCountMax
sed -i.bak -E 's/^(ClientAliveInterval|ClientAliveCountMax)/#\0/' "$CONFIG_FILE"

# Add new configurations
echo -e "\n# Updated by script on $(date)" >> "$CONFIG_FILE"
echo "ClientAliveInterval 50" >> "$CONFIG_FILE"
echo "ClientAliveCountMax 40" >> "$CONFIG_FILE"

# Restart the SSH service
if systemctl restart sshd; then
    echo "SSH service restarted successfully."
else
    echo "Failed to restart SSH service. Please check the configuration."
    exit 1
fi

echo "Configuration updated successfully."
