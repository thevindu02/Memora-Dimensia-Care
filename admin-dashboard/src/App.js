import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import AuthWrapper from './components/AuthWrapper';
import Dashboard from './pages/Dashboard';
import Patients from './pages/Patients';
import Caregiver from './pages/Caregiver';
import BlogPost from './pages/BlogPost';
import Revenue from './pages/Revenue';
import Volunteer from './pages/Volunteer';
import Articles from './pages/Articles';
import VideoLessons from './pages/VideoLessons';
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
          <Route path="/blogpost" element={<AuthWrapper><BlogPost /></AuthWrapper>} />
          <Route path="/revenue" element={<AuthWrapper><Revenue /></AuthWrapper>} />
          <Route path="/volunteer" element={<AuthWrapper><Volunteer /></AuthWrapper>} />
          <Route path="/articles" element={<AuthWrapper><Articles /></AuthWrapper>} />
          <Route path="/video-lessons" element={<AuthWrapper><VideoLessons /></AuthWrapper>} />
          <Route path="/my-account" element={<AuthWrapper><MyAccount /></AuthWrapper>} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
 