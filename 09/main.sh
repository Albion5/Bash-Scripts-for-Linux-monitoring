#!/bin/bash

# Get the current IP address using hostname -I
ip_address=$(hostname -I | awk '{print $1}')

prometheus_config="$(dirname "$0")/prometheus/prometheus.yml"
dash_config="$(dirname "$0")/nginx_metrics.json"


# Update the Prometheus configuration file with the new IP address
sed -i "s/\b[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+:9200\b/$ip_address:9200/" "$prometheus_config"
sed -i "s/\b[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+:9200\b/$ip_address:9200/" "$dash_config"

docker-compose build
docker-compose up -d