#!/usr/bin/env bash

# Stow config files from dots -> home

set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

stow -v -t "$HOME/.config" config
stow -v -t "$HOME/.local" local
