#!/bin/bash

VAR_COUNTRY="DE"
VAR_TIMEZONE="Europe/Berlin"
VAR_HOSTNAME="raspikiosk"

echo -e "---Raspberry Pi Firefox Kiosk Setup---\n"

# Check for root permissions
if [ "$EUID" -ne 0 ]
then
  echo -e "This script requires root permissions.\nPlease start this script as root (e.g. sudo <script>)."
  exit 1
fi

# Upgrade every package
apt-get update && apt-get dist-upgrade -y && apt-get autoremove

# Set timezone
timedatectl set-timezone $VAR_TIMEZONE

# Config raspi
raspi-config nonint do_wifi_country $VAR_COUNTRY
raspi-config nonint do_hostname $VAR_HOSTNAME
