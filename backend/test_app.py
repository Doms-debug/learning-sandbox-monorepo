import json
from unittest.mock import Mock
from main import update_counter

def test_update_counter_returns_valid_response():
    # Arrange 
    mock_request = Mock()
    mock_request.method = 'GET'

    # Act
    response_body, status_code, headers = update_counter(mock_request)
    data = json.loads(response_body)

    # Assert
    assert status_code == 200
    assert headers["Access-Control-Allow-Origin"] == "*"
    assert "visits" in data
    assert isinstance(data["visits"], int)