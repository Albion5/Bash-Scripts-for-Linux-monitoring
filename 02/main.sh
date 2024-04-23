#!/bin/bash

source $(dirname "$0")/output.sh
echo  "" > log.log
# Record the start time
start_time=$(date -d "-1 second" +"%Y-%m-%d %H:%M:%S")

if [ $# -ne 3 ]; then
  echo "Error: Wrong number of command-line arguments. The script is run with 3 parameters."
  echo "Usage: $0 <param1> <param2> <param3>"
  echo "       param1 - A list of English alphabet letters used in folder names (no more than 7 characters)"
  echo "       param2 - The list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension)"
  echo "       param3 - File size (in Megabytes, but not more than 100)"

elif ! check_args "$1" "$2" "$3"; then
  echo "Error: Wrong options."
else
    gen_files "$1" "$2" "$3"

    echo "Ok."
fi

# Record the end time
end_time=$(date -d "+1 second" +"%Y-%m-%d %H:%M:%S")


# Calculate the total running time (in seconds)
start_timestamp=$(date -d "$start_time" +"%s")
end_timestamp=$(date -d "$end_time" +"%s")
total_seconds=$((end_timestamp - start_timestamp))

# Format the total running time
hours=$((total_seconds / 3600))
minutes=$(( (total_seconds % 3600) / 60))
seconds=$((total_seconds % 60))

# Log the start time, end time, and total running time
echo "Script started at: $start_time"
echo "Script ended at: $end_time"
echo "Total running time: $hours hours, $minutes minutes, $seconds seconds" 

# Append the log to a file
echo "Script started at: $start_time" >> log.log
echo "Script ended at: $end_time" >> log.log
echo "Total running time: $hours hours, $minutes minutes, $seconds seconds" >> log.log

# find / -type d -newermt "2023-10-31 14:33:49" ! -newermt "2023-10-31 14:34:10" 2>/dev/null | grep -E "/[A-Za-z]{4,}_[0-9]{6}$"