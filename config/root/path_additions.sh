# Root Integration PATH Configuration - Educational

# Add secure terminal scripts to PATH
export PATH="$HOME/SecureTerminalAPK/config/root:$PATH"
export PATH="$HOME/SecureTerminalAPK/scripts/root-integration:$PATH"
export PATH="$HOME/SecureTerminalAPK/scripts/security-tools:$PATH"
export PATH="$HOME/SecureTerminalAPK/scripts/utilities:$PATH"

# Source root config if available
if [ -f "$HOME/SecureTerminalAPK/config/root/root_config.env" ]; then
    source "$HOME/SecureTerminalAPK/config/root/root_config.env"
fi
