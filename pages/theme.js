function toggleDarkTheme() {
    const d = document.documentElement.classList.toggle("dark");
    document.documentElement.classList.toggle("light", !d);
}

function getCSSVar(variableName) {
    return getComputedStyle(document.documentElement).getPropertyValue(variableName).trim();
}
