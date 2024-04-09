#!/bin/bash

# Parse YAML content from the secret variable
urls_yaml="$1"
urls=$(echo "$urls_yaml" | yq eval '.urls[]' -)

# Print the string passed as input
echo "Input string: $2"

# Loop through each URL, alias, and description, curl, and print the status code
for entry in $urls; do
    url=$(echo "$entry" | yq eval '.url' -)
    alias=$(echo "$entry" | yq eval '.alias' -)
    description=$(echo "$entry" | yq eval '.description' -)
    
    echo "Curling URL: $url"
    echo "Alias: $alias"
    echo "Description: $description"
    
    status_code=$(curl -I -s "$url" -o /dev/null -w "%{http_code}")
    echo "Status code for $url: $status_code"
done
