#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface font-name 'Google Sans 12'
gsettings set org.gnome.desktop.interface document-font-name 'Google Sans 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'Google Sans Code 12'

current=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$current" == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi
