import React, { useState } from 'react';
import '../styles/BlogPost.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample blog post data
const blogPostsData = [
  { id: 1, title: 'Understanding Alzheimer\'s Disease', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2024-07-01', status: 'Pending', authorPicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=SJ' },
  { id: 2, title: 'Managing Dementia Symptoms', subject: 'Care Tips', postedBy: 'Nurse Mary Davis', date: '2024-07-02', status: 'Pending', authorPicture: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=MD' },
  { id: 3, title: 'Family Support Guide', subject: 'Family Care', postedBy: 'Dr. Michael Wilson', date: '2024-06-30', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=MW' },
  { id: 4, title: 'Memory Exercises for Seniors', subject: 'Activities', postedBy: 'Therapist Lisa Brown', date: '2024-06-29', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/9B59B6/FFFFFF?text=LB' },
  { id: 5, title: 'Nutrition for Brain Health', subject: 'Health Education', postedBy: 'Dr. James Miller', date: '2024-06-28', status: 'Rejected', authorPicture: 'https://via.placeholder.com/150/F39C12/FFFFFF?text=JM' },
  { id: 6, title: 'Early Signs of Dementia', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2024-06-27', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=SJ' },
  { id: 7, title: 'Caregiver Stress Management', subject: 'Care Tips', postedBy: 'Counselor Anna Lee', date: '2024-06-26', status: 'Pending', authorPicture: 'https://via.placeholder.com/150/E74C3C/FFFFFF?text=AL' },
  { id: 8, title: 'Safe Home Environment', subject: 'Safety', postedBy: 'Dr. Robert Taylor', date: '2024-06-25', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/3498DB/FFFFFF?text=RT' },
  { id: 9, title: 'Communication Strategies', subject: 'Care Tips', postedBy: 'Therapist Lisa Brown', date: '2024-06-24', status: 'Rejected', authorPicture: 'https://via.placeholder.com/150/9B59B6/FFFFFF?text=LB' },
  { id: 10, title: 'Daily Routine Importance', subject: 'Activities', postedBy: 'Dr. Michael Wilson', date: '2024-06-23', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=MW' },
  { id: 11, title: 'Medication Management', subject: 'Health Education', postedBy: 'Pharmacist Tom Clark', date: '2024-06-22', status: 'Pending', authorPicture: 'https://via.placeholder.com/150/1ABC9C/FFFFFF?text=TC' },
  { id: 12, title: 'Support Group Benefits', subject: 'Family Care', postedBy: 'Counselor Anna Lee', date: '2024-06-21', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/E74C3C/FFFFFF?text=AL' },
  { id: 13, title: 'Exercise for Dementia Patients', subject: 'Activities', postedBy: 'Physical Therapist John Smith', date: '2024-06-20', status: 'Rejected', authorPicture: 'https://via.placeholder.com/150/8E44AD/FFFFFF?text=JS' },
  { id: 14, title: 'Technology and Dementia Care', subject: 'Technology', postedBy: 'Dr. Sarah Johnson', date: '2024-06-19', status: 'Pending', authorPicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=SJ' },
  { id: 15, title: 'Legal Planning for Families', subject: 'Family Care', postedBy: 'Attorney Mark Davis', date: '2024-06-18', status: 'Posted', authorPicture: 'https://via.placeholder.com/150/D35400/FFFFFF?text=MD' }
];

const BlogPost = () => {
  const [selectedPost, setSelectedPost] = useState(null);

  const handleViewDetails = (post) => {
    setSelectedPost(post);
  };

  const handleCloseModal = () => {
    setSelectedPost(null);
  };

  const handleApprovePost = (id) => {
    console.log('Approve post:', id);
    handleCloseModal();
  };

  const handleRejectPost = (id) => {
    console.log('Reject post:', id);
    handleCloseModal();
  };

  const handleEditPost = (id) => {
    console.log('Edit post:', id);
    handleCloseModal();
  };

  // Sort posts to show pending first
  const sortedPosts = [...blogPostsData].sort((a, b) => {
    if (a.status === 'Pending' && b.status !== 'Pending') return -1;
    if (a.status !== 'Pending' && b.status === 'Pending') return 1;
    return new Date(b.date) - new Date(a.date);
  });

  const totalPosts = blogPostsData.length;
  const pendingPosts = blogPostsData.filter(post => post.status === 'Pending').length;
  const postedPosts = blogPostsData.filter(post => post.status === 'Posted').length;
  const rejectedPosts = blogPostsData.filter(post => post.status === 'Rejected').length;

  return (
    <div className="dashboard">
      <Sidebar currentPage="blogpost" />
      
      <div className="main-content">
        <Header pageTitle="Blog Posts" />
        
        <div className="content">
          <div className="blogpost-page">
            {/* Search and Filters Section */}
            <div className="search-filters-section">
              <div className="search-box">
                <input 
                  type="text" 
                  placeholder="Search blog posts..." 
                  className="search-input"
                />
                <span className="search-icon">🔍</span>
              </div>
              
              <div className="filters-section">
                <input 
                  type="date" 
                  className="date-filter"
                />
                <select className="filter-dropdown">
                  <option value="">All Status</option>
                  <option value="pending">Pending</option>
                  <option value="posted">Posted</option>
                  <option value="rejected">Rejected</option>
                </select>
                <select className="filter-dropdown">
                  <option value="">All Subjects</option>
                  <option value="health">Health Education</option>
                  <option value="care">Care Tips</option>
                  <option value="family">Family Care</option>
                  <option value="activities">Activities</option>
                  <option value="safety">Safety</option>
                  <option value="technology">Technology</option>
                </select>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="um-stats-grid">
              <div className="um-stat-card">
                <div className="um-stat-icon">📝</div>
                <div className="um-stat-content">
                  <h3>{totalPosts}</h3>
                  <p>Total Posts</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">⏳</div>
                <div className="um-stat-content">
                  <h3>{pendingPosts}</h3>
                  <p>Pending</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">✅</div>
                <div className="um-stat-content">
                  <h3>{postedPosts}</h3>
                  <p>Posted</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{rejectedPosts}</h3>
                  <p>Rejected</p>
                </div>
              </div>
            </div>

            {/* Blog Posts Table */}
            <div className="um-table-container">
              <table className="um-table">
                <thead>
                  <tr>
                    <th>Post Title</th>
                    <th>Subject</th>
                    <th>Posted By</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedPosts.map((post) => (
                    <tr key={post.id}>
                      <td className="um-name-cell">{post.title}</td>
                      <td>{post.subject}</td>
                      <td>{post.postedBy}</td>
                      <td>{new Date(post.date).toLocaleDateString()}</td>
                      <td>
                        <span className={`um-status-badge ${post.status.toLowerCase()}`}>
                          {post.status}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="um-btn um-btn-primary um-btn-sm"
                          onClick={() => handleViewDetails(post)}
                        >
                          View Details
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Blog Post Details Modal */}
            {selectedPost && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">📝</div>
                      <div>
                        <h2>Blog Post Details</h2>
                        <div className="um-modal-subtitle">ID: #{selectedPost.id}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedPost.authorPicture} 
                          alt={selectedPost.postedBy}
                          style={{
                            width: '120px',
                            height: '120px',
                            borderRadius: '50%',
                            objectFit: 'cover',
                            border: '4px solid var(--um-primary)',
                            marginBottom: '1rem',
                            display: 'block',
                            margin: '0 auto 1rem auto',
                            aspectRatio: '1 / 1'
                          }}
                        />
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedPost.title}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>by {selectedPost.postedBy}</p>
                      </div>

                      {/* Post Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📋</div>
                          <h3 className="um-section-title">Post Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Title</span>
                          <span className="um-detail-value">{selectedPost.title}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Subject</span>
                          <span className="um-detail-value">{selectedPost.subject}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Posted By</span>
                          <span className="um-detail-value">{selectedPost.postedBy}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Date</span>
                          <span className="um-detail-value">{new Date(selectedPost.date).toLocaleDateString()}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedPost.status.toLowerCase()}`}>
                            {selectedPost.status}
                          </span>
                        </div>
                      </div>

                      {/* Content Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📄</div>
                          <h3 className="um-section-title">Content Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Content Preview</span>
                          <span className="um-detail-value">This is a sample blog post content preview. In a real application, this would contain the actual blog post content that users have submitted for review.</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    {selectedPost.status === 'Pending' && (
                      <>
                        <button 
                          className="um-btn um-btn-success"
                          onClick={() => handleApprovePost(selectedPost.id)}
                        >
                          Approve Post
                        </button>
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleRejectPost(selectedPost.id)}
                        >
                          Reject Post
                        </button>
                      </>
                    )}
                    {(selectedPost.status === 'Posted' || selectedPost.status === 'Rejected') && (
                      <button 
                        className="um-btn um-btn-primary"
                        onClick={() => handleEditPost(selectedPost.id)}
                      >
                        Edit Post
                      </button>
                    )}
                    <button className="um-btn um-btn-secondary" onClick={handleCloseModal}>
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

export default BlogPost;
