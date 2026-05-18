import json
import functions_framework

@functions_framework.http
def update_counter(request):
    """
    Main GCP connector. Firestore to be added later on
    """
    # CORS (Preflight request)
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    # standard headers
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
    }
    
    # hardcoded values for now
    simulated_visit_count = 23

    return (json.dumps({"visits": simulated_visit_count}), 200, headers)