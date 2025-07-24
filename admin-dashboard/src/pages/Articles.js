import React, { useState } from 'react';
import '../styles/Articles.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample articles data with Sri Lankan context
const articlesData = [
  {
    id: 1,
    title: 'Understanding Dementia: A Guide for Sri Lankan Families',
    author: 'Dr. Priya Jayawardena',
    category: 'Medical',
    status: 'Published',
    publishDate: '2024-12-15',
    readTime: '8 min read',
    views: 66,
    likes: 34,
    content: 'Comprehensive guide about dementia care in Sri Lankan context...',
    tags: ['dementia', 'family care', 'sri lanka', 'medical'],
    featured: true,
    language: 'English',
    authorPicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=PJ'
  },
  {
    id: 2,
    title: 'Traditional Ayurvedic Approaches to Memory Care',
    author: 'Prof. Sunil Rathnayake',
    category: 'Traditional Medicine',
    status: 'Pending',
    publishDate: '2024-12-20',
    readTime: '12 min read',
    views: 0,
    likes: 0,
    content: 'Exploring traditional Ayurvedic methods for memory enhancement...',
    tags: ['ayurveda', 'memory', 'traditional', 'herbal'],
    featured: false,
    language: 'Sinhala',
    authorPicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=SR'
  },
  {
    id: 3,
    title: 'Nutrition for Brain Health: Sri Lankan Superfoods',
    author: 'Nutritionist Kamala Silva',
    category: 'Nutrition',
    status: 'Published',
    publishDate: '2024-12-10',
    readTime: '6 min read',
    views: 98,
    likes: 35,
    content: 'Local superfoods that support brain health and memory...',
    tags: ['nutrition', 'brain health', 'superfoods', 'diet'],
    featured: true,
    language: 'English',
    authorPicture: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=KS'
  },
  {
    id: 4,
    title: 'Creating a Safe Home Environment for Dementia Patients',
    author: 'Arch. Nimal Perera',
    category: 'Home Care',
    status: 'Published',
    publishDate: '2024-12-05',
    readTime: '10 min read',
    views: 158,
    likes: 80,
    content: 'Practical tips for modifying homes for dementia care...',
    tags: ['home safety', 'environment', 'modifications', 'care'],
    featured: false,
    language: 'English',
    authorPicture: 'https://via.placeholder.com/150/9B59B6/FFFFFF?text=NP'
  },
  {
    id: 5,
    title: 'Community Support Systems in Rural Sri Lanka',
    author: 'Social Worker Sanduni Fernando',
    category: 'Community',
    status: 'Draft',
    publishDate: '2024-12-25',
    readTime: '7 min read',
    views: 0,
    likes: 0,
    content: 'Building community networks for dementia care support...',
    tags: ['community', 'rural', 'support', 'networks'],
    featured: false,
    language: 'Sinhala',
    authorPicture: 'https://via.placeholder.com/150/F39C12/FFFFFF?text=SF'
  },
  {
    id: 6,
    title: 'Technology Solutions for Memory Care',
    author: 'Tech Specialist Ruwan Bandara',
    category: 'Technology',
    status: 'Published',
    publishDate: '2024-11-28',
    readTime: '9 min read',
    views: 130,
    likes: 76,
    content: 'Modern technology tools for dementia care management...',
    tags: ['technology', 'apps', 'devices', 'digital'],
    featured: true,
    language: 'English',
    authorPicture: 'https://via.placeholder.com/150/E74C3C/FFFFFF?text=RB'
  },
  {
    id: 7,
    title: 'Managing Behavioral Changes in Dementia',
    author: 'Dr. Anura Wickramasinghe',
    category: 'Psychology',
    status: 'Rejected',
    publishDate: '2024-12-18',
    readTime: '11 min read',
    views: 0,
    likes: 0,
    content: 'Understanding and managing behavioral symptoms...',
    tags: ['behavior', 'psychology', 'management', 'symptoms'],
    featured: false,
    language: 'English',
    authorPicture: 'https://via.placeholder.com/150/3498DB/FFFFFF?text=AW'
  },
  {
    id: 8,
    title: 'Exercise and Physical Activity for Memory Health',
    author: 'Physiotherapist Malini Dissanayake',
    category: 'Exercise',
    status: 'Published',
    publishDate: '2024-11-20',
    readTime: '8 min read',
    views: 76,
    likes: 15,
    content: 'Physical activities that support cognitive function...',
    tags: ['exercise', 'physical', 'memory', 'health'],
    featured: false,
    language: 'English'
  }
];

const Articles = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [selectedArticle, setSelectedArticle] = useState(null);

  // Calculate stats
  const totalArticles = articlesData.length;
  const publishedArticles = articlesData.filter(article => article.status === 'Published').length;
  const pendingArticles = articlesData.filter(article => article.status === 'Pending').length;
  const draftArticles = articlesData.filter(article => article.status === 'Draft').length;

  const handleArticleClick = (article) => {
    setSelectedArticle(article);
  };

  const handleCloseModal = () => {
    setSelectedArticle(null);
  };

  const handlePublishArticle = (articleId) => {
    // UI only - no backend functionality
    console.log('Publish article:', articleId);
    handleCloseModal();
  };

  const handleRejectArticle = (articleId) => {
    // UI only - no backend functionality
    console.log('Reject article:', articleId);
    handleCloseModal();
  };

  const handleEditArticle = (articleId) => {
    // UI only - no backend functionality
    console.log('Edit article:', articleId);
    handleCloseModal();
  };

  // Filter articles based on search term, status, and category
  const filteredArticles = articlesData.filter(article => {
    const matchesSearch = article.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         article.author.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         article.category.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || article.status === statusFilter;
    const matchesCategory = categoryFilter === '' || article.category === categoryFilter;
    return matchesSearch && matchesStatus && matchesCategory;
  });

  // Sort articles to show pending first, then published, then drafts, then rejected
  const sortedArticles = [...filteredArticles].sort((a, b) => {
    const statusOrder = { 'Pending': 0, 'Published': 1, 'Draft': 2, 'Rejected': 3 };
    if (statusOrder[a.status] !== statusOrder[b.status]) {
      return statusOrder[a.status] - statusOrder[b.status];
    }
    return new Date(b.publishDate) - new Date(a.publishDate);
  });

  return (
    <div className="dashboard">
      <Sidebar currentPage="articles" />
      
      <div className="main-content">
        <Header pageTitle="Articles" />
        
        <div className="content">
          <div className="articles-page">
            {/* Search and Filters */}
            <div className="search-filters-section">
              <div className="search-box">
                <input
                  type="text"
                  placeholder="Search articles..."
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
                  <option value="Medical">Medical</option>
                  <option value="Nutrition">Nutrition</option>
                  <option value="Technology">Technology</option>
                  <option value="Community">Community</option>
                  <option value="Exercise">Exercise</option>
                  <option value="Psychology">Psychology</option>
                  <option value="Home Care">Home Care</option>
                  <option value="Traditional Medicine">Traditional Medicine</option>
                </select>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="stats-grid">
              <div className="stat-card">
                <div className="stat-icon">📚</div>
                <div className="stat-content">
                  <h3>{totalArticles}</h3>
                  <p>Total Articles</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <h3>{publishedArticles}</h3>
                  <p>Published</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">⏳</div>
                <div className="stat-content">
                  <h3>{pendingArticles}</h3>
                  <p>Pending Review</p>
                </div>
              </div>
              <div className="stat-card">
                <div className="stat-icon">📝</div>
                <div className="stat-content">
                  <h3>{draftArticles}</h3>
                  <p>Drafts</p>
                </div>
              </div>
            </div>

            {/* Articles Table */}
            <div className="um-table-container">
              <table className="um-table">
                <thead>
                  <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedArticles.map(article => (
                    <tr key={article.id}>
                      <td className="um-name-cell">
                        <div className="article-title">
                          {article.featured && <span className="featured-badge">⭐</span>}
                          {article.title}
                        </div>
                      </td>
                      <td>{article.author}</td>
                      <td>
                        <span className="um-status-badge category">{article.category}</span>
                      </td>
                      <td>{new Date(article.publishDate).toLocaleDateString()}</td>
                      <td>
                        <span className={`um-status-badge ${article.status.toLowerCase()}`}>
                          {article.status}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="um-btn um-btn-primary um-btn-sm"
                          onClick={() => handleArticleClick(article)}
                        >
                          View Details
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Article Details Modal */}
            {selectedArticle && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">📄</div>
                      <div>
                        <h2>Article Details</h2>
                        <div className="um-modal-subtitle">ID: #{selectedArticle.id}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedArticle.authorPicture} 
                          alt={selectedArticle.author}
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
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedArticle.title}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>by {selectedArticle.author}</p>
                      </div>

                      {/* Article Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📋</div>
                          <h3 className="um-section-title">Article Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Title</span>
                          <span className="um-detail-value">{selectedArticle.title}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Author</span>
                          <span className="um-detail-value">{selectedArticle.author}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Category</span>
                          <span className="um-detail-value">{selectedArticle.category}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedArticle.status.toLowerCase()}`}>
                            {selectedArticle.status}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Publish Date</span>
                          <span className="um-detail-value">{new Date(selectedArticle.publishDate).toLocaleDateString()}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Read Time</span>
                          <span className="um-detail-value">{selectedArticle.readTime}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Language</span>
                          <span className="um-detail-value">{selectedArticle.language}</span>
                        </div>
                      </div>

                      {/* Statistics & Content */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📊</div>
                          <h3 className="um-section-title">Statistics & Content</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Views</span>
                          <span className="um-detail-value">{selectedArticle.views.toLocaleString()}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Likes</span>
                          <span className="um-detail-value">{selectedArticle.likes}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Featured</span>
                          <span className="um-detail-value">{selectedArticle.featured ? '⭐ Yes' : 'No'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Tags</span>
                          <span className="um-detail-value">{selectedArticle.tags.join(', ')}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Content Preview</span>
                          <span className="um-detail-value">{selectedArticle.content}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    {selectedArticle.status === 'Pending' && (
                      <>
                        <button 
                          className="um-btn um-btn-success"
                          onClick={() => handlePublishArticle(selectedArticle.id)}
                        >
                          Publish Article
                        </button>
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleRejectArticle(selectedArticle.id)}
                        >
                          Reject Article
                        </button>
                      </>
                    )}
                    {(selectedArticle.status === 'Published' || selectedArticle.status === 'Draft') && (
                      <button 
                        className="um-btn um-btn-primary"
                        onClick={() => handleEditArticle(selectedArticle.id)}
                      >
                        Edit Article
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

export default Articles;
