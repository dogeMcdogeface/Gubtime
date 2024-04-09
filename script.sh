#!/bin/bash

# Accept YAML string as argument
yaml_string=$1

# Initialize string to hold output
output="- entry:"$'\n'

# Print timestamp
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%NZ")
output+="  - timestamp: $timestamp"$'\n'

# Parse YAML string and check responses
while IFS= read -r line; do
    if [[ "$line" =~ ^\ +url:\ +([^[:space:]]*) ]]; then
        url="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +alias:\ (.*) ]]; then
        alias="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +description:\ (.*) ]]; then
        description="${BASH_REMATCH[1]}"
        start_time=$(date +%s.%N)  # Capture start time
        http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        end_time=$(date +%s.%N)    # Capture end time
        duration=$(echo "$end_time - $start_time" | bc)  # Calculate duration
        output+="  - alias: $alias"$'\n'
        output+="    description: $description"$'\n'
        output+="    response: $http_status"$'\n'
        output+="    time: $duration"$'\n'  # Add response time to output
        #output+="  url: $url"$'\n'
    fi
done <<< "$yaml_string"

# Print collected output
echo "$output"
