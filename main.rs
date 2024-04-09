use reqwest::blocking::Client;
use serde::{Deserialize, Serialize};
use std::env;

// Define a struct to represent the YAML structure
#[derive(Debug, Deserialize, Serialize)]
struct UrlData {
    urls: Vec<UrlEntry>,
}

#[derive(Debug, Deserialize, Serialize)]
struct UrlEntry {
    url: String,
    alias: String,
    description: String,
}

fn main() {
    // Retrieve command line arguments
    let args: Vec<String> = env::args().collect();

    // Check if there is an argument passed
    let input_string = if args.len() > 1 {
        args[1].clone() // If argument is present, use it
    } else {
        // If no argument provided, use the default value
        String::from(
            "urls:\n  - url: https://example.com\n    alias: Example\n    description: Example website\n  - url: https://example.org\n    alias: AnotherExample\n    description: Another example website",
        )
    };

    // Print greeting message
    println!("Hello!");

    // Print the value of the string
    println!("{}", input_string);

    // Parse the YAML string
    match serde_yaml::from_str::<UrlData>(&input_string) {
        Ok(data) => {
            // Print the list of URLs
            println!("List of URLs:");
            for url_entry in data.urls {
                println!("Alias: {}", url_entry.alias);
                println!("Description: {}", url_entry.description);
                println!("URL: {}", url_entry.url);

                // Make HTTP request to the URL
                let client = Client::new();
                match client.get(&url_entry.url).send() {
                    Ok(response) => {
                        println!("HTTP Response Code: {}", response.status());
                    }
                    Err(e) => {
                        eprintln!("Error making HTTP request: {:?}{:?}", e,  e.status());
                    }
                }
            }
        }
        Err(e) => {
            eprintln!("Error parsing YAML: {}", e);
        }
    }
}
