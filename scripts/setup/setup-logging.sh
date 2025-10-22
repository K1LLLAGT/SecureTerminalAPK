#!/bin/bash
################################################################################
# Comprehensive Logging System Setup
# Creates consolidated logging infrastructure for error tracking and debugging
################################################################################

set -e

PROJECT_ROOT="$HOME/SecureTerminalAPK"
LOG_BASE="$PROJECT_ROOT/logs"
STORAGE_LOGS="$HOME/storage/shared/logs"
SDCARD_LOGS="/sdcard/backups/logs"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║         Comprehensive Logging System Setup                   ║
║     Error Tracking • Bug Reports • Session Logs              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# ============================================================================
# CREATE LOG DIRECTORIES
# ============================================================================

echo -e "\n${YELLOW}Creating log directory structure...${NC}\n"

mkdir -p "$LOG_BASE/error_logs"
mkdir -p "$LOG_BASE/bug_reports"
mkdir -p "$LOG_BASE/session_logs"
mkdir -p "$LOG_BASE/security_logs"
mkdir -p "$LOG_BASE/script_outputs"
mkdir -p "$LOG_BASE/consolidated"
mkdir -p "$STORAGE_LOGS" 2>/dev/null || true
mkdir -p "$SDCARD_LOGS" 2>/dev/null || true

echo -e "${GREEN}✓${NC} Log directories created"

# ============================================================================
# CREATE LOGGING CONFIGURATION
# ============================================================================

cat > "$PROJECT_ROOT/config/logging_config.env" << 'LOGCONFIGEOF'
# Logging Configuration
# This file is sourced by all scripts for consistent logging

# Log locations
export ERROR_LOGS="$HOME/SecureTerminalAPK/logs/error_logs"
export BUG_REPORTS="$HOME/SecureTerminalAPK/logs/bug_reports"
export SESSION_LOGS="$HOME/SecureTerminalAPK/logs/session_logs"
export SECURITY_LOGS="$HOME/SecureTerminalAPK/logs/security_logs"
export SCRIPT_LOGS="$HOME/SecureTerminalAPK/logs/script_outputs"
export CONSOLIDATED_LOG="$HOME/SecureTerminalAPK/logs/consolidated/all_logs.log"

# Storage locations
export STORAGE_LOGS="$HOME/storage/shared/logs"
export SDCARD_LOGS="/sdcard/backups/logs"

# Log settings
export LOG_LEVEL="DEBUG"  # DEBUG, INFO, WARN, ERROR
export LOG_MAX_SIZE="10M"
export LOG_RETENTION_DAYS=30
export ENABLE_CONSOLE_OUTPUT=true
export ENABLE_FILE_OUTPUT=true
export ENABLE_CONSOLIDATED=true

# Timestamp format
export LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"

# Colors for console output
export LOG_COLOR_ERROR="\033[0;31m"
export LOG_COLOR_WARN="\033[1;33m"
export LOG_COLOR_INFO="\033[0;32m"
export LOG_COLOR_DEBUG="\033[0;34m"
export LOG_COLOR_RESET="\033[0m"
LOGCONFIGEOF

echo -e "${GREEN}✓${NC} Logging configuration created"

# ============================================================================
# CREATE LOGGING LIBRARY
# ============================================================================

cat > "$PROJECT_ROOT/scripts/utilities/logging_lib.sh" << 'LOGLIBEOF'
#!/bin/bash
################################################################################
# Logging Library
# Provides standardized logging functions for all scripts
################################################################################

# Source configuration
[ -f "$HOME/SecureTerminalAPK/config/logging_config.env" ] && \
    source "$HOME/SecureTerminalAPK/config/logging_config.env"

# Initialize logging
init_logging() {
    local script_name=$(basename "$0" .sh)
    export CURRENT_LOG_FILE="$SCRIPT_LOGS/${script_name}_$(date +%Y%m%d_%H%M%S).log"
    
    # Create log file
    touch "$CURRENT_LOG_FILE"
    
    # Log script start
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    echo "Script: $script_name" >> "$CURRENT_LOG_FILE"
    echo "Started: $(date +"$LOG_TIMESTAMP_FORMAT")" >> "$CURRENT_LOG_FILE"
    echo "PID: $$" >> "$CURRENT_LOG_FILE"
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
}

# Log functions
log_error() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [ERROR] $message"
    
    # Console output
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_ERROR}[ERROR]${LOG_COLOR_RESET} $message"
    fi
    
    # File output
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
        echo "$log_entry" >> "$ERROR_LOGS/errors_$(date +%Y%m%d).log"
    fi
    
    # Consolidated log
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_warn() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [WARN] $message"
    
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_WARN}[WARN]${LOG_COLOR_RESET} $message"
    fi
    
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
    fi
    
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_info() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [INFO] $message"
    
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_INFO}[INFO]${LOG_COLOR_RESET} $message"
    fi
    
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
    fi
    
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_debug() {
    local message="$1"
    
    # Only log if debug level is enabled
    if [ "$LOG_LEVEL" = "DEBUG" ]; then
        local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
        local log_entry="[$timestamp] [DEBUG] $message"
        
        if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
            echo -e "${LOG_COLOR_DEBUG}[DEBUG]${LOG_COLOR_RESET} $message"
        fi
        
        if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
            echo "$log_entry" >> "$CURRENT_LOG_FILE"
        fi
    fi
}

# Create bug report
create_bug_report() {
    local title="$1"
    local description="$2"
    local report_file="$BUG_REPORTS/bug_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << BUGREPORT
# Bug Report

**Date:** $(date)
**Title:** $title

## Description
$description

## Environment
- Script: $(basename "$0")
- User: $USER
- Shell: $SHELL
- PWD: $PWD

## Recent Logs
\`\`\`
$(tail -n 50 "$CURRENT_LOG_FILE" 2>/dev/null || echo "No recent logs")
\`\`\`

## System Info
$(uname -a)

## Error Context
$(tail -n 20 "$ERROR_LOGS/errors_$(date +%Y%m%d).log" 2>/dev/null || echo "No recent errors")
BUGREPORT

    echo "Bug report created: $report_file"
    log_info "Bug report created: $report_file"
}

# Finish logging
finish_logging() {
    local exit_code=$?
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    echo "Finished: $timestamp" >> "$CURRENT_LOG_FILE"
    echo "Exit code: $exit_code" >> "$CURRENT_LOG_FILE"
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    
    # Copy to storage if available
    if [ -d "$STORAGE_LOGS" ]; then
        cp "$CURRENT_LOG_FILE" "$STORAGE_LOGS/" 2>/dev/null || true
    fi
    
    if [ -d "$SDCARD_LOGS" ]; then
        cp "$CURRENT_LOG_FILE" "$SDCARD_LOGS/" 2>/dev/null || true
    fi
    
    return $exit_code
}

# Trap errors
trap_errors() {
    set -E
    trap 'log_error "Error on line $LINENO: $BASH_COMMAND"' ERR
}
LOGLIBEOF

chmod +x "$PROJECT_ROOT/scripts/utilities/logging_lib.sh"
echo -e "${GREEN}✓${NC} Logging library created"

# ============================================================================
# CREATE LOG CONSOLIDATION SCRIPT
# ============================================================================

cat > "$PROJECT_ROOT/scripts/utilities/consolidate_logs.sh" << 'CONSOLIDATEOF'
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
CONSOLIDATEOF

chmod +x "$PROJECT_ROOT/scripts/utilities/consolidate_logs.sh"
echo -e "${GREEN}✓${NC} Log consolidation script created"

# ============================================================================
# CREATE LOG VIEWER SCRIPT
# ============================================================================

cat > "$PROJECT_ROOT/scripts/utilities/view_logs.sh" << 'VIEWEOF'
#!/bin/bash
################################################################################
# Interactive Log Viewer
################################################################################

LOG_BASE="$HOME/SecureTerminalAPK/logs"

show_menu() {
    clear
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Log Viewer                                ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "1) View Error Logs"
    echo "2) View Bug Reports"
    echo "3) View Session Logs"
    echo "4) View Security Logs"
    echo "5) View Consolidated Logs"
    echo "6) Search Logs"
    echo "7) Show Log Statistics"
    echo "8) Exit"
    echo ""
    read -p "Choose option: " choice
}

while true; do
    show_menu
    
    case $choice in
        1)
            echo -e "\n=== Recent Errors ==="
            tail -n 50 "$LOG_BASE/error_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -e "\n=== Bug Reports ==="
            ls -lt "$LOG_BASE/bug_reports"/*.md 2>/dev/null | head -n 10
            read -p "View a report? (filename or Enter): " report
            [ -n "$report" ] && cat "$LOG_BASE/bug_reports/$report" | less
            ;;
        3)
            echo -e "\n=== Recent Sessions ==="
            tail -n 100 "$LOG_BASE/session_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        4)
            echo -e "\n=== Security Logs ==="
            tail -n 50 "$LOG_BASE/security_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        5)
            latest=$(ls -t "$LOG_BASE/consolidated"/all_logs_*.log 2>/dev/null | head -n 1)
            if [ -n "$latest" ]; then
                less "$latest"
            else
                echo "No consolidated logs found"
                read -p "Press Enter to continue..."
            fi
            ;;
        6)
            read -p "Search term: " term
            grep -r "$term" "$LOG_BASE" 2>/dev/null | less
            ;;
        7)
            latest=$(ls -t "$LOG_BASE/consolidated"/log_statistics_*.txt 2>/dev/null | head -n 1)
            if [ -n "$latest" ]; then
                cat "$latest"
            else
                echo "No statistics found. Run consolidate_logs.sh first."
            fi
            read -p "Press Enter to continue..."
            ;;
        8)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done
VIEWEOF

chmod +x "$PROJECT_ROOT/scripts/utilities/view_logs.sh"
echo -e "${GREEN}✓${NC} Log viewer created"

# ============================================================================
# CREATE CRON/AUTOMATIC CLEANUP
# ============================================================================

cat > "$PROJECT_ROOT/scripts/utilities/cleanup_old_logs.sh" << 'CLEANUPEOF'
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
CLEANUPEOF

chmod +x "$PROJECT_ROOT/scripts/utilities/cleanup_old_logs.sh"
echo -e "${GREEN}✓${NC} Cleanup script created"

# ============================================================================
# ADD TO BASHRC
# ============================================================================

BASHRC="$HOME/.bashrc"

if ! grep -q "SecureTerminalAPK/config/logging_config.env" "$BASHRC" 2>/dev/null; then
    cat >> "$BASHRC" << 'BASHRCEOF'

# Secure Terminal APK - Logging Configuration
if [ -f "$HOME/SecureTerminalAPK/config/logging_config.env" ]; then
    source "$HOME/SecureTerminalAPK/config/logging_config.env"
fi

# Helper aliases
alias view-logs='$HOME/SecureTerminalAPK/scripts/utilities/view_logs.sh'
alias consolidate-logs='$HOME/SecureTerminalAPK/scripts/utilities/consolidate_logs.sh'
alias cleanup-logs='$HOME/SecureTerminalAPK/scripts/utilities/cleanup_old_logs.sh'
BASHRCEOF

    echo -e "${GREEN}✓${NC} Added to .bashrc"
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "\n${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            Logging System Setup Complete!                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}\n"

echo "Log directories created:"
echo "  ✓ $LOG_BASE/error_logs"
echo "  ✓ $LOG_BASE/bug_reports"
echo "  ✓ $LOG_BASE/session_logs"
echo "  ✓ $LOG_BASE/security_logs"
echo "  ✓ $LOG_BASE/consolidated"

echo -e "\nUtilities available:"
echo "  • view-logs           - Interactive log viewer"
echo "  • consolidate-logs    - Merge all logs"
echo "  • cleanup-logs        - Remove old logs"

echo -e "\nFor script development, use:"
echo '  source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"'
echo "  init_logging"
echo "  log_info \"Your message\""
echo "  log_error \"Error message\""

echo -e "\nTo activate:"
echo "  source ~/.bashrc"

echo -e "\n${GREEN}Logging system ready for educational research!${NC}\n"
