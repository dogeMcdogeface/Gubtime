const latestUrl = "http://localhost/latest.txt";

let logsData;
let maxLogFiles = 8; //TODO

// Async function to fetch data from URL
async function fetchData(url) {
    try {
        console.log("Loading file: ", url);
        const response = await fetch(url);
		if(!response.ok) return null;
        const data = await response.text();
        return data;
    } catch (error) {
        console.log("Error fetching data:", error);
        return null;
    }
}

// Send signal after loading data
async function loadDataAndSendSignal() {
    const latestData = await fetchData(`${latestUrl}?${Date.now()}`);
    console.log("Latest: ", latestData);

    if (latestData) {
        // Parse latest.txt to get log information
        const logInfo = jsyaml.load(latestData);
        const logRepo = logInfo.LOG_REPO;
        const logBrnc = logInfo.LOG_BRNC;
        const logPath = logInfo.LOG_PATH;
        const logName = logInfo.LOG_NAME;
        let logWeek = parseInt(logInfo.LOG_WEEK); // Convert to number for calculation
        const logType = logInfo.LOG_TYPE;

        while (logWeek >= 0) {
            const logFile = `${logRepo}/${logBrnc}/${logPath}${logName}${logWeek}${logType}`;
            console.log("Composed Log Path: ", logFile);
            // Construct URL for the latest log file
            const logUrl = `http://localhost/${logFile}?${Date.now()}`;
            // Fetch the log file
            let yamlData = await fetchData(logUrl);
            logWeek--;
            if (yamlData) {
                yamlData = yamlData.replace(/\\n/g, '\n');
                console.log("bibi", yamlData);
                const tmpData = jsyaml.load(yamlData);
                if (!logsData || logsData.length === 0) {
                    logsData = tmpData;
                } else {
                    logsData = tmpData.concat(logsData);
                }
                console.log(logsData);
                // Dispatch a custom event to signal that data is loaded
                document.dispatchEvent(new CustomEvent("dataLoaded", { detail: logsData }));
                document.dispatchEvent(new CustomEvent("newdataLoaded", { detail: tmpData }));
            } else {
                console.error("Failed to fetch log data.");
            }
        }
    } else {
        console.error("Failed to fetch latest log information.");
    }
}

// Call the function to load data and send signal
loadDataAndSendSignal();
