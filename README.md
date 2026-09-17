# qsDots
Made for Arch, should be agnostic though.

### Dependencies
Required:
`hyprland quickshell hypridle hyprlock hyprsunset awww matugen
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk stow
pipewire pipewire-pulse wireplumber networkmanager bluez bluez-utils upower
imagemagick inotify-tools curl ttf-jetbrains-mono-nerd adw-gtk-theme
papirus-icon-theme papirus-folders gtk3 dconf gsettings-desktop-schemas qt6-wayland qt6-imageformats`

Default apps: `floorp-bin kitty nautilus wlogout brightnessctl playerctl`
Cursors: `moga-white-cursors`

### Optional
HDR supported (gamma/nightmode)  
Supports WLED + HyperHDR ambient lights  
Designed on a 32:9 ultrawide OLED

### Install
`./install.sh` - Just stows files, will not check dependencies  
Make sure to backup your original configs and ~/.local/state/quickshell (if it exists). Stow will not overwrite your files


### Features

* Low profile pill with many faces
   * Clock
   * Volume
   * Notifications
   * Workspaces
 
* Wifi & Bluetooth Menu
* Brightness (gamma) control and automatic nightmode
* (optional) Toggle for WLED, nightmode integration for hyperHDR
* Idle Inhibitor toggle
* Gaming mode - disable animations and decorations (Auto on fullscreen + toggle)
* OLED mode - makes base color black
* Volume source picker
* System monitor
* Wallpaper selector - random + timed
* Fully dynamic colorschemes
* Weather applet
* Battery indicator
* Do-not-disturb toggle
* System Tray
* Session Menu

### WIP
* Lock Screen
* More dynamic session menu
* Music visualizer
* Game bar
* More components wired to states (persistent across reboots)
* Settings app
* More apps included in config
