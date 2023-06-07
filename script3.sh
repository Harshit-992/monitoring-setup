#!/bin/bash

# Display GUI for input collection
name=$(zenity --entry --title="Enter Name" --text="Enter the name:")

# Variables to store URL values
cdurl=""
ifxurl=""

# Display checkboxes for URL selection
selected_urls=$(zenity --list --title="Select URLs" --text="Select one or more data sources:" \
    --column="" --column="Data Source" --checklist FALSE "CloudWatch" FALSE "InfluxDB")

# Check if both checkboxes are selected
if [[ $selected_urls == *"CloudWatch"* ]] && [[ $selected_urls == *"InfluxDB"* ]]; then
    # Prompt for CloudWatch URL
    cdurl=$(zenity --entry --title="Enter CloudWatch URL" --text="Enter the CloudWatch URL:")
    # Prompt for InfluxDB URL
    ifxurl=$(zenity --entry --title="Enter InfluxDB URL" --text="Enter the InfluxDB URL:")
elif [[ $selected_urls == *"CloudWatch"* ]]; then
    # Only CloudWatch checkbox is selected, prompt for CloudWatch URL
    cdurl=$(zenity --entry --title="Enter CloudWatch URL" --text="Enter the CloudWatch URL:")
elif [[ $selected_urls == *"InfluxDB"* ]]; then
    # Only InfluxDB checkbox is selected, prompt for InfluxDB URL
    ifxurl=$(zenity --entry --title="Enter InfluxDB URL" --text="Enter the InfluxDB URL:")
fi

# Store values in keyvalue.txt
echo "name=$name" > keyvalue.txt
echo "cdurl=$cdurl" >> keyvalue.txt
echo "ifxurl=$ifxurl" >> keyvalue.txt

# Run helm install command with provided values
helm_install_command="helm install"

if [[ -n "$cdurl" ]]; then
    helm_install_command+=" --set \"grafana.sidecar.datasources.cloudwatch.url=$cdurl\""
fi

if [[ -n "$ifxurl" ]]; then
    helm_install_command+=" --set \"grafana.sidecar.datasources.influxdb.url=$ifxurl\""
fi

helm_install_command+=" \"$name\" ./"

eval "$helm_install_command"
