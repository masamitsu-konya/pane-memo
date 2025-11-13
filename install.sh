#!/usr/bin/env bash

# pane-memo installer
# This script installs pane-memo tmux plugin

set -e

echo "Installing pane-memo..."
echo ""

# Create plugins directory if it doesn't exist
PLUGIN_DIR="$HOME/.tmux/plugins"
PANE_MEMO_DIR="$PLUGIN_DIR/pane-memo"

if [ ! -d "$PLUGIN_DIR" ]; then
    echo "Creating plugins directory: $PLUGIN_DIR"
    mkdir -p "$PLUGIN_DIR"
fi

# Check if already installed
if [ -d "$PANE_MEMO_DIR" ]; then
    echo "pane-memo is already installed at $PANE_MEMO_DIR"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Removing existing installation..."
    rm -rf "$PANE_MEMO_DIR"
fi

# Clone repository
echo "Cloning pane-memo repository..."
git clone https://github.com/masamitsu-konya/pane-memo.git "$PANE_MEMO_DIR"

# Check if tmux.conf exists
TMUX_CONF="$HOME/.tmux.conf"
if [ ! -f "$TMUX_CONF" ]; then
    echo "Creating $TMUX_CONF"
    touch "$TMUX_CONF"
fi

# Check if already configured
if grep -q "pane-memo" "$TMUX_CONF"; then
    echo "pane-memo is already configured in $TMUX_CONF"
else
    echo "Adding pane-memo to $TMUX_CONF"
    cat >> "$TMUX_CONF" << 'EOF'

# pane-memo plugin
run-shell ~/.tmux/plugins/pane-memo/pane-memo.tmux
set -g @pane-memo-target-pane "0"
EOF
fi

echo ""
echo "✓ Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Reload tmux configuration:"
echo "     tmux source-file ~/.tmux.conf"
echo ""
echo "  2. In tmux, switch to pane 0 and start the watch script:"
echo "     bash ~/.tmux/plugins/pane-memo/scripts/watch_display.sh"
echo ""
echo "  3. Switch to other panes and see the information display in pane 0!"
echo ""
echo "For more information, see: https://github.com/masamitsu-konya/pane-memo"
