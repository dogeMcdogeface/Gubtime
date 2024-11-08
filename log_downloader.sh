#!/bin/bash

# MySQL configuration
DB_HOST="database"  # Database service name in docker-compose
DB_USER="dbuser"
DB_PASSWORD="dbpassword"
DB_NAME="dbname"

# Output file
OUTPUT_FILE="/usr/share/nginx/html/log_1.yml"


# Infinite loop to run the script every 20 seconds
while true; do
    # Clear the contents of the output file if it exists
    > "$OUTPUT_FILE"

    # Query the database and get the log_data from output_logs
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT log_data FROM output_logs;" | tail -n +2 | while read -r log_data; do
        echo "$log_data" >> "$OUTPUT_FILE"
    done

    echo "All log data has been written to $OUTPUT_FILE."

    # Wait for 20 seconds before the next iteration
    sleep 20
done
