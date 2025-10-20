// Firebase configuration for web portal
// Configuration from mobile_app/lib/firebase_options.dart (web platform)
// Project: memora-2025

import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

// Firebase configuration object - Web platform
const firebaseConfig = {
  apiKey: "AIzaSyAGIMis-SuVtV21CX5DSW3htW2UitOmHMg",
  authDomain: "memora-2025.firebaseapp.com",
  projectId: "memora-2025",
  storageBucket: "memora-2025.firebasestorage.app",
  messagingSenderId: "212050041276",
  appId: "1:212050041276:web:cd72a36f248f355ec1f3b9",
  measurementId: "G-RFQYWD6Z0Q"
};

// Initialize Firebase
let app;
let db;
let auth;

try {
  app = initializeApp(firebaseConfig);
  db = getFirestore(app);
  auth = getAuth(app);
  console.log('Firebase initialized successfully for memora-2025');
} catch (error) {
  console.error('Error initializing Firebase:', error);
}

export { app, db, auth };
export default app;
