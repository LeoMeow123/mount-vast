# mount-vast

A setup script to mount Salk VAST network storage via CIFS/SMB on Linux.

## Overview

This script automates mounting the Salk Institute's VAST storage system (`//10.7.40.84/talmo`) to `~/vast` using CIFS/SMB. It handles dependency installation, credential management, persistent mount configuration, and the initial mount in a single run.

## Prerequisites

- Ubuntu/Debian-based Linux (uses `apt-get`)
- An Active Directory account on `ad.salk.edu` with access to the VAST share
- `sudo` privileges

## Usage

```bash
sudo bash mount_vast.sh
```

On first run, the script will:

1. **Install `cifs-utils`** if not already installed.
2. **Create the mount point** at `~/vast`.
3. **Prompt for your AD credentials** (username and password) and save them to `/etc/.smbcredentials.talmodata` with restricted permissions (`chmod 600`).
4. **Add an `/etc/fstab` entry** so the share auto-mounts on boot.
5. **Mount the share** and list the first 10 entries to confirm success.

On subsequent runs, it skips steps that are already complete (credentials file exists, fstab entry present).

## Mount Details

| Setting | Value |
|---------|-------|
| Share | `//10.7.40.84/talmo` |
| Mount point | `~/vast` |
| Protocol | CIFS/SMB |
| Domain | `ad.salk.edu` |
| File/dir mode | `0777` |
| Cache | `loose` |

## Unmounting

```bash
sudo umount ~/vast
```

To remove the persistent mount, delete the corresponding line from `/etc/fstab`.

## License

MIT
