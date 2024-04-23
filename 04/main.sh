#!/bin/bash

source $(dirname "$0")/functions.sh

if [ $# -ne 0 ]; then
  echo "Error: Wrong number of command-line arguments. The script is run without parameters."
else
  gen_log_files
  echo "Ok"
fi