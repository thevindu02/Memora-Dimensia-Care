import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Dashboard from './pages/Dashboard';
import Patients from './pages/Patients';
import Caregiver from './pages/Caregiver';
import BlogPost from './pages/BlogPost';
import Revenue from './pages/Revenue';
import Volunteer from './pages/Volunteer';
import Articles from './pages/Articles';
import VideoLessons from './pages/VideoLessons';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/patients" element={<Patients />} />
          <Route path="/caregiver" element={<Caregiver />} />
          <Route path="/blogpost" element={<BlogPost />} />
          <Route path="/revenue" element={<Revenue />} />
          <Route path="/volunteer" element={<Volunteer />} />
          <Route path="/articles" element={<Articles />} />
          <Route path="/video-lessons" element={<VideoLessons />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
 