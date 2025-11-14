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
SHOW_PROMPTS=$(get_tmux_option "@pane-memo-show-prompts" "off")

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
# Export SHOW_PROMPTS so get_pane_info.sh can check it
export PANE_MEMO_SHOW_PROMPTS="$SHOW_PROMPTS"
pane_info=$("$CURRENT_DIR/get_pane_info.sh" "$PANE_INDEX" "$CURRENT_PATH" "$CURRENT_COMMAND" "$PANE_PID" "$PANE_TTY")

# Format the output
formatted_output=$(echo "$pane_info" | "$CURRENT_DIR/format_output.sh")

# Write to fixed file that the watch script is monitoring
# The watch script should be running in the target pane
# Use atomic write (temp file + mv) to avoid race conditions
DISPLAY_FILE="/tmp/pane-memo-display"
TEMP_FILE="/tmp/pane-memo-display.$$"

# Set restrictive permissions and write atomically
(
    umask 077
    echo "$formatted_output" > "$TEMP_FILE"
    mv -f "$TEMP_FILE" "$DISPLAY_FILE"
)

exit 0
