// Protected route component for volunteer authentication
import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import AuthService from '../services/authService';

const ProtectedRoute = ({ children }) => {
  const location = useLocation();

  // Check if user is logged in and is a volunteer
  const isLoggedIn = AuthService.isLoggedIn();
  const isVolunteer = AuthService.isVolunteer();

  if (!isLoggedIn) {
    // Redirect to sign in page with return URL
    return <Navigate to="/SignIn" state={{ from: location }} replace />;
  }

  if (!isVolunteer) {
    // User is logged in but not a volunteer - redirect to sign in with error
    AuthService.logout();
    return <Navigate to="/SignIn" state={{ error: "Volunteer access required" }} replace />;
  }

  // User is authenticated and is a volunteer
  return children;
};

export default ProtectedRoute;
