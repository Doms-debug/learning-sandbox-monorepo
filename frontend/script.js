document.addEventListener("DOMContentLoaded", () => {

    const counterElement = document.getElementById("counter");

    const apiUrl = "/api"; 

    fetch(apiUrl)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            counterElement.innerText = `Visitors counter: ${data.views}`;
        })
        .catch(error => {
            console.error("Counter fetch error:", error);
            counterElement.innerText = "Counter server error";
        });
});