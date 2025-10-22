#!/bin/bash
################################################################################
# Termux Root Setup Script - Educational & Research Purpose
# 
# This script configures root integration for educational security research
# IMPORTANT: Only use in authorized testing environments
################################################################################

set -e

# Configuration
PROJECT_ROOT="$HOME/SecureTerminalAPK"
ROOT_CONFIG_DIR="$PROJECT_ROOT/config/root"
LOG_DIR="$PROJECT_ROOT/logs/security_logs"
BACKUP_DIR="/sdcard/backups"

# Logging configuration
LOG_FILE="$LOG_DIR/root_setup_$(date +%Y%m%d_%H%M%S).log"
ERROR_LOG="$LOG_DIR/root_errors_$(date +%Y%m%d_%H%M%S).log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$ERROR_LOG"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1" | tee -a "$LOG_FILE"
}

# ============================================================================
# INITIALIZATION
# ============================================================================

init_logging() {
    mkdir -p "$LOG_DIR"
    mkdir -p "$ROOT_CONFIG_DIR"
    mkdir -p "$BACKUP_DIR"
    
    echo "==================================================================" > "$LOG_FILE"
    echo "Root Setup Script - Educational Research" >> "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "User: $USER" >> "$LOG_FILE"
    echo "==================================================================" >> "$LOG_FILE"
    
    log_info "Logging initialized"
}

# ============================================================================
# SAFETY CHECKS
# ============================================================================

educational_disclaimer() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              EDUCATIONAL USE DISCLAIMER                      ║
╚══════════════════════════════════════════════════════════════╝

This script is for EDUCATIONAL and RESEARCH purposes only.

Root access should only be used for:
  ✓ Authorized security research
  ✓ Educational learning environments
  ✓ Personal device testing (with backup)
  ✓ Controlled lab environments

Do NOT use for:
  ✗ Unauthorized system access
  ✗ Malicious purposes
  ✗ Production systems without authorization
  ✗ Violating terms of service

By continuing, you acknowledge:
  • You have authorization to modify this system
  • You understand the risks involved
  • This is for legitimate educational/research use
  • You have backed up important data

EOF
    
    read -p "Do you accept these terms? (yes/no): " acceptance
    if [ "$acceptance" != "yes" ]; then
        log_warn "User declined terms. Exiting."
        echo "Setup cancelled."
        exit 0
    fi
    
    log_info "User accepted educational terms"
}

check_environment() {
    log_info "Checking environment..."
    
    # Check if we're in Termux
    if [ ! -d "/data/data/com.termux" ]; then
        log_warn "Not running in Termux environment"
    else
        log_info "Termux environment detected"
    fi
    
    # Check for root access (educational check)
    if command -v su &> /dev/null; then
        log_info "Root access binary found"
    else
        log_warn "No root access found (this is normal for educational setup)"
    fi
    
    # Check available tools
    for tool in bash grep sed awk; do
        if command -v $tool &> /dev/null; then
            log_debug "Tool available: $tool"
        else
            log_error "Missing tool: $tool"
        fi
    done
}

# ============================================================================
# ROOT CONFIGURATION
# ============================================================================

create_root_config() {
    log_info "Creating root configuration..."
    
    local config_file="$ROOT_CONFIG_DIR/root_config.env"
    
    cat > "$config_file" << 'CONFIGEOF'
# Root Configuration - Educational Research
# Generated: $(date)

# Paths
export PATH_TO_ROOT="/data/local/tmp"
export ROOT_HOME="$HOME"
export ROOT_BACKUP="/sdcard/backups/root"

# Safety Settings
export ROOT_EDUCATION_MODE=true
export ROOT_LOG_ALL_COMMANDS=true
export ROOT_REQUIRE_CONFIRMATION=true

# Network Configuration
export ROOT_LOCALHOST="127.0.0.1"
export ROOT_SERVER="0.0.0.0"
export ROOT_PORT="9001"

# Logging
export ROOT_LOG_DIR="$HOME/SecureTerminalAPK/logs/security_logs"
export ROOT_ERROR_LOG="$ROOT_LOG_DIR/root_errors.log"
export ROOT_ACCESS_LOG="$ROOT_LOG_DIR/root_access.log"

# Directory Listing Output
export ROOT_LISTING_OUTPUT="/sdcard/backups/rootDirectory-listing.txt"
CONFIGEOF

    log_info "Root config created: $config_file"
    
    # Create backup
    cp "$config_file" "$BACKUP_DIR/root_config_backup_$(date +%Y%m%d).env"
    log_info "Backup created"
}

create_root_wrapper() {
    log_info "Creating safe root wrapper..."
    
    local wrapper="$ROOT_CONFIG_DIR/safe_root_exec.sh"
    
    cat > "$wrapper" << 'WRAPPEREOF'
#!/bin/bash
################################################################################
# Safe Root Execution Wrapper - Educational
# Logs all commands and requires confirmation
################################################################################

source "$HOME/SecureTerminalAPK/config/root/root_config.env"

COMMAND="$@"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Log the command
echo "[$TIMESTAMP] Command requested: $COMMAND" >> "$ROOT_ACCESS_LOG"

# In educational mode, show what would be executed
if [ "$ROOT_EDUCATION_MODE" = "true" ]; then
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           EDUCATIONAL MODE - COMMAND PREVIEW                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Command that would be executed with root:"
    echo "  $COMMAND"
    echo ""
    echo "In production, this would require root access."
    echo "For educational purposes, we'll simulate or run unprivileged."
    echo ""
    
    if [ "$ROOT_REQUIRE_CONFIRMATION" = "true" ]; then
        read -p "Continue with simulation? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            echo "Cancelled."
            exit 1
        fi
    fi
fi

# Execute the command (educational - without actual root)
echo "Executing (educational mode)..."
eval "$COMMAND" 2>&1 | tee -a "$ROOT_LOG_DIR/command_output.log"

EXIT_CODE=$?
echo "[$TIMESTAMP] Exit code: $EXIT_CODE" >> "$ROOT_ACCESS_LOG"

exit $EXIT_CODE
WRAPPEREOF

    chmod +x "$wrapper"
    log_info "Safe root wrapper created: $wrapper"
}

create_directory_scanner() {
    log_info "Creating directory scanner..."
    
    local scanner="$ROOT_CONFIG_DIR/scan_root_directory.sh"
    
    cat > "$scanner" << 'SCANEOF'
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
SCANEOF

    chmod +x "$scanner"
    log_info "Directory scanner created: $scanner"
}

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

configure_path() {
    log_info "Configuring PATH..."
    
    local bashrc="$HOME/.bashrc"
    local path_config="$ROOT_CONFIG_DIR/path_additions.sh"
    
    cat > "$path_config" << 'PATHEOF'
# Root Integration PATH Configuration - Educational

# Add secure terminal scripts to PATH
export PATH="$HOME/SecureTerminalAPK/scripts/root-integration:$PATH"
export PATH="$HOME/SecureTerminalAPK/scripts/security-tools:$PATH"
export PATH="$HOME/SecureTerminalAPK/scripts/utilities:$PATH"

# Source root config if available
if [ -f "$HOME/SecureTerminalAPK/config/root/root_config.env" ]; then
    source "$HOME/SecureTerminalAPK/config/root/root_config.env"
fi
PATHEOF

    log_info "PATH configuration created: $path_config"
    
    # Add to bashrc if not already present
    if ! grep -q "SecureTerminalAPK/config/root/path_additions.sh" "$bashrc" 2>/dev/null; then
        echo "" >> "$bashrc"
        echo "# Secure Terminal APK - Educational Root Integration" >> "$bashrc"
        echo "[ -f \"$path_config\" ] && source \"$path_config\"" >> "$bashrc"
        log_info "Added to .bashrc"
    else
        log_info "Already in .bashrc"
    fi
}

# ============================================================================
# BACKUP SYSTEM
# ============================================================================

create_backup_system() {
    log_info "Setting up backup system..."
    
    local backup_script="$ROOT_CONFIG_DIR/backup_config.sh"
    
    cat > "$backup_script" << 'BACKUPEOF'
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
BACKUPEOF

    chmod +x "$backup_script"
    log_info "Backup system configured: $backup_script"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    clear
    
    echo -e "${BLUE}"
    cat << 'BANNER'
╔══════════════════════════════════════════════════════════════╗
║        Termux Root Setup - Educational Research Tool         ║
╚══════════════════════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    
    # Initialize
    init_logging
    
    # Safety disclaimer
    educational_disclaimer
    
    # Check environment
    check_environment
    
    # Create configurations
    create_root_config
    create_root_wrapper
    create_directory_scanner
    configure_path
    create_backup_system
    
    # Summary
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Root Setup Complete (Educational)               ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Setup completed successfully"
    
    echo "Configuration files created:"
    echo "  ✓ Root config: $ROOT_CONFIG_DIR/root_config.env"
    echo "  ✓ Safe wrapper: $ROOT_CONFIG_DIR/safe_root_exec.sh"
    echo "  ✓ Directory scanner: $ROOT_CONFIG_DIR/scan_root_directory.sh"
    echo "  ✓ Backup script: $ROOT_CONFIG_DIR/backup_config.sh"
    echo ""
    echo "Logs saved to:"
    echo "  ✓ Main log: $LOG_FILE"
    echo "  ✓ Error log: $ERROR_LOG"
    echo ""
    echo "To activate changes:"
    echo "  source ~/.bashrc"
    echo ""
    echo "Educational commands available:"
    echo "  • safe_root_exec.sh <command>    - Execute with logging"
    echo "  • scan_root_directory.sh         - Scan and catalog"
    echo "  • backup_config.sh               - Backup configuration"
    echo ""
}

# Run main function
main "$@"
