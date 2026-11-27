# qsDots
Made for Arch, should be agnostic though.

### Dependencies
Required:
`hyprland quickshell-git hypridle hyprlock hyprsunset awww matugen
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk stow
pipewire pipewire-pulse wireplumber networkmanager bluez bluez-utils upower
imagemagick inotify-tools curl brightnessctl playerctl cava
ttf-google-sans ttf-googlesanscode-nerd ttf-jetbrains-mono-nerd
adw-gtk-theme papirus-icon-theme papirus-folders
gtk3 dconf gsettings-desktop-schemas qt6-wayland qt6-imageformats qt6-declarative`

Default apps: `floorp-bin kitty nautilus wlogout`
Cursors: `moga-white-cursors`

Optional / themed by matugen: `neovim btop rofi vesktop Steam Heroic GTK Kitty Discord OBS etc`

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
   * Game bar
   * Agent

* App launcher
* Control panel
* Wifi & Bluetooth menus
* Wallpaper selector (random + timed cycle)
* Settings window (persistent prefs)
* Lock screen

* Light / Dark / OLED color schemes
* Fully dynamic matugen colors (shell + kitty, gtk, nvim, browsers, and more)
* Semantic color roles so light mode stays readable
* Firefox site themes via matugenfox + dusky_sites

* Brightness (gamma) control and automatic nightmode
* (optional) Toggle for WLED, nightmode integration for hyperHDR
* Idle inhibitor toggle
* Gaming mode - disable animations and decorations (auto on fullscreen + toggle)
* Volume source picker
* Media controls / now playing
* Media chip visualizer (cava or lightweight bounce, circular dots when paused)
* System monitor
* Weather applet
* Battery indicator (laptop + pinned devices)
* Do-not-disturb toggle
* System tray
* Session menu
* Quick toggles on the pill

### WIP
* More dynamic session menu
* More apps included in config
* Notch style + island