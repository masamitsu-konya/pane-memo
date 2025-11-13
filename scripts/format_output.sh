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
    local prompts=""
    local in_prompts=false

    while IFS= read -r line; do
        if [[ $line == PANE_INDEX:* ]]; then
            pane_index="${line#PANE_INDEX:}"
        elif [[ $line == DIRECTORY:* ]]; then
            directory="${line#DIRECTORY:}"
        elif [[ $line == COMMAND:* ]]; then
            command="${line#COMMAND:}"
        elif [[ $line == "PROMPTS_START" ]]; then
            in_prompts=true
        elif [[ $line == "PROMPTS_END" ]]; then
            in_prompts=false
        elif [[ $line == "PROMPTS_NONE" ]]; then
            prompts=""
        elif [[ $in_prompts == true ]]; then
            if [ -z "$prompts" ]; then
                prompts="$line"
            else
                prompts="${prompts}\n${line}"
            fi
        fi
    done

    # Export for use in formatting
    export PANE_INDEX="$pane_index"
    export DIRECTORY="$directory"
    export COMMAND="$command"
    export PROMPTS="$prompts"
}

# Create formatted output
format_display() {
    local box_width=88
    local title="Pane ${PANE_INDEX} Info"

    # Build the display
    echo ""
    echo -e "${BOLD}${BLUE}${TOP_LEFT}$(printf "${HORIZONTAL}%.0s" $(seq 1 $box_width))${TOP_RIGHT}${RESET}"
    echo -e "${BLUE}${VERTICAL}${RESET} ${BOLD}${CYAN}${title}${RESET}"
    echo -e "${BLUE}${VERTICAL}$(printf "${HORIZONTAL}%.0s" $(seq 1 $box_width))${VERTICAL}${RESET}"

    # Directory (shorten if needed)
    local dir_display="${DIRECTORY}"
    if [ ${#dir_display} -gt 74 ]; then
        dir_display="...${dir_display: -71}"
    fi
    local dir_line="${GREEN}Dir:${RESET} ${dir_display}"
    echo -e "${BLUE}${VERTICAL}${RESET} ${dir_line}"

    # Running command
    local cmd_display="${COMMAND}"
    if [ ${#cmd_display} -gt 74 ]; then
        cmd_display="${cmd_display:0:71}..."
    fi
    local cmd_line="${GREEN}Run:${RESET} ${YELLOW}${cmd_display}${RESET}"
    echo -e "${BLUE}${VERTICAL}${RESET} ${cmd_line}"

    # Claude Code prompts (if available)
    if [ -n "$PROMPTS" ]; then
        echo -e "${BLUE}${VERTICAL}$(printf "${HORIZONTAL}%.0s" $(seq 1 $box_width))${VERTICAL}${RESET}"
        echo -e "${BLUE}${VERTICAL}${RESET} ${GREEN}Prompts:${RESET}"

        # Print prompt lines
        echo -e "$PROMPTS" | while IFS= read -r prompt_line; do
            if [ -n "$prompt_line" ]; then
                echo -e "${BLUE}${VERTICAL}${RESET} • $prompt_line"
            fi
        done
    fi

    echo -e "${BOLD}${BLUE}${BOTTOM_LEFT}$(printf "${HORIZONTAL}%.0s" $(seq 1 $box_width))${BOTTOM_RIGHT}${RESET}"
    echo ""
}

# Main execution
parse_input
format_display
