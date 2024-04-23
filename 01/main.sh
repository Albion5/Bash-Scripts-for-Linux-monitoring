#!/bin/bash

source $(dirname "$0")/output.sh

if [ $# -ne 6 ]; then
  echo "Error: Wrong number of command-line arguments. The script is run with 6 parameters."
  echo "Usage: $0 <param1> <param2> <param3> <param4> <param5> <param6>"
  echo "       param1 - The absolute path"
  echo "       param2 - The number of subfolders"
  echo "       param3 - A list of English alphabet letters used in folder names (no more than 7 characters)"
  echo "       param4 - The number of files in each created folder"
  echo "       param5 - The list of English alphabet letters used in the file name and extension (no more than 7 characters for the name, no more than 3 characters for the extension)"
  echo "       param6 - File size (in kilobytes, but not more than 100)"

elif ! check_args "$1" "$2" "$3" "$4" "$5" "$6"; then
  echo "Error: Wrong options."
else
  gen_files "$1" "$2" "$3" "$4" "$5" "$6"
  echo "Ok."
fi
