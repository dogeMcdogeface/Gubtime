#!/bin/bash

# Print the string passed as input
echo "Input string: $1"

# Curl Google and print the return code
curl -I -s http://www.google.com -o /dev/null -w "%{http_code}\n"
