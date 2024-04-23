#!/bin/bash

sort_log_info() {
    local option="$1"

    case "$option" in
    1)
        # All entries sorted by response code
        awk '{print $0}' "$log_file" | sort -k9
        ;;
    2)
        # All unique IPs found in the entries
        awk '{print $1}' "$log_file" | sort -t '.' -n -k 1 -k 2 -k 3 -k 4 -u
        ;;
    3)
        # All requests with errors (response code - 4xx or 5xx)
        awk '$9 ~ /^[45]/ {print $6, $7, $8}' "$log_file" | sort
        ;;
    4)
        # All unique IPs found among the erroneous requests
        awk '$9 ~ /^[45]/ {print $1}' "$log_file" | sort -t '.' -n -k 1 -k 2 -k 3 -k 4 -u
        ;;
    esac
}


check_args() {
  local valid_options='^\s*[1-4]\s*$'
  [[ "$1" =~ $valid_options ]]
}