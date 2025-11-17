#!/usr/bin/env bash

# Helper script to start watch_display.sh in the target pane
# Called by tmux hooks

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGIN_DIR="$(dirname "$CURRENT_DIR")"

# Get configuration
get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

TARGET_PANE=$(get_tmux_option "@pane-memo-target-pane" "0")

# Check if target pane exists
if ! tmux list-panes -F "#{pane_index}" 2>/dev/null | grep -q "^${TARGET_PANE}$"; then
    exit 0
fi

# Check if watch_display.sh is already running
target_pane_cmd=$(tmux list-panes -F "#{pane_index}:#{pane_current_command}" 2>/dev/null | grep "^${TARGET_PANE}:" | cut -d: -f2)

# Only start if not already running bash (which indicates watch_display is running)
if [[ "$target_pane_cmd" == "bash" ]]; then
    # Already running
    exit 0
fi

# Clear the pane and start the watch script
tmux send-keys -t :.${TARGET_PANE} C-c C-l
sleep 0.1
tmux send-keys -t :.${TARGET_PANE} "bash '$PLUGIN_DIR/scripts/watch_display.sh'" Enter

exit 0
