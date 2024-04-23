#!/bin/bash

gen_files() {

  dirname_pattern="$1"
  filename_ext_pattern="$2"
  size_str="$3"

  size="${size_str%Mb}"
  filename_pattern="${filename_ext_pattern%.*}"
  extension="${filename_ext_pattern##*.}"
  dirname=$(gen_first_letters "$dirname_pattern")
  last_dirname_letter=${dirname_pattern: -1}
  last_filename_letter=${filename_pattern: -1}

  echo -n "" > trash.txt
  num_directories=$(gen_randint 100)
  gen_directories $num_directories
  for path in "${list_dirs[@]}"
  do
    if check_free_space; then
      date_str=$(date +%d%m%y)
      date_log_str=$(date +"%d.%m.%y %H:%M:%S")
      mkdir "$path/$dirname"_"$date_str"
      echo "$path/$dirname"_"$date_str" >> trash.txt
      echo "$path/$dirname"_"$date_str $date_log_str" >> log.log
      filename=$(gen_first_letters "$filename_pattern")
      num_files=$(gen_randint 10)
      for (( k=0; k < $num_files ; k++ )) 
      do
        if check_free_space; then 
          date_str=$(date +%d%m%y)
          date_log_str=$(date +"%d.%m.%y %H:%M:%S")
          truncate -s "$size"MB "$path/$dirname"_"$date_str/$filename"."$extension"
          echo "$path/$dirname"_"$date_str/$filename"."$extension" "$date_log_str" "$size"Mb >> log.log
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
  local minSize="1G"  
  local curSize=$(df -h / | awk 'NR==2 {print $4}')
  curSize=$(numfmt --from=si "$curSize")
  minSize=$(numfmt --from=si "$minSize")
  [[ $curSize -gt $minSize ]]
}

gen_randint() {
  echo $((1 + $RANDOM % $1))
}

gen_directories() {
  num=$1
  all_path=()
  # Capture the output of find in an array
  while IFS= read -r -d '' file; do
    if ! [[ "$file" =~ /(bin|sbin|sys|snap|Permission|Reports) ]]; then
      all_path+=("$file")
    fi
  done < <(find / -type d -maxdepth 4 -perm /g+w,u+w -writable -print0 2> /dev/null )

  # Randomly shuffle the array and select the first $num items
  list_dirs=($(shuf -e "${all_path[@]}" | head -n "$num"))
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
