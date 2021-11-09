#!/bin/bash

VAR_COUNTRY="DE"
VAR_TIMEZONE="Europe/Berlin" # timedatectl list-timezones
VAR_KEYMAP="de"
VAR_LOCALE="de_DE.UTF-8 UTF-8" # /usr/share/i18n/SUPPORTED
VAR_HOSTNAME="raspikiosk"

# Check for root permissions
if [ "$EUID" -ne 0 ]; then
  echo -e "This script requires root permissions.\nPlease start this script as root (e.g. sudo <script>)."
  exit 1
fi

cd "${BASH_SOURCE%/*}"

TITLE="PI Kiosk Setup"

function changeSettings () {
  VAR_COUNTRY="$(whiptail --inputbox "Which country do you live in?" --title "$TITLE" 8 60 "$VAR_COUNTRY" --nocancel 3>&1 1>&2 2>&3)"
  VAR_TIMEZONE="$(whiptail --inputbox "Which timezone do you live in?\nSupported timezones: timedatectl list-timezones" --title "$TITLE" 8 60 "$VAR_TIMEZONE" --nocancel 3>&1 1>&2 2>&3)"
  VAR_KEYMAP="$(whiptail --inputbox "Which keymap do you use?" --title "$TITLE" 8 60 "$VAR_KEYMAP" --nocancel 3>&1 1>&2 2>&3)"
  VAR_LOCALE="$(whiptail --inputbox "Which locale do you want to use?\nSupported values: /usr/share/i18n/SUPPORTED" --title "$TITLE" 8 60 "$VAR_LOCALE" --nocancel 3>&1 1>&2 2>&3)"
  VAR_HOSTNAME="$(whiptail --inputbox "Which hostname do you want to use?" --title "$TITLE" 8 60 "$VAR_HOSTNAME" --nocancel 3>&1 1>&2 2>&3)"
}

if [ "$1" == "nonint" ]; then
  NO_QUESTIONS=1
fi

if [ $NO_QUESTIONS ]; then
  echo -e "--- $TITLE ---\n"
else
  if ( ! whiptail --title "$TITLE" --yesno "Would you like to start the setup?" 8 60); then
    exit 1
  fi
fi

if [ ! $NO_QUESTIONS ]; then
  while ( ! whiptail --yesno "Are the following settings correct?\n\nCOUNTRY:    $VAR_COUNTRY\nTIMENZONE:  $VAR_TIMEZONE\nKEYMAP:     $VAR_KEYMAP\nLOCALE:     $VAR_LOCALE\nHOSTNAME:   $VAR_HOSTNAME\n" --title "$TITLE" 13 60 ); do
  changeSettings
  done
fi

# Upgrade every package
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean -y

# Set timezone
timedatectl set-timezone $VAR_TIMEZONE

# Config raspi
raspi-config nonint do_wifi_country $VAR_COUNTRY
raspi-config nonint do_hostname $VAR_HOSTNAME
raspi-config nonint do_overscan 1
raspi-config nonint do_configure_keyboard $VAR_KEYMAP
raspi-config nonint do_change_locale $VAR_LOCALE

# Remove swap
apt-get purge dphys-swapfile -y

# Install PIXEL UI
apt-get install raspberrypi-ui-mods -y

# Activate auto login
raspi-config nonint do_boot_behaviour "B4"

# Install unattended upgrade
apt-get install unattended-upgrades -y

# Install Firefox ESR
apt-get install firefox-esr -y

# Remove Screensaver
apt-get purge xscreensaver -y

raspi-config nonint do_blanking 1

# Update splashscreen
cp "./splash.png" "/usr/share/plymouth/themes/pix"

# Install unclutter
apt install unclutter-xfixes -y

# Install firewall
apt install ufw -y

# Remove unused dependencies
apt-get autoremove -y
apt-get clean -y

# Apply config
sudo ./apply_config.sh

# Enable firewall
ufw enable

# Change pi user password
echo "Changing password for user \"pi\""
passwd pi

# Require password for sudo
echo -e "pi ALL=(ALL) PASSWD: ALL\n" > /etc/sudoers.d/010_pi-nopasswd

# Reboot system
reboot now