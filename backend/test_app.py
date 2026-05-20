import json
from unittest.mock import Mock, patch
import main

def test_update_counter_increments_value():
    mock_doc = Mock()
    mock_doc.exists = True
    mock_doc.to_dict.return_value = {'count': 23}
    
    mock_doc_ref = Mock()
    mock_doc_ref.get.return_value = mock_doc
    
    mock_collection = Mock()
    mock_collection.document.return_value = mock_doc_ref
    
    mock_db = Mock()
    mock_db.collection.return_value = mock_collection
    
    # Injecting mock to app
    main.db = mock_db

    mock_request = Mock()
    mock_request.method = 'GET'

    response_body, status_code, headers = main.update_counter(mock_request)
    data = json.loads(response_body)

    assert status_code == 200
    assert data["visits"] == 24
    
    mock_doc_ref.set.assert_called_once_with({'count': 24})