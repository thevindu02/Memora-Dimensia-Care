import React, { useState } from 'react';
import '../styles/Articles.css';
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
    views: 2456,
    likes: 189,
    content: 'Comprehensive guide about dementia care in Sri Lankan context...',
    tags: ['dementia', 'family care', 'sri lanka', 'medical'],
    featured: true,
    language: 'English'
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
    language: 'Sinhala'
  },
  {
    id: 3,
    title: 'Nutrition for Brain Health: Sri Lankan Superfoods',
    author: 'Nutritionist Kamala Silva',
    category: 'Nutrition',
    status: 'Published',
    publishDate: '2024-12-10',
    readTime: '6 min read',
    views: 1823,
    likes: 142,
    content: 'Local superfoods that support brain health and memory...',
    tags: ['nutrition', 'brain health', 'superfoods', 'diet'],
    featured: true,
    language: 'English'
  },
  {
    id: 4,
    title: 'Creating a Safe Home Environment for Dementia Patients',
    author: 'Arch. Nimal Perera',
    category: 'Home Care',
    status: 'Published',
    publishDate: '2024-12-05',
    readTime: '10 min read',
    views: 1567,
    likes: 98,
    content: 'Practical tips for modifying homes for dementia care...',
    tags: ['home safety', 'environment', 'modifications', 'care'],
    featured: false,
    language: 'English'
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
    language: 'Sinhala'
  },
  {
    id: 6,
    title: 'Technology Solutions for Memory Care',
    author: 'Tech Specialist Ruwan Bandara',
    category: 'Technology',
    status: 'Published',
    publishDate: '2024-11-28',
    readTime: '9 min read',
    views: 2103,
    likes: 156,
    content: 'Modern technology tools for dementia care management...',
    tags: ['technology', 'apps', 'devices', 'digital'],
    featured: true,
    language: 'English'
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
    language: 'English'
  },
  {
    id: 8,
    title: 'Exercise and Physical Activity for Memory Health',
    author: 'Physiotherapist Malini Dissanayake',
    category: 'Exercise',
    status: 'Published',
    publishDate: '2024-11-20',
    readTime: '8 min read',
    views: 1789,
    likes: 134,
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

  const getStatusColor = (status) => {
    switch(status) {
      case 'Published': return '#10b981';
      case 'Pending': return '#f59e0b';
      case 'Draft': return '#6b7280';
      case 'Rejected': return '#ef4444';
      default: return '#6b7280';
    }
  };

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
            <div className="articles-table-container">
              <table className="articles-table">
                <thead>
                  <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th>Views</th>
                    <th>Read Time</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedArticles.map(article => (
                    <tr key={article.id} onClick={() => handleArticleClick(article)}>
                      <td>
                        <div className="article-title">
                          {article.featured && <span className="featured-badge">⭐</span>}
                          {article.title}
                        </div>
                      </td>
                      <td>{article.author}</td>
                      <td>
                        <span className="category-badge">{article.category}</span>
                      </td>
                      <td>
                        <span 
                          className="status-badge"
                          style={{ backgroundColor: getStatusColor(article.status) }}
                        >
                          {article.status}
                        </span>
                      </td>
                      <td>{new Date(article.publishDate).toLocaleDateString()}</td>
                      <td>{article.views.toLocaleString()}</td>
                      <td>{article.readTime}</td>
                      <td>
                        <button 
                          className="action-button view-button"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleArticleClick(article);
                          }}
                        >
                          View
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Article Details Modal */}
            {selectedArticle && (
              <div className="modal-overlay" onClick={handleCloseModal}>
                <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-header">
                    <h2>Article Details</h2>
                    <button className="close-button" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="modal-body">
                    <div className="article-details">
                      <div className="article-header">
                        <h3>{selectedArticle.title}</h3>
                        {selectedArticle.featured && <span className="featured-badge">⭐ Featured</span>}
                      </div>
                      
                      <div className="article-meta">
                        <div className="meta-item">
                          <span className="meta-label">Author:</span>
                          <span className="meta-value">{selectedArticle.author}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Category:</span>
                          <span className="meta-value">{selectedArticle.category}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Status:</span>
                          <span 
                            className="status-badge"
                            style={{ backgroundColor: getStatusColor(selectedArticle.status) }}
                          >
                            {selectedArticle.status}
                          </span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Publish Date:</span>
                          <span className="meta-value">{new Date(selectedArticle.publishDate).toLocaleDateString()}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Read Time:</span>
                          <span className="meta-value">{selectedArticle.readTime}</span>
                        </div>
                        <div className="meta-item">
                          <span className="meta-label">Language:</span>
                          <span className="meta-value">{selectedArticle.language}</span>
                        </div>
                      </div>
                      
                      <div className="article-stats">
                        <div className="stat-item">
                          <span className="stat-number">{selectedArticle.views.toLocaleString()}</span>
                          <span className="stat-label">Views</span>
                        </div>
                        <div className="stat-item">
                          <span className="stat-number">{selectedArticle.likes}</span>
                          <span className="stat-label">Likes</span>
                        </div>
                      </div>
                      
                      <div className="article-tags">
                        <span className="tags-label">Tags:</span>
                        {selectedArticle.tags.map(tag => (
                          <span key={tag} className="tag">{tag}</span>
                        ))}
                      </div>
                      
                      <div className="article-content">
                        <h4>Content Preview</h4>
                        <p>{selectedArticle.content}</p>
                      </div>
                    </div>
                  </div>
                  
                  <div className="modal-actions">
                    {selectedArticle.status === 'Pending' && (
                      <>
                        <button 
                          className="publish-button"
                          onClick={() => handlePublishArticle(selectedArticle.id)}
                        >
                          Publish Article
                        </button>
                        <button 
                          className="reject-button"
                          onClick={() => handleRejectArticle(selectedArticle.id)}
                        >
                          Reject Article
                        </button>
                      </>
                    )}
                    {(selectedArticle.status === 'Published' || selectedArticle.status === 'Draft') && (
                      <button 
                        className="edit-button"
                        onClick={() => handleEditArticle(selectedArticle.id)}
                      >
                        Edit Article
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

export default Articles;
