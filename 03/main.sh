#!/bin/bash
source $(dirname "$0")/functions.sh

if [ $# -ne 1 ]; then
  echo "Error: Wrong number of command-line arguments. The script is run with 1 parameter."
  echo "Usage: $0 [1|2|3]"
  echo "       1 - Clear the system by log file"
  echo "       2 - Clear the system by creation date and time"
  echo "       3 - Clear the system by name mask (i.e. characters, underlining and date)"

else

    cleanup_method="$1"

    if [ "$cleanup_method" = "1" ]; then
        # Cleanup by log file
        echo "Cleaning by log file..."
        read -p "Enter log file name: " logfile
        if [ -e "$logfile" ]; then
            delete_by_logfile "$logfile"
            echo "Cleanup by log file completed."
        else
            echo "Error with log file. Try running the script again"
        fi

    elif [ "$cleanup_method" = "2" ]; then
        # Cleanup by creation date and time
        echo "Cleaning by creation date and time..."
        read -p "Enter start datetime (YYYY-MM-DD HH:MM): " start_datetime
        read -p "Enter end datetime (YYYY-MM-DD HH:MM): " end_datetime

        if is_valid_date "$start_datetime"  && is_valid_date "$end_datetime" ; then 
            delete_by_datetime "$start_datetime" "$end_datetime"
            echo "Cleanup by creation date and time completed."
        else
            echo "Not valid datetime. Try running the script again."
        fi

    elif [ "$cleanup_method" = "3" ]; then
        # Cleanup by name mask
        echo "Cleaning by name mask..."
        read -p "Enter name mask (e.g., 'name_date'): " name_mask
        if is_valid_mask "$name_mask"; then 
            delete_by_mask "$name_mask"
            echo "Cleanup by name mask completed."
        else
            echo "Not valid mask. Try running the script again."
        fi

    else
        echo "Invalid cleanup method. Please use 1, 2, or 3."
    fi

    echo "Ok."
fi

