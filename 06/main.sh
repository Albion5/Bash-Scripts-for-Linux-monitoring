#!/bin/bash

log_dir="$(dirname "$0")/../nginx_logs"
log_file_1="${log_dir}/access_log_1.log"
log_file_2="${log_dir}/access_log_2.log"
log_file_3="${log_dir}/access_log_3.log"
info_page="info.html"
rm -f "$info_page"
goaccess -f "$log_file_1" "$log_file_2" "$log_file_3" --log-format=COMBINED -a -o "$info_page"
