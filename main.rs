use chrono::{DateTime, Utc};
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

#[derive(Debug, Deserialize, Serialize)]
struct ResponseData {
    timestamp: DateTime<Utc>,
    responses: Vec<ResponseEntry>,
}

#[derive(Debug, Deserialize, Serialize)]
struct ResponseEntry {
    alias: String,
    description: String,
    response: Option<u16>,
}

fn main() {
    // Retrieve command line arguments
    let args: Vec<String> = env::args().collect();

    // Check if the program is run with the -v option
    let verbose_mode = true; // args.iter().any(|arg| arg == "-v");

    // Check if there is an argument passed
    let input_string = if args.len() > 1 && !verbose_mode {
        args[1].clone() // If argument is present and not in verbose mode, use it
    } else {
        // If no argument provided or in verbose mode, use the default value
        String::from(
            "urls:\n  - url: https://example.com\n    alias: Example\n    description: Example website\n  - url: https://nonexistentwebsite.noway\n    alias: AnotherExample\n    description: Another example website",
        )
    };

    // Print greeting message if in verbose mode
    if verbose_mode {
        println!("Hello!");
    }

    let mut my_vector: Vec<ResponseEntry> = Vec::new();

    // Parse the YAML string
    match serde_yaml::from_str::<UrlData>(&input_string) {
        Ok(data) => {
            // Print the list of URLs if in verbose mode
            if verbose_mode {
                println!("List of URLs:");
            }
            for url_entry in data.urls {
                // Print alias, description and URL if in verbose mode
                if verbose_mode {
                    println!("Alias: {}", url_entry.alias);
                    println!("Description: {}", url_entry.description);
                    println!("URL: {}", url_entry.url);
                }
                let mut a = ResponseEntry {
                    alias: url_entry.alias,
                    description: url_entry.description,
                    response: None,
                };
                // Make HTTP request to the URL
                let client = Client::new();
                match client.get(&url_entry.url).send() {
                    Ok(response) => {
                        // Print HTTP response code if in verbose mode
                        if verbose_mode {
                            println!("HTTP Response Code: {:#?}", response.status());
                            a.response = Some(response.status().as_u16());
                        }
                    }
                    Err(e) => {
                        // Print error if in verbose mode
                        if !e.status().is_none() {
                            if verbose_mode {
                                println!("HTTP Response Code: {:#?}", e.status());
                            }
                        } else {
                            eprintln!("Error making HTTP request: {:#?}", e);
                        }
                    }
                }
                my_vector.push(a);
            }
            // Convert the vector to YAML
            let response = ResponseData {
                timestamp: Utc::now(),
                responses: my_vector,
            };
            let yaml_string = serde_yaml::to_string(&response).unwrap();

            // Print the YAML string
            println!("{}", yaml_string);
        }
        Err(e) => {
            eprintln!("Error parsing YAML: {}", e);
        }
    }
}
