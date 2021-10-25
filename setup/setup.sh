#!/bin/bash

VAR_COUNTRY="DE"
VAR_TIMEZONE="Europe/Berlin" # timedatectl list-timezones
VAR_HOSTNAME="raspikiosk"
VAR_KEYMAP="de"
VAR_LOCALE="de_DE.UTF-8 UTF-8" # /usr/share/i18n/SUPPORTED

echo -e "---Raspberry Pi Firefox Kiosk Setup---\n"

# Check for root permissions
if [ "$EUID" -ne 0 ]
then
  echo -e "This script requires root permissions.\nPlease start this script as root (e.g. sudo <script>)."
  exit 1
fi

# Upgrade every package
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean -y

# Set timezone
timedatectl set-timezone $VAR_TIMEZONE

# Config raspi
raspi-config nonint do_wifi_country $VAR_COUNTRY
raspi-config nonint do_hostname $VAR_HOSTNAME
raspi-config nonint do_overscan 0
raspi-config nonint do_configure_keyboard $VAR_KEYMAP
raspi-config nonint do_change_locale $VAR_LOCALE

# Install PIXEL UI
apt install raspberrypi-ui-mods -y

# Activate auto login
raspi-config nonint do_boot_behaviour "B3"

# Reboot system
reboot now