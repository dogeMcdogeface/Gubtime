#!/bin/bash

# Print the string passed as input
echo "Input string: $1"

# Print the secret variable
echo "Secret variable content: $2"

# Curl Google and print the return code
curl -I -s http://www.google.com -o /dev/null -w "%{http_code}\n"
