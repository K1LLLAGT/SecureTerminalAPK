#!/bin/bash
################################################################################
# Log Consolidation Script
# Merges all logs into consolidated views
################################################################################

source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"
init_logging

LOG_BASE="$HOME/SecureTerminalAPK/logs"
OUTPUT_DIR="$LOG_BASE/consolidated"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

log_info "Starting log consolidation..."

# Consolidate all logs by date
for log_file in $(find "$LOG_BASE" -name "*.log" -type f); do
    cat "$log_file" >> "$OUTPUT_DIR/all_logs_$TIMESTAMP.log"
done

log_info "Logs consolidated to: $OUTPUT_DIR/all_logs_$TIMESTAMP.log"

# Create error summary
echo "# Error Summary - $(date)" > "$OUTPUT_DIR/error_summary_$TIMESTAMP.md"
echo "" >> "$OUTPUT_DIR/error_summary_$TIMESTAMP.md"

grep -r "\[ERROR\]" "$LOG_BASE" 2>/dev/null | \
    sort -u >> "$OUTPUT_DIR/error_summary_$TIMESTAMP.md" || true

log_info "Error summary created"

# Create statistics
cat > "$OUTPUT_DIR/log_statistics_$TIMESTAMP.txt" << STATSEOF
Log Statistics - $(date)
================================

Total log files: $(find "$LOG_BASE" -name "*.log" | wc -l)
Total errors: $(grep -r "\[ERROR\]" "$LOG_BASE" 2>/dev/null | wc -l)
Total warnings: $(grep -r "\[WARN\]" "$LOG_BASE" 2>/dev/null | wc -l)
Total info messages: $(grep -r "\[INFO\]" "$LOG_BASE" 2>/dev/null | wc -l)

Disk usage: $(du -sh "$LOG_BASE" | cut -f1)

Recent errors:
$(grep -r "\[ERROR\]" "$LOG_BASE" 2>/dev/null | tail -n 10 || echo "None")
STATSEOF

log_info "Statistics generated"

# Cleanup old consolidated logs (keep last 10)
cd "$OUTPUT_DIR"
ls -t all_logs_*.log 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null || true

log_info "Consolidation complete!"
finish_logging
