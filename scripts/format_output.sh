#!/usr/bin/env bash

# Format pane information for display
# Reads structured input from get_pane_info.sh and creates a nice display

# ANSI color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

# Box drawing characters
TOP_LEFT="┌"
TOP_RIGHT="┐"
BOTTOM_LEFT="└"
BOTTOM_RIGHT="┘"
HORIZONTAL="─"
VERTICAL="│"

# Parse input data
parse_input() {
    local pane_index=""
    local directory=""
    local command=""

    while IFS= read -r line; do
        if [[ $line == PANE_INDEX:* ]]; then
            pane_index="${line#PANE_INDEX:}"
        elif [[ $line == DIRECTORY:* ]]; then
            directory="${line#DIRECTORY:}"
        elif [[ $line == COMMAND:* ]]; then
            command="${line#COMMAND:}"
        fi
    done

    # Export for use in formatting
    export PANE_INDEX="$pane_index"
    export DIRECTORY="$directory"
    export COMMAND="$command"
}

# Create formatted output
format_display() {
    local width=60
    local title="Pane ${PANE_INDEX} Information"

    # Build the display
    echo ""
    echo -e "${BOLD}${BLUE}${TOP_LEFT}$(printf "${HORIZONTAL}%.0s" {1..58})${TOP_RIGHT}${RESET}"
    echo -e "${BLUE}${VERTICAL}${RESET} ${BOLD}${CYAN}${title}${RESET}$(printf ' %.0s' $(seq 1 $((width - ${#title} - 2))))${BLUE}${VERTICAL}${RESET}"
    echo -e "${BLUE}${VERTICAL}$(printf "${HORIZONTAL}%.0s" {1..58})${VERTICAL}${RESET}"

    # Directory
    echo -e "${BLUE}${VERTICAL}${RESET} ${GREEN}Directory:${RESET} ${DIRECTORY}$(printf ' %.0s' $(seq 1 $((width - ${#DIRECTORY} - 13))))${BLUE}${VERTICAL}${RESET}"

    # Running command
    echo -e "${BLUE}${VERTICAL}${RESET} ${GREEN}Running:${RESET}   ${YELLOW}${COMMAND}${RESET}$(printf ' %.0s' $(seq 1 $((width - ${#COMMAND} - 13))))${BLUE}${VERTICAL}${RESET}"

    echo -e "${BOLD}${BLUE}${BOTTOM_LEFT}$(printf "${HORIZONTAL}%.0s" {1..58})${BOTTOM_RIGHT}${RESET}"
    echo ""
}

# Main execution
parse_input
format_display
