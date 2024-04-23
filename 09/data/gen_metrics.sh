#!/bin/bash

output_metric() {
  local metric_data="$1"
  [ -n "$metric_data" ] && echo -e "$metric_data"
}

output_metric_with_comment() {
  local help_comment="$1"
  local type_comment="$2"
  local metric_data="$3"
  [ -n "$metric_data" ] && echo -e "$help_comment\n$type_comment\n$metric_data"
}

get_memory_metric() {
  local metric_name="$1"
  local field_name="$2"
  local unit=1024
  local type_comment="# TYPE $metric_name gauge"
  local result=$(grep -i -e "$field_name" /host/proc/meminfo | awk -v unit="$unit" '{printf "%.10e", $2 * unit}')
  field_name=$(echo "$field_name" | tr -cd '[:alnum:]')
  local help_comment="# HELP $metric_name Memory information field ${field_name}_bytes."
  output_metric_with_comment "$help_comment" "$type_comment" "$metric_name $result"
}

get_filesystem_metric() {
  local metric_name="$1"
  local mount_point="$2"
  local option="$3"

  local result=$(df -P -B1 "$mount_point" | awk -v option="$option" 'NR==2 {printf "%.10e", $option}')
  # Extract device, fstype, and mount point
  local device=$(df -P "$mount_point" | awk 'NR==2 {print $1}')
  local fstype=$(awk -v mount_point="$mount_point" '$2 == mount_point {print $3}' /host/etc/mtab)
  mount_point=$(echo "$mount_point" | sed 's|^/host/|/|; s|^/host$|/|')
  echo "${metric_name}{device=\"$device\", fstype=\"$fstype\", mountpoint=\"$mount_point\"} $result"
}

get_network_metric() {
  local metric_name="$1"
  local device="$2"
  local option="$3"
  local result=$(cat /host/proc/net/dev | grep "${device}:" | awk -v option="$option" '{if ($option == 0) print $option; else printf "%.6e", $option}')
  output_metric "$metric_name{device=\"$device\"} $result"
}

get_disk_metric() {
  local metric_name="$1"
  local device="$2"
  local option="$3"
  local unit="$4"
  local format="$5"
  local result=$(cat /host/proc/diskstats | grep "${device} " | awk -v option="$option" -v unit="$unit" -v format="$format" '{if ($option == 0) print $option; else printf format, $option * unit}')
  output_metric "$metric_name{device=\"$device\"} $result"
}

get_cpu_metric() {
  local metric_name="$1"
  local cpu_num="$2"
  local field_name="$3"

  local field_number
  case "$field_name" in
    "user") field_number=2 ;;
    "nice") field_number=3 ;;
    "system") field_number=4 ;;
    "idle") field_number=5 ;;
    "iowait") field_number=6 ;;
    "irq") field_number=7 ;;
    "softirq") field_number=8 ;;
    "steal") field_number=9 ;;
    *) field_number=5 ;;
  esac

  # Get CPU metric for the specified field
  local result=$(grep "cpu$cpu_num" /host/proc/stat | awk -v field_number="$field_number" '{printf "%.2f", $field_number / 100}')

  # Output the metric in Prometheus format
  output_metric "$metric_name{cpu=\"$cpu_num\",mode=\"$field_name\"} $result"
}

# Memory metrics
get_memory_metric "node_memory_MemTotal_bytes" "MemTotal"
get_memory_metric "node_memory_MemAvailable_bytes" "MemAvailable" 
get_memory_metric "node_memory_Buffers_bytes" "Buffers"
get_memory_metric "node_memory_Cached_bytes" "^Cached"
get_memory_metric "node_memory_SwapCached_bytes" "SwapCached"
get_memory_metric "node_memory_MemFree_bytes" "MemFree"
get_memory_metric "node_memory_Slab_bytes" "Slab"
get_memory_metric "node_memory_PageTables_bytes" "^PageTables"

# Filesystem metrics
mount_points=($(df -hP 2>/dev/null | grep " /host" | grep -v "/dev/l" | grep -v "overlay" | awk '{print $6}'))

cat <<EOF
# HELP node_filesystem_size_bytes Filesystem size in bytes.
# TYPE node_filesystem_size_bytes gauge
EOF
for mount_point in "${mount_points[@]}"; do
  get_filesystem_metric "node_filesystem_size_bytes" "$mount_point" 2
done
cat <<EOF
# HELP node_filesystem_avail_bytes Filesystem space available to non-root users in bytes.
# TYPE node_filesystem_avail_bytes gauge
EOF
for mount_point in "${mount_points[@]}"; do
  get_filesystem_metric "node_filesystem_avail_bytes" "$mount_point" 4
done

# CPU metrics
cat <<EOF
# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
# TYPE node_cpu_seconds_total counter
EOF
CPU_NUM=0
while [[ -n "$(grep "cpu$CPU_NUM" /host/proc/stat)" ]]; do
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "user"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "nice"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "system"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "idle"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "iowait"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "irq"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "softirq"
  get_cpu_metric "node_cpu_seconds_total" "$CPU_NUM" "steal"

  let "CPU_NUM++"
done
cat <<EOF
# HELP node_network_receive_bytes_total Network device statistic receive_bytes.
# TYPE node_network_receive_bytes_total counter
EOF

# Network metrics
network_devices=($(cat /host/proc/net/dev | awk ' NR > 2 {print $1}' | cut -d ':' -f 1))

for device in "${network_devices[@]}"; do
  get_network_metric "node_network_receive_bytes_total" "$device" 2
done
cat <<EOF
# HELP node_network_transmit_bytes_total Network device statistic receive_bytes.
# TYPE node_network_transmit_bytes_total counter
EOF
for device in "${network_devices[@]}"; do
    get_network_metric "node_network_transmit_bytes_total" "$device" 10
done

# Disk metrics
disk_devices=($(ls /host/sys/class/block/ | grep -E '^(sd|nvme)'))
cat <<EOF
# HELP node_disk_read_bytes_total The total number of bytes read successfully.
# TYPE node_disk_read_bytes_total counter
EOF
for device in "${disk_devices[@]}"; do
    get_disk_metric "node_disk_read_bytes_total" "$device" 6 512 "%.10e"
done

cat <<EOF
# HELP node_disk_written_bytes_total The total number of bytes written successfully.
# TYPE node_disk_written_bytes_total counter
EOF
for device in "${disk_devices[@]}"; do
    get_disk_metric "node_disk_written_bytes_total " "$device" 10 512 "%.10e"
done

cat <<EOF
# HELP node_disk_io_time_seconds_total Total seconds spent doing I/Os.
# TYPE node_disk_io_time_seconds_total counter
EOF
for device in "${disk_devices[@]}"; do
    get_disk_metric "node_disk_io_time_seconds_total " "$device" 13 0.001 "%.3f"
done

cat <<EOF
# HELP node_disk_writes_completed_total The total number of writes completed successfully.
# TYPE node_disk_writes_completed_total counter
EOF
for device in "${disk_devices[@]}"; do
    get_disk_metric "node_disk_writes_completed_total " "$device" 8 1 "%.6e"
done

cat <<EOF
# HELP node_disk_reads_completed_total The total number of reads completed successfully.
# TYPE node_disk_reads_completed_total counter
EOF
for device in "${disk_devices[@]}"; do
    get_disk_metric "node_disk_reads_completed_total " "$device" 4 1 "%.f"
done