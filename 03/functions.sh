#!/bin/bash

# Function to delete files and directories by creation date and time
delete_by_datetime() {
    local start_datetime="$1"
    local end_datetime="$2"
    pattern="/[A-Za-z]{4,}_[0-9]{6}$"
    echo  "" > trash.txt
    find / -type d -newermt "$start_datetime" ! -newermt "$end_datetime" 2> /dev/null | grep -E "$pattern" > trash.txt
    delete_trash trash.txt
    rm trash.txt
    }

# Function to delete files and directories by name mask
delete_by_mask() {
    local mask="$1"
    echo  "" > trash.txt
    find / -type d 2> /dev/null | grep -E "$mask$" > trash.txt
    delete_trash trash.txt
    rm trash.txt
}

is_valid_mask() {
    local mask_pattern="[A-Za-z]{4,}_[0-9]{6}$"
    [[ "$1" =~ $mask_pattern ]]
}

is_valid_date() {
    local date_pattern="[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$"
    [[ "$1" =~ $date_pattern ]]
}
# Function to delete files and directories by log file
delete_by_logfile() {
    local logfile="$1"
    pattern="/[A-Za-z]{4,}_[0-9]{6} [0-9]{2}.[0-9]{2}.[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"
    echo  "" > trash.txt
    grep -E "$pattern" "$logfile" | awk '{print $1}' > trash.txt
    delete_trash trash.txt
    rm trash.txt
}

delete_trash() {
  log_file="$1"
  while IFS= read -r directory; do
      if [ -e $directory ]; then
          if [ -d $directory ]; then
              rm -r "$directory"
              echo "Deleted directory: $directory"
          fi
      else
          echo "directory does not exist: $directory"
      fi
  done < "$log_file"

  echo "Deletion process completed."
}