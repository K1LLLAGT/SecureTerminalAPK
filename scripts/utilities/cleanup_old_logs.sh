#!/bin/bash
################################################################################
# Log Cleanup Script
# Removes logs older than retention period
################################################################################

source "$HOME/SecureTerminalAPK/config/logging_config.env"

LOG_BASE="$HOME/SecureTerminalAPK/logs"
RETENTION_DAYS=${LOG_RETENTION_DAYS:-30}

echo "Cleaning up logs older than $RETENTION_DAYS days..."

# Find and delete old logs
find "$LOG_BASE" -name "*.log" -type f -mtime +$RETENTION_DAYS -delete
find "$LOG_BASE" -name "*.md" -type f -mtime +$RETENTION_DAYS -delete

echo "Cleanup complete!"
