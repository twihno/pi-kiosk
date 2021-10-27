# Pi Kiosk
A simple, single page Firefox webkiosk for Raspberry Pi

# Features
- (Almost) no need for maintenance
  - Unattended Upgrades
  - No SSH enabled
- Firefox ESR
- Automatic install script

# Required Hardware
A Raspberry Pi and a compatible monitor/display (the performance obviously differs between pi generations)

# Setup
- Flash Raspberry Pi OS Lite to a SD card (more information: https://www.raspberrypi.com/software/)
- Boot the pi (display required)
- install git (```sudo apt-get install git```)
- cd to home directory (```cd ~```)
- clone repository (```git clone https://github.com/twihno/pi-kios```)
- cd into the setup folder (```cd ~/pi-kiosk/setup```)
- execute the setup script (```sudo ./setup.sh```) (SUDO required!!!)
- follow the instructions

The pi reboots after the setup. You can press ```Alt+F4``` to close the browser window and perform various tasks e.g. setup your wireless network connection.

# Options
You can run the script with the parameter ```nonint```.
```bash
sudo ./setup.sh nonint
```
This disables the GUI questions and uses the default values instead.

# Disclaimer
This project isn't affiliated with Mozilla or the Raspberry Pi Foundation. I just wanted to setup a simple (and more or less secure) webkiosk on a raspberry pi.