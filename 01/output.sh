#!/bin/bash
source $(dirname "$0")/functions.sh

check_args() {
  param1="$1"
  param2="$2"
  param3="$3"
  param4="$4"
  param5="$5"
  param6="$6"
  local result=1
  if ! is_valid_path "$param1"; then
    echo "Error with the first option. $param1 is not an absolute path"
  elif ! is_valid_num "$param2"; then
    echo "Error with the second option. $param2 is not a number"

  elif ! is_valid_dirname "$param3"; then
    echo "Error with the third option. $param3 is not a valid dirname"

  elif ! is_valid_num "$param4"; then
    echo "Error with the fourth option. $param4 is not a number"
  elif ! is_valid_filename "$param5"; then
    echo "Error with the fifth option. $param5 is not a valid filename"
  elif ! is_valid_file_size "$param6"; then
    echo "Error with the sixth option. $param6 is not a valid file size"
  else 
    result=0
  fi
  return $result 
}

is_valid_path() {
 test -d "$1"
}

is_valid_num() {
  local number_pattern='^\s*[+]?[0-9]+\s*$'
  [[ "$1" =~ $number_pattern ]]

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
  local number_pattern='^\s*[+]?[0-9]+kb\s*$'
  local size="${1%kb}"
  [[ "$1" =~ $number_pattern ]] && [[ "$size" -le 100 ]]
}