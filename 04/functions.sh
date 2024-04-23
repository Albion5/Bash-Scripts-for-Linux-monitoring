#!/bin/bash


source $(dirname "$0")/arrays.sh


gen_log_files() {

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Generate 5 log files
    for i in {1..5}; do
        log_file="$output_dir/access_log_$i.log"
        touch "$log_file"

        log_day="$(date -d "$((5-$i)) days ago" +"%d/%b/%Y")"
        # Generate a random number of entries between 100 and 1000
        num_entries=$((100 + RANDOM % 901))

        for ((j = 1; j <= num_entries; j++)); do
            # Generate random data for each log entry
            random_ip="$(gen_random_ip)"
            response_code=$(get_random_item "${response_codes[@]}")
            http_method=$(get_random_item "${http_methods[@]}")
            user_agent=$(get_random_item "${user_agents[@]}")
            random_url=$(gen_random_url)
            date_time="$(gen_date_str $j)"
            bytes_sent="$(gen_bytes_sent)"

            # Append the log entry to the log file
            echo "$random_ip - - [${log_day}:$date_time] \"$http_method $random_url HTTP/1.1\" $response_code $bytes_sent - \"$user_agent\"" >> "$log_file"
        done
    done

    echo "Nginx log files have been generated in the $output_dir directory."
}



get_random_item() {
  local array=("$@") 
  local array_length="${#array[@]}"
  local random_item=$(shuf -e "${array[@]}" -n 1)
  echo "$random_item"
}


gen_random_url() {
  local protocol="$(get_random_item "${protocols[@]}")"
  local domain="$(get_random_item "${domains[@]}")"
  local path="$(get_random_item "${paths[@]}")"
  local query="$(get_random_item "${queries[@]}")"
  local url="$protocol://$domain$path?$query"

  echo "$url"
}


gen_random_num() {
    local num_1=$((RANDOM % $1))
    echo $num_1
}    

gen_random_ip() {
    local num1="$(gen_random_num 256)"
    local num2="$(gen_random_num 256)"
    local num3="$(gen_random_num 256)"
    local num4="$(gen_random_num 256)"
    echo "$num1.$num2.$num3.$num4"
}

gen_date_str (){
    local offset=$1
    local date_str="$(date -d "+${offset} minutes" "+%H:%M:%S %z")"
    echo "$date_str"
}

gen_bytes_sent (){
    local num_bytes=$(gen_random_num 50000)
    echo "$num_bytes"
}