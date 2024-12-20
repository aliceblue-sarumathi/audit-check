#!/bin/bash

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

# Backup the sshd_config file
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of sshd_config created at $BACKUP_FILE"
fi

# Comment out any existing LogLevel lines
sed -i.bak -E 's/^(LogLevel)/#\0/' "$CONFIG_FILE"

# Insert the new LogLevel VERBOSE line above any Match entries
if grep -q "^Match" "$CONFIG_FILE"; then
    sed -i '/^Match/ i LogLevel VERBOSE' "$CONFIG_FILE"
else
    echo -e "\nLogLevel VERBOSE" >> "$CONFIG_FILE"
fi

# Restart the SSH service
if systemctl restart sshd; then
    echo "SSH service restarted successfully."
else
    echo "Failed to restart SSH service. Please check the configuration."
    exit 1
fi

echo "LogLevel updated to VERBOSE successfully."
