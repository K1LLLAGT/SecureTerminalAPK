#!/bin/bash
################################################################################
# Root Directory Scanner - Educational Tool
# Scans and catalogs directory structure for research
################################################################################

OUTPUT_FILE="/sdcard/backups/rootDirectory-listing.txt"
LOG_FILE="$HOME/SecureTerminalAPK/logs/security_logs/directory_scan.log"

echo "==================================================================" > "$OUTPUT_FILE"
echo "Directory Scan - Educational Research" >> "$OUTPUT_FILE"
echo "Timestamp: $(date)" >> "$OUTPUT_FILE"
echo "==================================================================" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Scan home directory
echo "[HOME DIRECTORY]" >> "$OUTPUT_FILE"
ls -laR "$HOME" 2>/dev/null >> "$OUTPUT_FILE" || echo "Access denied" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Scan storage
if [ -d "/sdcard" ]; then
    echo "[STORAGE]" >> "$OUTPUT_FILE"
    ls -laR "/sdcard" 2>/dev/null | head -n 1000 >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
fi

# Scan app data (if accessible)
echo "[APP DATA - Accessible]" >> "$OUTPUT_FILE"
ls -la "/data/data/com.termux" 2>/dev/null >> "$OUTPUT_FILE" || echo "Not accessible" >> "$OUTPUT_FILE"

# Log completion
echo "[$(date)] Directory scan completed" >> "$LOG_FILE"
echo "Scan complete! Output: $OUTPUT_FILE"
