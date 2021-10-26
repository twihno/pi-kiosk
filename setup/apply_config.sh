# Unattended-upgrades config
cp "./50unattended-upgrades" "/etc/apt/apt.conf.d"

# Firefox config
cp "./autoconfig.js" "/usr/lib/firefox-esr/defaults/pref"
cp "./firefox.cfg" "/usr/lib/firefox-esr/"

# Autostart config
cp "./autostart" "/etc/xdg/lxsession/LXDE-pi"
