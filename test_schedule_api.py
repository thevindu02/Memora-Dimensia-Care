import requests
import json
from datetime import datetime, timedelta

# API endpoint
base_url = "http://192.168.165.233:8080/api/schedule-sessions"

# Test data
test_data = {
    "sessionDate": "2024-12-25",
    "sessionTime": "14:30:00",
    "sessionTopic": "Memory Enhancement Workshop",
    "description": "A comprehensive workshop focused on memory enhancement techniques for dementia patients",
    "meetingLink": "https://meet.google.com/abc-defg-hij"
}

def test_create_schedule_session():
    """Test creating a new schedule session"""
    try:
        response = requests.post(
            base_url,
            headers={'Content-Type': 'application/json'},
            data=json.dumps(test_data)
        )
        
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
        
        if response.status_code in [200, 201]:
            print("✅ Schedule session created successfully!")
            return True
        else:
            print("❌ Failed to create schedule session")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection error - make sure the backend server is running")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_get_all_sessions():
    """Test getting all schedule sessions"""
    try:
        response = requests.get(base_url)
        
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
        
        if response.status_code == 200:
            print("✅ Retrieved all schedule sessions successfully!")
            return True
        else:
            print("❌ Failed to retrieve schedule sessions")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Connection error - make sure the backend server is running")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    print("Testing Schedule Session API...")
    print("=" * 50)
    
    # Test creating a session
    print("\n1. Testing CREATE schedule session:")
    test_create_schedule_session()
    
    print("\n" + "=" * 50)
    
    # Test getting all sessions
    print("\n2. Testing GET all schedule sessions:")
    test_get_all_sessions()
    
    print("\n" + "=" * 50)
    print("Test completed!") 