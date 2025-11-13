#!/usr/bin/env bash

# Update pane 0 with current pane information
# Called by tmux hooks when pane focus changes

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get arguments passed from tmux hook
PANE_INDEX=$1
CURRENT_PATH=$2
CURRENT_COMMAND=$3
PANE_PID=$4
PANE_TTY=$5

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

# Don't update if we're focusing the target pane itself
if [ "$PANE_INDEX" = "$TARGET_PANE" ]; then
    exit 0
fi

# Check if target pane exists
if ! tmux list-panes -F "#{pane_index}" | grep -q "^${TARGET_PANE}$"; then
    # Target pane doesn't exist, skip
    exit 0
fi

# Get pane information
pane_info=$("$CURRENT_DIR/get_pane_info.sh" "$PANE_INDEX" "$CURRENT_PATH" "$CURRENT_COMMAND" "$PANE_PID" "$PANE_TTY")

# Format the output
formatted_output=$(echo "$pane_info" | "$CURRENT_DIR/format_output.sh")

# Create a temporary file with the formatted output
temp_file="/tmp/pane-memo-display-$$"
echo "$formatted_output" > "$temp_file"

# Clear pane 0 and display the information
# We use send-keys with clear and cat to update the display
tmux send-keys -t "$TARGET_PANE" C-c  # Cancel any running command
tmux send-keys -t "$TARGET_PANE" C-l  # Clear screen
tmux send-keys -t "$TARGET_PANE" "cat '$temp_file'" Enter

# Clean up temp file after a short delay (allow time for display)
(sleep 1 && rm -f "$temp_file") &

exit 0
