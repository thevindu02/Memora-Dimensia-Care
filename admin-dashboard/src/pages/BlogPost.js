import React from 'react';
import '../styles/BlogPost.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample blog post data
const blogPostsData = [
  { id: 1, title: 'Understanding Alzheimer\'s Disease', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2024-07-01', status: 'Pending' },
  { id: 2, title: 'Managing Dementia Symptoms', subject: 'Care Tips', postedBy: 'Nurse Mary Davis', date: '2024-07-02', status: 'Pending' },
  { id: 3, title: 'Family Support Guide', subject: 'Family Care', postedBy: 'Dr. Michael Wilson', date: '2024-06-30', status: 'Posted' },
  { id: 4, title: 'Memory Exercises for Seniors', subject: 'Activities', postedBy: 'Therapist Lisa Brown', date: '2024-06-29', status: 'Posted' },
  { id: 5, title: 'Nutrition for Brain Health', subject: 'Health Education', postedBy: 'Dr. James Miller', date: '2024-06-28', status: 'Rejected' },
  { id: 6, title: 'Early Signs of Dementia', subject: 'Health Education', postedBy: 'Dr. Sarah Johnson', date: '2024-06-27', status: 'Posted' },
  { id: 7, title: 'Caregiver Stress Management', subject: 'Care Tips', postedBy: 'Counselor Anna Lee', date: '2024-06-26', status: 'Pending' },
  { id: 8, title: 'Safe Home Environment', subject: 'Safety', postedBy: 'Dr. Robert Taylor', date: '2024-06-25', status: 'Posted' },
  { id: 9, title: 'Communication Strategies', subject: 'Care Tips', postedBy: 'Therapist Lisa Brown', date: '2024-06-24', status: 'Rejected' },
  { id: 10, title: 'Daily Routine Importance', subject: 'Activities', postedBy: 'Dr. Michael Wilson', date: '2024-06-23', status: 'Posted' },
  { id: 11, title: 'Medication Management', subject: 'Health Education', postedBy: 'Pharmacist Tom Clark', date: '2024-06-22', status: 'Pending' },
  { id: 12, title: 'Support Group Benefits', subject: 'Family Care', postedBy: 'Counselor Anna Lee', date: '2024-06-21', status: 'Posted' },
  { id: 13, title: 'Exercise for Dementia Patients', subject: 'Activities', postedBy: 'Physical Therapist John Smith', date: '2024-06-20', status: 'Rejected' },
  { id: 14, title: 'Technology and Dementia Care', subject: 'Technology', postedBy: 'Dr. Sarah Johnson', date: '2024-06-19', status: 'Pending' },
  { id: 15, title: 'Legal Planning for Families', subject: 'Family Care', postedBy: 'Attorney Mark Davis', date: '2024-06-18', status: 'Posted' }
];

const BlogPost = () => {
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
            <div className="stats-cards">
              <div className="stat-card">
                <div className="stat-icon">📝</div>
                <div className="stat-content">
                  <div className="stat-number">{totalPosts}</div>
                  <div className="stat-label">Total Posts</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">⏳</div>
                <div className="stat-content">
                  <div className="stat-number">{pendingPosts}</div>
                  <div className="stat-label">Pending</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <div className="stat-number">{postedPosts}</div>
                  <div className="stat-label">Posted</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">❌</div>
                <div className="stat-content">
                  <div className="stat-number">{rejectedPosts}</div>
                  <div className="stat-label">Rejected</div>
                </div>
              </div>
            </div>

            {/* Blog Posts Table */}
            <div className="table-container">
              <table className="blogpost-table">
                <thead>
                  <tr>
                    <th>Post Title</th>
                    <th>Subject</th>
                    <th>Posted By</th>
                    <th>Date</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedPosts.map((post) => (
                    <tr key={post.id}>
                      <td>{post.title}</td>
                      <td>{post.subject}</td>
                      <td>{post.postedBy}</td>
                      <td>{new Date(post.date).toLocaleDateString()}</td>
                      <td>
                        <span className={`status-badge ${post.status.toLowerCase()}`}>
                          {post.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default BlogPost;
