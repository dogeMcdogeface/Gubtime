#!/bin/bash

# Define the YAML string
yaml_string="urls:
  - Entry: 
    url: https://example.com
    alias: Example
    description: Example website
  - Entry: 
    url: https://google.com
    alias: Example
    description: Example website
  - Entry: 
    url: https://nonexistentwebsite.noway
    alias: Another Example
    description: Another example website"

# Print timestamp
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%NZ")
echo "timestamp: $timestamp"

# Parse YAML string and check responses
while IFS= read -r line; do
    if [[ "$line" =~ ^\ +url:\ (.*) ]]; then
        url="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +alias:\ (.*) ]]; then
        alias="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^\ +description:\ (.*) ]]; then
        description="${BASH_REMATCH[1]}"
        http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        echo "- alias: $alias"
        echo "  description: $description"
        #echo "  url: $url"
        echo "  response: $http_status"
    fi
done <<< "$yaml_string"
