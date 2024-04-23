#!/bin/bash

gen_files() {
  path="$1"
  num_directories="$2"
  dirname_pattern="$3"
  num_files="$4"
  filename_ext_pattern="$5"
  size_str="$6"
  size="${size_str%kb}"
  filename_pattern="${filename_ext_pattern%.*}"
  extension="${filename_ext_pattern##*.}"
  dirname=$(gen_first_letters "$dirname_pattern")
  last_dirname_letter=${dirname_pattern: -1}
  last_filename_letter=${filename_pattern: -1}
  echo -n "" > log.log
  for (( i=0; i < $num_directories; i++ )) 
  do
    if check_free_space; then
      date_str=$(date +%d%m%y)
      date_log_str=$(date +"%d-%m-%Y %H:%M:%S")
      mkdir "$path/$dirname"_"$date_str"
      echo "$path/$dirname"_"$date_log_str" >> log.log
      filename=$(gen_first_letters "$filename_pattern")
      for (( k=0; k < $num_files; k++ )) 
      do
        if check_free_space; then
          date_str=$(date +%d%m%y)
          date_log_str=$(date +"%d-%m-%Y %H:%M:%S")
          truncate -s "$size"KB "$path/$dirname"_"$date_str/$filename"."$extension"
          echo "$path/$dirname"_"$date_str/$filename"."$extension" "$date_log_str" "$size"KB >> log.log
          filename+=$last_filename_letter
        fi
      done
      dirname+=$last_dirname_letter
    fi
  done
}

gen_first_letters() {
  local pattern="$1"
  local len=${#pattern}
  local letter=${pattern:0:1}
  local name=""
  for (( i=0; i < 4; i++ ))
  do
    name+=$letter;
  done
  for (( i=1; i < $len; i++ ))
  do
    letter=${pattern:i:1}
      name+=$letter;
  done
  echo $name
}

check_free_space() {
  local minSize=1048576 
  local curSize=$(df -k / | awk 'NR==2 {print $4}')
  [[ $curSize -gt $minSize ]]
}

get_absolute_path() {
  local dir="$1"
  local absolute_path="$(pwd)/$dir"
  echo "$absolute_path"
}