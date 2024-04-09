#!/bin/bash

# Define the YAML string
yaml_string="$1"

echo "--------------------------------------------------------------------------"
echo "$1"
echo "--------------------------------------------------------------------------"
echo "$yaml_string"
echo "--------------------------------------------------------------------------"

# Initialize string to hold output
output=""

# Print timestamp
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%NZ")
output+="timestamp: $timestamp"$'\n'

# Parse YAML string and check responses
while IFS= read -r line; do
    if [[ "$line" =~ ^\ +url:\ (.*) ]]; then
        url="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +alias:\ (.*) ]]; then
        alias="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +description:\ (.*) ]]; then
        description="${BASH_REMATCH[1]}"
        http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        output+="- alias: $alias"$'\n'
        output+="  description: $description"$'\n'
        output+="  response: $http_status"$'\n'
    fi
done <<< "$yaml_string"

# Print collected output
echo "$output"
