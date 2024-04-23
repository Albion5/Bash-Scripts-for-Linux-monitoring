#!/bin/bash
source $(dirname "$0")/functions.sh
delete_trash "trash.txt"
rm -rf log.log trash.txt