#!/bin/bash

# Print the string passed as input
echo "Input string: $1"

# Parse YAML content and loop through each URL
while IFS= read -r line; do
    # Extract alias and description using awk
    alias=$(echo "$line" | awk '/alias:/ {print $2}')
    description=$(echo "$line" | awk '/description:/ {print $2}')
    url=$(echo "$line" | awk '/url:/ {print $2}')

    # Print alias and description
    echo "Alias: $alias"
    echo "Description: $description"

    # Curl URL and print the status code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "Status code for $url: $status_code"
done <<< "$(echo "$2" | sed 's/^/\ \ /')"

