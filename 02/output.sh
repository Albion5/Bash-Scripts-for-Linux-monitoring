#!/bin/bash
source $(dirname "$0")/functions.sh

check_args() {
  param1="$1"
  param2="$2"
  param3="$3"

  local result=1
  if ! is_valid_dirname "$param1"; then
    echo "Error with the first option. $param1 is not a valid dirname"
  elif ! is_valid_filename "$param2"; then
    echo "Error with the second option. $param2 is not a valid filename"
 elif ! is_valid_file_size "$param3"; then
    echo "Error with the third option. $param3 is not a valid file size"
  else 
    result=0
  fi
  return $result 
}


is_valid_dirname() {
  local dirname_pattern='^\s*[A-Za-z]{1,7}\s*$'
  [[ "$1" =~ $dirname_pattern ]]
}

is_valid_filename() {
  local filename_pattern='^\s*[A-Za-z]{1,7}\.[A-Za-z]{1,3}\s*$'
  [[ "$1" =~ $filename_pattern ]]
}

is_valid_file_size() {
  local number_pattern='^\s*[+]?[0-9]+Mb\s*$'
  local size="${1%Mb}"
  [[ "$1" =~ $number_pattern ]] && [[ "$size" -le 100 ]]
}