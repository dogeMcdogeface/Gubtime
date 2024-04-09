#!/bin/bash

# Parse YAML content from the secret variable
urls_yaml="$1"
urls=$(echo "$urls_yaml" | yq eval '.urls[]' -)

# Print the string passed as input
echo "Input string: $2"

# Loop through each URL, curl, and print the status code
for url in $urls; do
    echo "Curling URL: $url"
    status_code=$(curl -I -s "$url" -o /dev/null -w "%{http_code}")
    echo "Status code for $url: $status_code"
done
