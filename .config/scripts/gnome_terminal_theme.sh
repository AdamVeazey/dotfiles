#!/bin/bash

PROFILE_NAME="WezTerm"

# 1. Get Profile ID
IDS=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]',")
PROFILE_ID=""
for id in $IDS; do
    name=$(gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$id/" visible-name | tr -d "'")
    if [ "$name" == "$PROFILE_NAME" ]; then PROFILE_ID=$id; break; fi
done

if [ -z "$PROFILE_ID" ]; then
    echo "Error: Profile '$PROFILE_NAME' not found."
    exit 1
fi

PATH_PREFIX="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/"

# 2. Colors & Palette
PALETTE="'#252525', '#ff9f95', '#a6e22e', '#fd971f', '#435e87', '#789ec6', '#5e7175', '#dbdcdc', '#454545', '#ff8d80', '#b6e354', '#fd971f', '#587aa4', '#46a4ff', '#a3babf', '#fdfdfd'"

gsettings set "$PATH_PREFIX" use-theme-colors false
gsettings set "$PATH_PREFIX" foreground-color "'#ffffff'"
gsettings set "$PATH_PREFIX" background-color "'#000000'"
gsettings set "$PATH_PREFIX" palette "[$PALETTE]"

# 3. Transparency
gsettings set "$PATH_PREFIX" use-transparent-background true
gsettings set "$PATH_PREFIX" background-transparency-percent 15

# 4. Cursor Fix (White block, Black text)
gsettings set "$PATH_PREFIX" cursor-colors-set true
gsettings set "$PATH_PREFIX" cursor-background-color "'#ffffff'"
gsettings set "$PATH_PREFIX" cursor-foreground-color "'#000000'"

echo "Successfully updated colors, transparency, and cursor for '$PROFILE_NAME'."
