document.addEventListener("DOMContentLoaded", () => {

    const counterElement = document.getElementById("counter");

    const apiUrl = "https://europe-central2-prj-cloud-sandbox-repo.cloudfunctions.net/visitor-counter-api"; 

    fetch(apiUrl)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            counterElement.innerText = data.visits;
        })
        .catch(error => {
            console.error("Counter fetch error:", error);
            counterElement.innerText = "Counter server error";
        });
});