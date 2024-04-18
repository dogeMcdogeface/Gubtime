function toggleDarkTheme() {
    const d = document.documentElement.classList.toggle("dark");
    document.documentElement.classList.toggle("light", !d);
}

function getCSSVar(variableName) {
    return getComputedStyle(document.documentElement).getPropertyValue(variableName).trim();
}

function timeSince(date) {
    const units = ["Y", "Mon", "D", "H", "min", "s"];
    const divisors = [31536000, 2592000, 86400, 3600, 60, 1];
    for (let i = 0; i < units.length; i++) {
        const interval = Math.floor((new Date() - date) / 1000 / divisors[i]);
        if (interval >= 1) {
            return interval + " " + units[i];
        }
    }
    return "0 seconds";
}
