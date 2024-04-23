#!/bin/sh

nginx
OUTPUT_FILE="/data/www/metrics"
while
    true
do
    bash /data/gen_metrics.sh > "$OUTPUT_FILE"
    sleep 3
done