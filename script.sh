#!/bin/bash

# Parse YAML content from the secret variable
urls_yaml="$1"
aliases=$(echo "$urls_yaml" | yq eval '.urls[].alias' -)
descriptions=$(echo "$urls_yaml" | yq eval '.urls[].description' -)
urls=$(echo "$urls_yaml" | yq eval '.urls[].url' -)

# Print the string passed as input
echo "Input string: $2"

# Loop through each URL, curl, and print the status code
index=0
for url in $urls; do
    alias=$(echo "$aliases" | sed -n "${index + 1}p")
    description=$(echo "$descriptions" | sed -n "${index + 1}p")
    echo "Curling URL Alias: $alias - Description: $description"
    status_code=$(curl -I -s "$url" -o /dev/null -w "%{http_code}")
    echo "Status code for $alias: $status_code"
    ((index++))
done
