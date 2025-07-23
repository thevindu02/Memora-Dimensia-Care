import React, { useState } from 'react';
import '../styles/VideoLessons.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample video lessons data with Sri Lankan context
const videoLessonsData = [
  {
    id: 1,
    title: 'Introduction to Dementia Care - සිංහල',
    instructor: 'Dr. Chaminda Rajapaksa',
    category: 'Basic Care',
    duration: '15:30',
    status: 'Published',
    uploadDate: '2024-12-10',
    views: 3456,
    likes: 289,
    language: 'Sinhala',
    difficulty: 'Beginner',
    description: 'Introduction to basic dementia care principles for families in Sri Lanka',
    thumbnail: '/api/placeholder/320/180',
    tags: ['dementia', 'care', 'family', 'basics'],
    featured: true,
    rating: 4.8
  },
  {
    id: 2,
    title: 'Daily Care Routines for Dementia Patients',
    instructor: 'Nurse Malini Wijesinghe',
    category: 'Daily Care',
    duration: '22:15',
    status: 'Published',
    uploadDate: '2024-12-08',
    views: 2890,
    likes: 234,
    language: 'English',
    difficulty: 'Intermediate',
    description: 'Comprehensive guide to establishing daily care routines',
    thumbnail: '/api/placeholder/320/180',
    tags: ['daily care', 'routine', 'patient care'],
    featured: true,
    rating: 4.7
  },
  {
    id: 3,
    title: 'Understanding Behavioral Changes',
    instructor: 'Dr. Anura Wickramasinghe',
    category: 'Psychology',
    duration: '18:45',
    status: 'Pending',
    uploadDate: '2024-12-15',
    views: 0,
    likes: 0,
    language: 'English',
    difficulty: 'Advanced',
    description: 'Managing challenging behaviors in dementia patients',
    thumbnail: '/api/placeholder/320/180',
    tags: ['behavior', 'psychology', 'management'],
    featured: false,
    rating: 0
  },
  {
    id: 4,
    title: 'Nutrition and Feeding Techniques',
    instructor: 'Nutritionist Kamala Silva',
    category: 'Nutrition',
    duration: '25:20',
    status: 'Published',
    uploadDate: '2024-12-05',
    views: 1876,
    likes: 145,
    language: 'English',
    difficulty: 'Intermediate',
    description: 'Proper nutrition and feeding techniques for dementia patients',
    thumbnail: '/api/placeholder/320/180',
    tags: ['nutrition', 'feeding', 'health'],
    featured: false,
    rating: 4.6
  },
  {
    id: 5,
    title: 'Home Safety Modifications - Tamil',
    instructor: 'Architect Rajan Murugan',
    category: 'Home Safety',
    duration: '20:10',
    status: 'Published',
    uploadDate: '2024-12-02',
    views: 1234,
    likes: 98,
    language: 'Tamil',
    difficulty: 'Beginner',
    description: 'Making homes safe for dementia patients in Tamil',
    thumbnail: '/api/placeholder/320/180',
    tags: ['safety', 'home', 'modifications'],
    featured: false,
    rating: 4.5
  },
  {
    id: 6,
    title: 'Communication Strategies',
    instructor: 'Speech Therapist Sanduni Perera',
    category: 'Communication',
    duration: '16:30',
    status: 'Draft',
    uploadDate: '2024-12-20',
    views: 0,
    likes: 0,
    language: 'English',
    difficulty: 'Intermediate',
    description: 'Effective communication with dementia patients',
    thumbnail: '/api/placeholder/320/180',
    tags: ['communication', 'speech', 'therapy'],
    featured: false,
    rating: 0
  },
  {
    id: 7,
    title: 'Exercise and Physical Activity',
    instructor: 'Physiotherapist Nimal Bandara',
    category: 'Exercise',
    duration: '30:45',
    status: 'Published',
    uploadDate: '2024-11-28',
    views: 2456,
    likes: 187,
    language: 'English',
    difficulty: 'Beginner',
    description: 'Safe exercises for dementia patients',
    thumbnail: '/api/placeholder/320/180',
    tags: ['exercise', 'physical', 'activity'],
    featured: true,
    rating: 4.9
  },
  {
    id: 8,
    title: 'Managing Medications',
    instructor: 'Pharmacist Ruwan Fernando',
    category: 'Medical',
    duration: '12:20',
    status: 'Rejected',
    uploadDate: '2024-12-12',
    views: 0,
    likes: 0,
    language: 'English',
    difficulty: 'Advanced',
    description: 'Proper medication management for dementia patients',
    thumbnail: '/api/placeholder/320/180',
    tags: ['medication', 'medical', 'management'],
    featured: false,
    rating: 0
  }
];

const VideoLessons = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [difficultyFilter, setDifficultyFilter] = useState('');
  const [selectedVideo, setSelectedVideo] = useState(null);

  // Calculate stats
  const totalVideos = videoLessonsData.length;
  const publishedVideos = videoLessonsData.filter(video => video.status === 'Published').length;
  const pendingVideos = videoLessonsData.filter(video => video.status === 'Pending').length;
  const totalViews = videoLessonsData.reduce((sum, video) => sum + video.views, 0);

  const handleVideoClick = (video) => {
    setSelectedVideo(video);
  };

  const handleCloseModal = () => {
    setSelectedVideo(null);
  };

  const handlePublishVideo = (videoId) => {
    // UI only - no backend functionality
    console.log('Publish video:', videoId);
    handleCloseModal();
  };

  const handleRejectVideo = (videoId) => {
    // UI only - no backend functionality
    console.log('Reject video:', videoId);
    handleCloseModal();
  };

  const handleEditVideo = (videoId) => {
    // UI only - no backend functionality
    console.log('Edit video:', videoId);
    handleCloseModal();
  };

  const handleWatchVideo = (videoId) => {
    // UI only - no backend functionality
    console.log('Watch video:', videoId);
    handleCloseModal();
  };

  // Filter videos based on search term, status, category, and difficulty
  const filteredVideos = videoLessonsData.filter(video => {
    const matchesSearch = video.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         video.instructor.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         video.category.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || video.status === statusFilter;
    const matchesCategory = categoryFilter === '' || video.category === categoryFilter;
    const matchesDifficulty = difficultyFilter === '' || video.difficulty === difficultyFilter;
    return matchesSearch && matchesStatus && matchesCategory && matchesDifficulty;
  });

  // Sort videos to show pending first, then published, then drafts, then rejected
  const sortedVideos = [...filteredVideos].sort((a, b) => {
    const statusOrder = { 'Pending': 0, 'Published': 1, 'Draft': 2, 'Rejected': 3 };
    if (statusOrder[a.status] !== statusOrder[b.status]) {
      return statusOrder[a.status] - statusOrder[b.status];
    }
    return new Date(b.uploadDate) - new Date(a.uploadDate);
  });

  const getStatusColor = (status) => {
    switch(status) {
      case 'Published': return '#2B3F99';
      case 'Pending': return '#A0C4FD';
      case 'Draft': return '#390797';
      case 'Rejected': return '#390797';
      default: return '#390797';
    }
  };

  const getDifficultyColor = (difficulty) => {
    switch(difficulty) {
      case 'Beginner': return '#2B3F99';
      case 'Intermediate': return '#A0C4FD';
      case 'Advanced': return '#390797';
      default: return '#390797';
    }
  };

  const renderStars = (rating) => {
    const stars = [];
    for (let i = 1; i <= 5; i++) {
      stars.push(
        <span key={i} className={i <= rating ? 'star filled' : 'star'}>
          ⭐
        </span>
      );
    }
    return stars;
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="video-lessons" />
      
      <div className="main-content">
        <Header pageTitle="Video Lessons" />
        
        <div className="content">
          <div className="video-lessons-page">
            {/* Search and Filters */}
            <div className="search-filters-section">
              <div className="search-box">
                <input
                  type="text"
                  placeholder="Search videos..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="search-input"
                />
                <span className="search-icon">🔍</span>
              </div>
              
              <div className="filters">
                <select 
                  value={statusFilter} 
                  onChange={(e) => setStatusFilter(e.target.value)}
                  className="filter-select"
                >
                  <option value="">All Status</option>
                  <option value="Published">Published</option>
                  <option value="Pending">Pending</option>
                  <option value="Draft">Draft</option>
                  <option value="Rejected">Rejected</option>
                </select>
                
                <select 
                  value={categoryFilter} 
                  onChange={(e) => setCategoryFilter(e.target.value)}
                  className="filter-select"
                >
                  <option value="">All Categories</option>
                  <option value="Basic Care">Basic Care</option>
                  <option value="Daily Care">Daily Care</option>
                  <option value="Psychology">Psychology</option>
                  <option value="Nutrition">Nutrition</option>
                  <option value="Home Safety">Home Safety</option>
                  <option value="Communication">Communication</option>
                  <option value="Exercise">Exercise</option>
                  <option value="Medical">Medical</option>
                </select>
                
                <select 
                  value={difficultyFilter} 
                  onChange={(e) => setDifficultyFilter(e.target.value)}
                  className="filter-select"
                >
                  <option value="">All Levels</option>
                  <option value="Beginner">Beginner</option>
                  <option value="Intermediate">Intermediate</option>
                  <option value="Advanced">Advanced</option>
                </select>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="stats-grid">
              <div className="stat-card">
                <div className="stat-icon">🎥</div>
                <div className="stat-content">
                  <h3>{totalVideos}</h3>
                  <p>Total Videos</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <h3>{publishedVideos}</h3>
                  <p>Published</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">⏳</div>
                <div className="stat-content">
                  <h3>{pendingVideos}</h3>
                  <p>Pending Review</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">👁️</div>
                <div className="stat-content">
                  <h3>{totalViews.toLocaleString()}</h3>
                  <p>Total Views</p>
                </div>
              </div>
            </div>

            {/* Video Grid */}
            <div className="video-grid">
              {sortedVideos.map(video => (
                <div key={video.id} className="video-card" onClick={() => handleVideoClick(video)}>
                  <div className="video-thumbnail">
                    <div className="thumbnail-placeholder">
                      <span className="play-icon">▶️</span>
                    </div>
                    <div className="video-duration">{video.duration}</div>
                    {video.featured && <div className="featured-badge">⭐</div>}
                  </div>
                  
                  <div className="video-info">
                    <h3 className="video-title">{video.title}</h3>
                    <p className="video-instructor">{video.instructor}</p>
                    
                    <div className="video-meta">
                      <span className="category-badge">{video.category}</span>
                      <span 
                        className="difficulty-badge"
                        style={{ backgroundColor: getDifficultyColor(video.difficulty) }}
                      >
                        {video.difficulty}
                      </span>
                    </div>
                    
                    <div className="video-stats">
                      <span className="views">{video.views.toLocaleString()} views</span>
                      <span className="likes">❤️ {video.likes}</span>
                      {video.rating > 0 && (
                        <div className="rating">
                          {renderStars(video.rating)}
                        </div>
                      )}
                    </div>
                    
                    <div className="video-status">
                      <span 
                        className="status-badge"
                        style={{ backgroundColor: getStatusColor(video.status) }}
                      >
                        {video.status}
                      </span>
                      <span className="upload-date">
                        {new Date(video.uploadDate).toLocaleDateString()}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Video Details Modal */}
            {selectedVideo && (
              <div className="modal-overlay" onClick={handleCloseModal}>
                <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-header">
                    <h2>Video Details</h2>
                    <button className="close-button" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="modal-body">
                    <div className="video-details">
                      <div className="video-header">
                        <div className="video-thumbnail-large">
                          <div className="thumbnail-placeholder">
                            <span className="play-icon">▶️</span>
                          </div>
                          <div className="video-duration">{selectedVideo.duration}</div>
                        </div>
                        
                        <div className="video-info-detailed">
                          <h3>{selectedVideo.title}</h3>
                          {selectedVideo.featured && <span className="featured-badge">⭐ Featured</span>}
                          <p className="instructor">By {selectedVideo.instructor}</p>
                          
                          {selectedVideo.rating > 0 && (
                            <div className="rating-section">
                              <div className="rating-stars">
                                {renderStars(selectedVideo.rating)}
                              </div>
                              <span className="rating-text">{selectedVideo.rating}/5</span>
                            </div>
                          )}
                        </div>
                      </div>
                      
                      <div className="video-meta-detailed">
                        <div className="meta-item">
                          <span className="meta-label">Category:</span>
                          <span className="meta-value">{selectedVideo.category}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Difficulty:</span>
                          <span 
                            className="difficulty-badge"
                            style={{ backgroundColor: getDifficultyColor(selectedVideo.difficulty) }}
                          >
                            {selectedVideo.difficulty}
                          </span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Language:</span>
                          <span className="meta-value">{selectedVideo.language}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Status:</span>
                          <span 
                            className="status-badge"
                            style={{ backgroundColor: getStatusColor(selectedVideo.status) }}
                          >
                            {selectedVideo.status}
                          </span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Upload Date:</span>
                          <span className="meta-value">{new Date(selectedVideo.uploadDate).toLocaleDateString()}</span>
                        </div>
                      </div>
                      
                      <div className="video-stats-detailed">
                        <div className="stat-item">
                          <span className="stat-number">{selectedVideo.views.toLocaleString()}</span>
                          <span className="stat-label">Views</span>
                        </div>
                        <div className="stat-item">
                          <span className="stat-number">{selectedVideo.likes}</span>
                          <span className="stat-label">Likes</span>
                        </div>
                        <div className="stat-item">
                          <span className="stat-number">{selectedVideo.duration}</span>
                          <span className="stat-label">Duration</span>
                        </div>
                      </div>
                      
                      <div className="video-description">
                        <h4>Description</h4>
                        <p>{selectedVideo.description}</p>
                      </div>
                      
                      <div className="video-tags">
                        <span className="tags-label">Tags:</span>
                        {selectedVideo.tags.map(tag => (
                          <span key={tag} className="tag">{tag}</span>
                        ))}
                      </div>
                    </div>
                  </div>
                  
                  <div className="modal-actions">
                    {selectedVideo.status === 'Published' && (
                      <button 
                        className="watch-button"
                        onClick={() => handleWatchVideo(selectedVideo.id)}
                      >
                        Watch Video
                      </button>
                    )}
                    {selectedVideo.status === 'Pending' && (
                      <>
                        <button 
                          className="publish-button"
                          onClick={() => handlePublishVideo(selectedVideo.id)}
                        >
                          Publish Video
                        </button>
                        <button 
                          className="reject-button"
                          onClick={() => handleRejectVideo(selectedVideo.id)}
                        >
                          Reject Video
                        </button>
                      </>
                    )}
                    {(selectedVideo.status === 'Published' || selectedVideo.status === 'Draft') && (
                      <button 
                        className="edit-button"
                        onClick={() => handleEditVideo(selectedVideo.id)}
                      >
                        Edit Video
                      </button>
                    )}
                    <button className="close-modal-button" onClick={handleCloseModal}>
                      Close
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default VideoLessons;
