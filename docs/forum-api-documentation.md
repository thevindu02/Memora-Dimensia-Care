# Q&A Forum API Documentation

## Base URL
```
http://localhost:8080/api/forum/questions
```

## Endpoints

### 1. Create a New Question
**Endpoint:** `POST /api/forum/questions`

**Description:** Guardians can post a new question anonymously.

**Request Body:**
```json
{
  "guardianId": 1,
  "title": "How to manage medication schedules for elderly patients?",
  "content": "I'm struggling to keep track of multiple medications for my elderly parent. What are some effective strategies or tools that can help?",
  "tags": ["Medication", "Elderly Care", "Scheduling"]
}
```

**Response (201 Created):**
```json
{
  "questionId": "0qnEEIwElMy0pPp2QCho",
  "guardianId": 1,
  "guardianName": "Anonymous Guardian",
  "title": "How to manage medication schedules for elderly patients?",
  "content": "I'm struggling to keep track of multiple medications for my elderly parent. What are some effective strategies or tools that can help?",
  "tags": ["Medication", "Elderly Care", "Scheduling"],
  "views": 0,
  "replies": 0,
  "isAnswered": false,
  "createdAt": "2025-10-16T10:54:34Z",
  "updatedAt": "2025-10-16T10:54:34Z"
}
```

**Error Response (400 Bad Request):**
```json
{
  "error": "Title is required"
}
```

---

### 2. Get All Questions
**Endpoint:** `GET /api/forum/questions`

**Description:** Retrieve all forum questions ordered by creation date (newest first).

**Response (200 OK):**
```json
[
  {
    "questionId": "0qnEEIwElMy0pPp2QCho",
    "guardianId": 1,
    "guardianName": "Anonymous Guardian",
    "title": "How to manage medication schedules for elderly patients?",
    "content": "I'm struggling to keep track of multiple medications...",
    "tags": ["Medication", "Elderly Care", "Scheduling"],
    "views": 23,
    "replies": 5,
    "isAnswered": true,
    "createdAt": "2025-10-16T10:54:34Z",
    "updatedAt": "2025-10-16T12:30:00Z"
  },
  {
    "questionId": "abc123xyz",
    "guardianId": 2,
    "guardianName": "Anonymous Guardian",
    "title": "Best practices for emergency preparedness?",
    "content": "What should I include in an emergency kit...",
    "tags": ["Emergency", "Preparedness"],
    "views": 15,
    "replies": 2,
    "isAnswered": false,
    "createdAt": "2025-10-16T08:20:00Z",
    "updatedAt": "2025-10-16T08:20:00Z"
  }
]
```

---

### 3. Get Single Question by ID
**Endpoint:** `GET /api/forum/questions/{questionId}`

**Description:** Retrieve a specific question by its ID. This also increments the view count.

**Example:** `GET /api/forum/questions/0qnEEIwElMy0pPp2QCho`

**Response (200 OK):**
```json
{
  "questionId": "0qnEEIwElMy0pPp2QCho",
  "guardianId": 1,
  "guardianName": "Anonymous Guardian",
  "title": "How to manage medication schedules for elderly patients?",
  "content": "I'm struggling to keep track of multiple medications for my elderly parent. What are some effective strategies or tools that can help?",
  "tags": ["Medication", "Elderly Care", "Scheduling"],
  "views": 24,
  "replies": 5,
  "isAnswered": true,
  "createdAt": "2025-10-16T10:54:34Z",
  "updatedAt": "2025-10-16T15:45:00Z"
}
```

**Error Response (404 Not Found):**
```json
{
  "error": "Question not found"
}
```

---

### 4. Get Questions by Guardian ID
**Endpoint:** `GET /api/forum/questions/guardian/{guardianId}`

**Description:** Retrieve all questions posted by a specific guardian.

**Example:** `GET /api/forum/questions/guardian/1`

**Response (200 OK):**
```json
[
  {
    "questionId": "0qnEEIwElMy0pPp2QCho",
    "guardianId": 1,
    "guardianName": "Anonymous Guardian",
    "title": "How to manage medication schedules for elderly patients?",
    "content": "I'm struggling to keep track of multiple medications...",
    "tags": ["Medication", "Elderly Care", "Scheduling"],
    "views": 23,
    "replies": 5,
    "isAnswered": true,
    "createdAt": "2025-10-16T10:54:34Z",
    "updatedAt": "2025-10-16T12:30:00Z"
  }
]
```

---

### 5. Get Unanswered Questions
**Endpoint:** `GET /api/forum/questions/unanswered`

**Description:** Retrieve all questions that haven't been answered yet.

**Response (200 OK):**
```json
[
  {
    "questionId": "abc123xyz",
    "guardianId": 2,
    "guardianName": "Anonymous Guardian",
    "title": "Best practices for emergency preparedness?",
    "content": "What should I include in an emergency kit...",
    "tags": ["Emergency", "Preparedness"],
    "views": 15,
    "replies": 0,
    "isAnswered": false,
    "createdAt": "2025-10-16T08:20:00Z",
    "updatedAt": "2025-10-16T08:20:00Z"
  }
]
```

---

### 6. Delete a Question
**Endpoint:** `DELETE /api/forum/questions/{questionId}?guardianId={guardianId}`

**Description:** Delete a question. Only the guardian who posted it can delete it.

**Example:** `DELETE /api/forum/questions/0qnEEIwElMy0pPp2QCho?guardianId=1`

**Response (200 OK):**
```json
{
  "message": "Question deleted successfully"
}
```

**Error Response (403 Forbidden):**
```json
{
  "error": "Cannot delete question - not found or not owner"
}
```

---

## Filter Implementation in Mobile App

The mobile app has these filters:
- **All**: Shows all questions (default endpoint)
- **Unanswered**: Use `/api/forum/questions/unanswered` endpoint
- **Recent**: Filter client-side based on `createdAt` timestamp (questions from last 24 hours)
- **Most Replies**: Sort client-side based on `replies` count (descending)

## Notes

1. **Anonymous Posting**: All questions are posted with `guardianName` set to "Anonymous Guardian" automatically by the backend.

2. **View Count**: Automatically incremented when a question is viewed via the `GET /api/forum/questions/{questionId}` endpoint.

3. **Timestamps**: All timestamps are in ISO 8601 format (UTC).

4. **Guardian ID**: While guardians post anonymously, the `guardianId` is stored internally for ownership verification (edit/delete permissions).

5. **Tags**: Tags are optional but recommended for better categorization and searchability.

## Testing with Postman/curl

### Create a Question
```bash
curl -X POST http://localhost:8080/api/forum/questions \
  -H "Content-Type: application/json" \
  -d '{
    "guardianId": 1,
    "title": "How to manage medication schedules?",
    "content": "Need help with medication management",
    "tags": ["Medication", "Help"]
  }'
```

### Get All Questions
```bash
curl -X GET http://localhost:8080/api/forum/questions
```

### Get Single Question
```bash
curl -X GET http://localhost:8080/api/forum/questions/0qnEEIwElMy0pPp2QCho
```

### Get Unanswered Questions
```bash
curl -X GET http://localhost:8080/api/forum/questions/unanswered
```

### Delete a Question
```bash
curl -X DELETE "http://localhost:8080/api/forum/questions/0qnEEIwElMy0pPp2QCho?guardianId=1"
```
