#!/bin/bash
echo " Before the permission changes"
ls -ld /etc/cron*
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
chown root:root /etc/cron.hourly/
chmod og-rwx /etc/cron.hourly/
chown root:root /etc/cron.daily/
chmod og-rwx /etc/cron.daily/
chown root:root /etc/cron.weekly/
chmod og-rwx /etc/cron.weekly/
chown root:root /etc/cron.monthly/
chmod og-rwx /etc/cron.monthly/
chown root:root /etc/cron.d/
chmod og-rwx /etc/cron.d/
echo "***After permission changes****"
ls -ld /etc/cron*

echo "Configured permissions on /etc/sshd_Config "
chmod u-x,og-rwx /etc/ssh/sshd_config chown root:root /etc/ssh/sshd_config sudo systemctl restart ssh

echo  "*****Banner is configured or not **************"
sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep banner
