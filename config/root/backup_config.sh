#!/bin/bash
# Configuration Backup Script

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/sdcard/backups"
CONFIG_DIR="$HOME/SecureTerminalAPK/config"

# Create backup
tar -czf "$BACKUP_DIR/config_backup_$TIMESTAMP.tar.gz" "$CONFIG_DIR"

echo "Backup created: config_backup_$TIMESTAMP.tar.gz"

# Keep only last 10 backups
cd "$BACKUP_DIR"
ls -t config_backup_*.tar.gz | tail -n +11 | xargs rm -f 2>/dev/null

echo "Old backups cleaned up"
