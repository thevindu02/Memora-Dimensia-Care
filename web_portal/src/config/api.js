// API configuration for the web portal
const CONFIG = {
  // Backend API base URL - update this to match your backend server
  API_BASE_URL: 'http://localhost:8080/api',
  
  // Endpoints
  ENDPOINTS: {
    VOLUNTEER_REQUESTS: '/volunteer-requests',
    IMAGE_UPLOAD: '/upload/image',
    AUTH: '/auth',
    SCHEDULE_SESSIONS: '/schedule-sessions',
    ARTICLES: '/articles',
    CATEGORIES: '/categories',
  },
  
  // File upload settings
  UPLOAD_SETTINGS: {
    MAX_FILE_SIZE: 5 * 1024 * 1024, // 5MB
    ALLOWED_FILE_TYPES: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'],
  },
};

export default CONFIG;
