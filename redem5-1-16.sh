#!/bin/bash

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

# Backup the sshd_config file
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of sshd_config created at $BACKUP_FILE"
fi

# Comment out any existing MaxAuthTries lines
sed -i.bak -E 's/^(MaxAuthTries)/#\0/' "$CONFIG_FILE"

# Insert the new MaxAuthTries 5 line above any Include or Match entries
if grep -qE "^(Include|Match)" "$CONFIG_FILE"; then
    sed -i '/^Include\|^Match/ i MaxAuthTries 5' "$CONFIG_FILE"
else
    echo -e "\nMaxAuthTries 5" >> "$CONFIG_FILE"
fi

# Restart the SSH service
if systemctl restart sshd; then
    echo "SSH service restarted successfully."
else
    echo "Failed to restart SSH service. Please check the configuration."
    exit 1
fi

echo "MaxAuthTries updated to 5 successfully."
