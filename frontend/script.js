document.addEventListener("DOMContentLoaded", () => {
    // there will be API Gateway in the future
    const apiUrl = "http://localhost:8080/counter"; 

    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            document.getElementById("counter").innerText = data.visits;
        })
        .catch(error => console.error("Error while downloading data:", error));
});