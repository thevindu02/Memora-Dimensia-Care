import React, { useState, useEffect } from 'react';
import '../styles/Articles.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';
import articleApiService from '../services/articleApiService';

const Articles = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [selectedArticle, setSelectedArticle] = useState(null);
  const [articles, setArticles] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Fetch data on component mount
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError('');
        
        // Fetch articles and categories in parallel
        const [articlesData, categoriesData] = await Promise.all([
          articleApiService.getAllArticles(), // Changed to get ALL articles
          articleApiService.getCategories()
        ]);
        
        setArticles(articlesData);
        setCategories(categoriesData);
        console.log('Articles loaded:', articlesData.length);
        console.log('Categories loaded:', categoriesData.length);
      } catch (err) {
        console.error('Error fetching data:', err);
        setError('Failed to load articles. Please try again.');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Transform status for display
  const getDisplayStatus = (article) => {
    // Handle draft status first
    if (article.draft === true) {
      return 'Draft';
    }
    
    // Handle non-draft status based on approval
    if (article.status === 'approved') {
      return 'Published';
    } else if (article.status === 'disapproved') {
      return 'Rejected';
    } else if (!article.status || article.status === 'pending') {
      return 'Pending';
    } else {
      return 'Pending'; // Default for unknown statuses
    }
  };

  // Calculate stats from real data
  const totalArticles = articles.length;
  const publishedArticles = articles.filter(article => getDisplayStatus(article) === 'Published').length;
  const pendingArticles = articles.filter(article => getDisplayStatus(article) === 'Pending').length;
  const draftArticles = articles.filter(article => getDisplayStatus(article) === 'Draft').length;
  const rejectedArticles = articles.filter(article => getDisplayStatus(article) === 'Rejected').length;

  const handleArticleClick = (article) => {
    setSelectedArticle(article);
  };

  const handleCloseModal = () => {
    setSelectedArticle(null);
  };

  const handlePublishArticle = async (articleId) => {
    try {
      console.log('Approving article:', articleId);
      await articleApiService.approveArticle(articleId);
      
      // Refresh the articles list
      const updatedArticles = await articleApiService.getAllArticles();
      setArticles(updatedArticles);
      
      handleCloseModal();
      alert('Article approved successfully!');
    } catch (error) {
      console.error('Error approving article:', error);
      alert('Failed to approve article. Please try again.');
    }
  };

  const handleRejectArticle = async (articleId) => {
    try {
      console.log('Rejecting article:', articleId);
      await articleApiService.rejectArticle(articleId);
      
      // Refresh the articles list
      const updatedArticles = await articleApiService.getAllArticles();
      setArticles(updatedArticles);
      
      handleCloseModal();
      alert('Article rejected successfully!');
    } catch (error) {
      console.error('Error rejecting article:', error);
      alert('Failed to reject article. Please try again.');
    }
  };

  const handleEditArticle = (articleId) => {
    // UI only - no backend functionality
    console.log('View full article:', articleId);
    // TODO: Navigate to full article view or open in new tab
    handleCloseModal();
  };

  // Filter articles based on search term, status, and category
  const filteredArticles = articles.filter(article => {
    const displayStatus = getDisplayStatus(article);
    const categoryName = article.categoryName || '';
    const authorName = article.authorName || 'Unknown Author';
    const title = article.title || '';
    
    const matchesSearch = title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         authorName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         categoryName.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || displayStatus === statusFilter;
    const matchesCategory = categoryFilter === '' || categoryName === categoryFilter;
    return matchesSearch && matchesStatus && matchesCategory;
  });

  // Sort articles to show pending first, then published, then drafts, then rejected
  const sortedArticles = [...filteredArticles].sort((a, b) => {
    const statusOrder = { 'Pending': 0, 'Published': 1, 'Draft': 2, 'Rejected': 3 };
    const statusA = getDisplayStatus(a);
    const statusB = getDisplayStatus(b);
    
    if (statusOrder[statusA] !== statusOrder[statusB]) {
      return statusOrder[statusA] - statusOrder[statusB];
    }
    
    // Sort by creation date (most recent first)
    const dateA = new Date(a.created_at || 0);
    const dateB = new Date(b.created_at || 0);
    return dateB - dateA;
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
                  {categories.map(category => (
                    <option key={category.categoryId} value={category.categoryName}>
                      {category.categoryName}
                    </option>
                  ))}
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
              <div className="stat-card">
                <div className="stat-icon">❌</div>
                <div className="stat-content">
                  <h3>{rejectedArticles}</h3>
                  <p>Rejected</p>
                </div>
              </div>
            </div>

            {/* Articles Table */}
            <div className="um-table-container">
              {loading ? (
                <div className="loading-message">
                  <p>Loading articles...</p>
                </div>
              ) : error ? (
                <div className="error-message">
                  <p>{error}</p>
                  <button 
                    className="um-btn um-btn-primary"
                    onClick={() => window.location.reload()}
                  >
                    Retry
                  </button>
                </div>
              ) : (
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
                    {sortedArticles.length === 0 ? (
                      <tr>
                        <td colSpan="6" style={{textAlign: 'center', padding: '2rem'}}>
                          No articles found matching your filters.
                        </td>
                      </tr>
                    ) : (
                      sortedArticles.map(article => {
                        const displayStatus = getDisplayStatus(article);
                        return (
                          <tr key={article.articleId}>
                            <td className="um-name-cell">
                              <div className="article-title">
                                {article.title}
                              </div>
                            </td>
                            <td>{article.authorName || 'Unknown Author'}</td>
                            <td>
                              <span className="um-status-badge category">
                                {article.categoryName || 'Uncategorized'}
                              </span>
                            </td>
                            <td>
                              {article.created_at 
                                ? articleApiService.formatDate(article.created_at)
                                : 'Unknown'
                              }
                            </td>
                            <td>
                              <span className={`um-status-badge ${displayStatus.toLowerCase()}`}>
                                {displayStatus}
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
                        );
                      })
                    )}
                  </tbody>
                </table>
              )}
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
                        <div className="um-modal-subtitle">ID: {selectedArticle.articleId}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedArticle.authorProfilePic || selectedArticle.articleImg || articleApiService.getPlaceholderImage()} 
                          alt={selectedArticle.authorName || 'Author'}
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
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>by {selectedArticle.authorName || 'Unknown Author'}</p>
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
                          <span className="um-detail-value">{selectedArticle.authorName || 'Unknown Author'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Author Email</span>
                          <span className="um-detail-value">{selectedArticle.authorEmail || 'N/A'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Category</span>
                          <span className="um-detail-value">{selectedArticle.categoryName || 'Uncategorized'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${getDisplayStatus(selectedArticle).toLowerCase()}`}>
                            {getDisplayStatus(selectedArticle)}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Created Date</span>
                          <span className="um-detail-value">
                            {selectedArticle.created_at 
                              ? articleApiService.formatDate(selectedArticle.created_at)
                              : 'Unknown'
                            }
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Volunteer ID</span>
                          <span className="um-detail-value">{selectedArticle.volunteerId || 'N/A'}</span>
                        </div>
                      </div>

                      {/* Content & Summary */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📊</div>
                          <h3 className="um-section-title">Content & Details</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Summary</span>
                          <span className="um-detail-value">
                            {selectedArticle.summary || articleApiService.generateExcerpt(selectedArticle.content)}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Article Image</span>
                          <span className="um-detail-value">
                            {selectedArticle.articleImg ? (
                              <img 
                                src={selectedArticle.articleImg} 
                                alt="Article" 
                                style={{maxWidth: '200px', maxHeight: '100px', objectFit: 'cover', borderRadius: '4px'}}
                              />
                            ) : (
                              'No image'
                            )}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Draft Status</span>
                          <span className="um-detail-value">{selectedArticle.draft ? 'Yes' : 'No'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Content Preview</span>
                          <div className="um-detail-value" style={{maxHeight: '200px', overflow: 'auto', border: '1px solid #ddd', padding: '1rem', borderRadius: '4px', backgroundColor: '#f9f9f9'}}>
                            {selectedArticle.content || 'No content available'}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    {getDisplayStatus(selectedArticle) === 'Pending' && (
                      <>
                        <button 
                          className="um-btn um-btn-success"
                          onClick={() => handlePublishArticle(selectedArticle.articleId)}
                        >
                          Approve Article
                        </button>
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleRejectArticle(selectedArticle.articleId)}
                        >
                          Reject Article
                        </button>
                      </>
                    )}
                    {(getDisplayStatus(selectedArticle) === 'Published' || getDisplayStatus(selectedArticle) === 'Draft') && (
                      <button 
                        className="um-btn um-btn-primary"
                        onClick={() => handleEditArticle(selectedArticle.articleId)}
                      >
                        View Full Article
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