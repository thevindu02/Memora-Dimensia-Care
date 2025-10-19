import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import AuthWrapper from './components/AuthWrapper';
import Dashboard from './pages/Dashboard';
import Patients from './pages/Patients';
import Caregiver from './pages/Caregiver';
// import BlogPost from './pages/BlogPost';
import RevenueAnalytics from './pages/RevenueAnalytics';
import UsageReport from './pages/UsageReport';
import VolunteerEngagement from './pages/VolunteerEngagement';
import Volunteer from './pages/Volunteer';
import Articles from './pages/Articles';
// import VideoLessons from './pages/VideoLessons';
import SubscriptionPlanning from './pages/SubscriptionPlanning';
import SubscriptionReport from './pages/SubscriptionReport';
import Login from './pages/Login';
import MyAccount from './pages/MyAccount';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/" element={<AuthWrapper><Dashboard /></AuthWrapper>} />
          <Route path="/patients" element={<AuthWrapper><Patients /></AuthWrapper>} />
          <Route path="/caregiver" element={<AuthWrapper><Caregiver /></AuthWrapper>} />
          {/* <Route path="/blogpost" element={<AuthWrapper><BlogPost /></AuthWrapper>} /> */}
          <Route path="/revenue" element={<AuthWrapper><RevenueAnalytics /></AuthWrapper>} />
          <Route path="/usage-report" element={<AuthWrapper><UsageReport /></AuthWrapper>} />
          <Route path="/volunteer-engagement" element={<AuthWrapper><VolunteerEngagement /></AuthWrapper>} />
          <Route path="/volunteer" element={<AuthWrapper><Volunteer /></AuthWrapper>} />
          <Route path="/articles" element={<AuthWrapper><Articles /></AuthWrapper>} />
          {/* <Route path="/video-lessons" element={<AuthWrapper><VideoLessons /></AuthWrapper>} /> */}
          <Route path="/subscription-planning" element={<AuthWrapper><SubscriptionPlanning /></AuthWrapper>} />
          <Route path="/subscription-report" element={<AuthWrapper><SubscriptionReport /></AuthWrapper>} />
          <Route path="/my-account" element={<AuthWrapper><MyAccount /></AuthWrapper>} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
