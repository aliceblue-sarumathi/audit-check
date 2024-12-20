#!/bin/bash

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

# Backup the sshd_config file
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of sshd_config created at $BACKUP_FILE"
fi

# Parameters to update
declare -A PARAMS=(
    ["MaxAuthTries"]="5"
    ["MaxSessions"]="10"
    ["MaxStartups"]="10:30:60"
    ["PermitRootLogin"]="no"
)

# Comment out existing parameter lines
for PARAM in "${!PARAMS[@]}"; do
    sed -i.bak -E "s/^($PARAM)/#\0/" "$CONFIG_FILE"
done

# Insert new parameter values above any Match entries
if grep -q "^Match" "$CONFIG_FILE"; then
    for PARAM in "${!PARAMS[@]}"; do
        sed -i "/^Match/ i $PARAM ${PARAMS[$PARAM]}" "$CONFIG_FILE"
    done
else
    # If no Match entries exist, append the parameters to the end
    echo -e "\n# Updated parameters added by script on $(date)" >> "$CONFIG_FILE"
    for PARAM in "${!PARAMS[@]}"; do
        echo "$PARAM ${PARAMS[$PARAM]}" >> "$CONFIG_FILE"
    done
fi

# Restart the SSH service
if systemctl restart sshd; then
    echo "SSH service restarted successfully."
else
    echo "Failed to restart SSH service. Please check the configuration."
    exit 1
fi

echo "SSH configuration updated successfully."
