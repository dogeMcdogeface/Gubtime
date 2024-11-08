-- Create a table in the dbname database
CREATE TABLE output_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_data TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
