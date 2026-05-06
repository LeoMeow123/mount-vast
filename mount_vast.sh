#!/usr/bin/env bash
set -euo pipefail

# Mount Salk VAST storage via CIFS/SMB
# Usage: sudo bash mount_vast.sh

SHARE="//10.7.40.84/talmo"
MOUNT_POINT="$HOME/vast"
CREDS_FILE="/etc/.smbcredentials.talmodata"

# --- Install cifs-utils if missing ---
if ! dpkg -s cifs-utils &>/dev/null; then
    echo "Installing cifs-utils..."
    sudo apt-get update && sudo apt-get install -y cifs-utils
fi

# --- Create mount point ---
mkdir -p "$MOUNT_POINT"

# --- Create credentials file ---
if [ ! -f "$CREDS_FILE" ]; then
    echo "Creating SMB credentials file at $CREDS_FILE"
    read -rp "AD username (e.g. scyang): " smb_user
    read -rsp "AD password: " smb_pass
    echo

    sudo tee "$CREDS_FILE" > /dev/null <<EOF
username=${smb_user}
password=${smb_pass}
domain=ad.salk.edu
EOF
    sudo chmod 600 "$CREDS_FILE"
    echo "Credentials saved."
else
    echo "Credentials file already exists at $CREDS_FILE"
fi

# --- Add fstab entry if not present ---
FSTAB_LINE="${SHARE}/  ${MOUNT_POINT} cifs auto,credentials=${CREDS_FILE},uid=$(id -un),gid=$(id -gn),rw,file_mode=0777,dir_mode=0777,cache=loose 0 0"

if grep -qF "$SHARE" /etc/fstab; then
    echo "fstab entry already exists, skipping."
else
    echo "Adding entry to /etc/fstab..."
    echo "$FSTAB_LINE" | sudo tee -a /etc/fstab > /dev/null
    echo "Added."
fi

# --- Mount ---
echo "Mounting $SHARE to $MOUNT_POINT..."
sudo mount "$MOUNT_POINT"

echo "Done! VAST is mounted at $MOUNT_POINT"
ls "$MOUNT_POINT" | head -10
