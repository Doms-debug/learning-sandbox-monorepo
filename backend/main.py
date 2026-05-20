import json
import functions_framework
from google.cloud import firestore

db = None

@functions_framework.http
def update_counter(request):
    global db
    # CORS (Preflight request)
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)
    
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json'
    }

    try:
        if db is None:
            db = firestore.Client(database="(default)")

        doc_ref = db.collection('stats').document('visitors')
        doc = doc_ref.get()

        if doc.exists:
            count = doc.to_dict().get('count', 0) + 1
        else:
            count = 1
            
        doc_ref.set({'count': count})

        return (json.dumps({"visits": count}), 200, headers)
    
    except Exception as e:
        print(f"Database error: {e}")
        return (json.dumps({"error": "Internal server error"}), 500, headers)