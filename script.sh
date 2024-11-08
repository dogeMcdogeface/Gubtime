#!/bin/bash

# MySQL configuration
DB_HOST="database"  # Database service name in docker-compose
DB_USER="dbuser"
DB_PASSWORD="dbpassword"
DB_NAME="dbname"

# Function to execute the script logic
execute_script() {
    # Check if the example.yaml file exists
    if [[ ! -f "/app/example.yaml" ]]; then
        echo "Error: example.yaml file not found in the current directory."
        exit 1
    fi

    # Read the contents of example.yaml into yaml_string
    yaml_string=$(</app/example.yaml)

    # Initialize string to hold output
    output="- entry:"$'\n'

    # Print timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%NZ")
    output+="  - timst: $timestamp"$'\n'

    # Parse YAML string and check responses
    while IFS= read -r line; do
        if [[ "$line" =~ ^\ +url:\ +([^[:space:]]*) ]]; then
            url="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^\ +alias:\ (.*) ]]; then
            alias="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^\ +description:\ (.*) ]]; then
            description="${BASH_REMATCH[1]}"
            start_time=$(date +%s.%N)  # Capture start time
            http_status=$(curl --connect-timeout 3 -s -o /dev/null -w "%{http_code}" "$url")
            end_time=$(date +%s.%N)    # Capture end time
            duration=$(echo "$end_time - $start_time" | bc)  # Calculate duration
            output+="  - alias: $alias"$'\n'
            output+="    desc: $description"$'\n'
            output+="    code: $http_status"$'\n'
            output+="    time: $duration"$'\n'  # Add response time to output
        fi
    done <<< "$yaml_string"

    # Print collected output to console
    echo "$output"

    # Create the table if it doesn't exist
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME <<EOF
    CREATE TABLE IF NOT EXISTS output_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        log_data TEXT NOT NULL,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
EOF

    # Insert output into the MySQL database
    # Use a single INSERT statement to put the output into the 'output_logs' table
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME <<EOF
    INSERT INTO output_logs (log_data, timestamp) VALUES ("$output", NOW());
EOF

    echo "Output written to database successfully."
}

# Loop to run the script every 20 seconds
while true; do
    execute_script
    sleep 20  # Sleep for 20 seconds
done
