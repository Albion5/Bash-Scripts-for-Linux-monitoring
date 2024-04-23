#!/bin/bash

# Get the current IP address using hostname -I
ip_address=$(hostname -I | awk '{print $1}')

prometheus_config="$(dirname "$0")/prometheus/prometheus.yml"
dash_config="$(dirname "$0")/dash.json"


# Update the Prometheus configuration file with the new IP address
sed -i "s/\b[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+:9100\b/$ip_address:9100/" "$prometheus_config"
sed -i "s/\b[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+:9100\b/$ip_address:9100/" "$dash_config"

docker-compose up -d