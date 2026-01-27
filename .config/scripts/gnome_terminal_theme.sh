#!/bin/bash

# Configuration
PROFILE_NAME="WezTerm"
FONT="Inconsolata Nerd Font 14" 
OPACITY=15
ROWS=30
COLS=120

# WezTerm Palette
PALETTE="'#252525', '#ff9f95', '#a6e22e', '#fd971f', '#435e87', '#789ec6', '#5e7175', '#dbdcdc', '#454545', '#ff8d80', '#b6e354', '#fd971f', '#587aa4', '#46a4ff', '#a3babf', '#fdfdfd'"

# ==========================================
# 1. robust UUID Generation
# ==========================================
generate_uuid() {
    # Try kernel first (fastest, no deps)
    if [ -r /proc/sys/kernel/random/uuid ]; then
        cat /proc/sys/kernel/random/uuid
    # Try uuidgen (common)
    elif command -v uuidgen >/dev/null 2>&1; then
        uuidgen
    # Try dbus (Debian fallback)
    elif command -v dbus-uuidgen >/dev/null 2>&1; then
        dbus-uuidgen
    else
        # Desperate fallback: python
        python3 -c 'import uuid; print(uuid.uuid4())'
    fi
}

# ==========================================
# 2. Profile List Logic (The Fix)
# ==========================================

# Get the raw list from gsettings
RAW_LIST=$(gsettings get org.gnome.Terminal.ProfilesList list)

# Clean it up: Remove @as, brackets, quotes, commas, and spaces
# This leaves us with a clean, space-separated list of UUIDs
CLEAN_IDS=$(echo "$RAW_LIST" | sed "s/@as//g" | tr -d "[]',")

PROFILE_ID=""
FOUND=0

# Check if profile already exists
for id in $CLEAN_IDS; do
    # On some systems, the visible-name key might be missing for default profiles, so we silence errors
    name=$(gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$id/" visible-name 2>/dev/null | tr -d "'")
    if [ "$name" == "$PROFILE_NAME" ]; then
        PROFILE_ID=$id
        FOUND=1
        break
    fi
done

if [ "$FOUND" -eq 0 ]; then
    echo "Profile '$PROFILE_NAME' not found. Creating..."
    PROFILE_ID=$(generate_uuid)
    
    # Reconstruct the list string properly for GSettings
    if [ -z "$CLEAN_IDS" ]; then
        # List was empty
        NEW_LIST="['$PROFILE_ID']"
    else
        # List had items, rebuild it and append ours
        # We wrap each existing ID in single quotes
        FORMATTED_EXISTING=$(echo "$CLEAN_IDS" | sed "s/\s\+/', '/g")
        NEW_LIST="['$FORMATTED_EXISTING', '$PROFILE_ID']"
    fi
    
    # 1. Update the main list
    gsettings set org.gnome.Terminal.ProfilesList list "$NEW_LIST"
    
    # 2. Set the visible name immediately so it's valid
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/" visible-name "$PROFILE_NAME"
fi

# ==========================================
# 3. Apply Settings
# ==========================================
PATH_PREFIX="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/"

echo "Applying settings to ID: $PROFILE_ID"

# Set as default
gsettings set org.gnome.Terminal.ProfilesList default "'$PROFILE_ID'"

# Basic Settings
gsettings set "$PATH_PREFIX" default-size-columns $COLS
gsettings set "$PATH_PREFIX" default-size-rows $ROWS
gsettings set "$PATH_PREFIX" scrollback-unlimited true
gsettings set "$PATH_PREFIX" use-system-font false
gsettings set "$PATH_PREFIX" font "'$FONT'"

# Colors
gsettings set "$PATH_PREFIX" use-theme-colors false
gsettings set "$PATH_PREFIX" foreground-color "'#ffffff'"
gsettings set "$PATH_PREFIX" background-color "'#000000'"
gsettings set "$PATH_PREFIX" palette "[$PALETTE]"

# Transparency (Try/Catch style for Debian vs Arch)
# We try to set it, but silence the error if the key doesn't exist (Debian)
gsettings set "$PATH_PREFIX" use-transparent-background true 2>/dev/null
gsettings set "$PATH_PREFIX" background-transparency-percent $OPACITY 2>/dev/null

# Cursor
gsettings set "$PATH_PREFIX" cursor-colors-set true
gsettings set "$PATH_PREFIX" cursor-background-color "'#ffffff'"
gsettings set "$PATH_PREFIX" cursor-foreground-color "'#000000'"
gsettings set "$PATH_PREFIX" cursor-shape "'block'"

echo "Success. Restart your terminal to see changes."
