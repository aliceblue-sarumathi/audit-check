#!/bin/bash

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

# Backup the sshd_config file
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of sshd_config created at $BACKUP_FILE"
fi

# Comment out any existing LoginGraceTime lines
sed -i.bak -E 's/^(LoginGraceTime)/#\0/' "$CONFIG_FILE"

# Insert the new LoginGraceTime 60 line above any Include entries
if grep -q "^Include" "$CONFIG_FILE"; then
    sed -i '/^Include/ i LoginGraceTime 60' "$CONFIG_FILE"
else
    echo -e "\nLoginGraceTime 60" >> "$CONFIG_FILE"
fi

# Restart the SSH service
if systemctl restart sshd; then
    echo "SSH service restarted successfully."
else
    echo "Failed to restart SSH service. Please check the configuration."
    exit 1
fi

echo "LoginGraceTime updated successfully."
