#!/bin/bash

source $(dirname "$0")/functions.sh

log_file="$(dirname "$0")/../nginx_logs/access_log_1.log"


if [ $# -ne 1 ]; then
  echo "Error: Wrong number of command-line arguments. The script is run with 1 parameter."
  echo "Usage: $0 [1|2|3|4]"
  echo "       1 - Output all entries sorted by response code"
  echo "       2 - Output all unique IPs found in the entries"
  echo "       3 - Output all requests with errors (response code - 4xx or 5xxx)"
  echo "       4 - Output all unique IPs found among the erroneous requests"

elif ! check_args "$1"; then
  echo "Error: Wrong option."
elif [ ! -e "$log_file" ]; then
  echo "Error: $log_file doesn't exist."
else
    sort_log_info "$1"
    echo "Ok."
fi
