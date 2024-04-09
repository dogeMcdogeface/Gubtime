#!/bin/bash

# Parse YAML content from the secret variable
urls_yaml="$1"

# Print the string passed as input
echo "Input string: $2"

# Loop through each URL, curl, and print the status code
while IFS= read -r line; do
    alias=$(echo "$line" | yq eval '.alias' -)
    url=$(echo "$line" | yq eval '.url' -)
    
    echo "Curling URL: $alias"
    status_code=$(curl -I -s "$url" -o /dev/null -w "%{http_code}")
    echo "Status code for $alias: $status_code"
done <<< $(echo "$urls_yaml" | yq eval '.urls[]' -)
