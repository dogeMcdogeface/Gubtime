#!/bin/bash

# Print the string passed as input
echo "Input string: $1"

# Parse the YAML content from the secret variable and iterate over each URL
echo "${2}" | jq -r '.urls[] | "Curling URL: \(.url)\nAlias: \(.alias)\nDescription: \(.description)\nStatus code: " + (if system("curl -s -o /dev/null -w \"%{http_code}\" \(.url)") | tonumber == null then "Failed to curl" else tostring end) + "\n"'

