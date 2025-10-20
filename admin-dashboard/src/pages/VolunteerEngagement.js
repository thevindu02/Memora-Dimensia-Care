import React, { useState, useEffect } from 'react';
import '../styles/VolunteerEngagement.css';
import '../styles/VolunteerEngagement-tabs.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';
import volunteerEngagementApiService from '../services/volunteerEngagementApiService';

const VolunteerEngagement = () => {
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalVolunteers: 0,
    totalArticles: 0,
    avgArticlesPerMonth: 0
  });
  const [categoryData, setCategoryData] = useState([]);
  const [monthlyData, setMonthlyData] = useState([]);
  const [topVolunteers, setTopVolunteers] = useState([]);
  const [volunteersDetails, setVolunteersDetails] = useState([]);
  const [articlesDetails, setArticlesDetails] = useState([]);
  const [activeTab, setActiveTab] = useState('overview');

  useEffect(() => {
    const fetchAllData = async () => {
      try {
        setLoading(true);
        
        // Fetch all required data including detailed information
        const [statsData, categoriesData, monthlyEngagementData, topVolunteersData, volunteersDetailsData, articlesDetailsData] = await Promise.all([
          volunteerEngagementApiService.getVolunteerEngagementStats(),
          volunteerEngagementApiService.getArticlesByCategory(),
          volunteerEngagementApiService.getMonthlyEngagement(),
          volunteerEngagementApiService.getTopVolunteers(),
          volunteerEngagementApiService.getVolunteersDetails(),
          volunteerEngagementApiService.getArticlesDetails()
        ]);
        
        setStats(statsData);
        setCategoryData(categoriesData);
        setMonthlyData(monthlyEngagementData);
        setTopVolunteers(topVolunteersData);
        setVolunteersDetails(volunteersDetailsData);
        setArticlesDetails(articlesDetailsData);
        
      } catch (error) {
        console.error('Error fetching volunteer engagement data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchAllData();
  }, []);

  const formatNumber = (num) => {
    return num.toLocaleString();
  };

  const getMaxEngagement = () => {
    if (monthlyData.length === 0) return 1;
    return Math.max(...monthlyData.map(item => item.articleCount));
  };

  const getMonthName = (monthNum) => {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[monthNum - 1] || 'Unknown';
  };

  const getCategoryColors = () => {
    const colors = ['#2B3F99', '#A0C4FD', '#C3B1E1', '#E6F3FF', '#9B59B6', '#3498DB'];
    return colors;
  };

  if (loading) {
    return (
      <div className="dashboard">
        <Sidebar currentPage="volunteer-engagement" />
        
        <div className="main-content">
          <Header pageTitle="Volunteer Engagement Report" />
          
          <div className="content">
            <div style={{ textAlign: 'center', padding: '3rem', color: '#666' }}>
              Loading volunteer engagement data...
            </div>
          </div>
          
          <Footer />
        </div>
      </div>
    );
  }

  return (
    <div className="dashboard">
      <Sidebar currentPage="volunteer-engagement" />
      
      <div className="main-content">
        <Header pageTitle="Volunteer Engagement Report" />
        
        <div className="content">
          <div className="volunteer-engagement-page">
            {/* Engagement Overview Cards - Only the 3 required */}
            <div className="engagement-overview">
              <div className="overview-card primary">
                <div className="card-icon">👥</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(stats.totalVolunteers)}</div>
                  <div className="card-label">Total Volunteers</div>
                  <div className="card-note">Active volunteers</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">📝</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(stats.totalArticles)}</div>
                  <div className="card-label">Total Articles</div>
                  <div className="card-note">Published articles</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">📊</div>
                <div className="card-content">
                  <div className="card-number">{stats.avgArticlesPerMonth}</div>
                  <div className="card-label">Avg Articles/Month</div>
                  <div className="card-note">Average engagement</div>
                </div>
              </div>
            </div>

            {/* Navigation Tabs */}
            <div className="engagement-tabs">
              <button 
                className={`tab-button ${activeTab === 'overview' ? 'active' : ''}`}
                onClick={() => setActiveTab('overview')}
              >
                Overview
              </button>
              <button 
                className={`tab-button ${activeTab === 'volunteers' ? 'active' : ''}`}
                onClick={() => setActiveTab('volunteers')}
              >
                Volunteer Details
              </button>
              <button 
                className={`tab-button ${activeTab === 'articles' ? 'active' : ''}`}
                onClick={() => setActiveTab('articles')}
              >
                Article Details
              </button>
            </div>

            {/* Tab Content */}
            {activeTab === 'overview' && (
              <>
            {/* Articles by Category Chart */}
            <div className="category-engagement-container">
              <div className="category-header">
                <h3>Articles Published by Category</h3>
                <p>Distribution of articles across different categories</p>
              </div>
              <div className="category-chart">
                {categoryData.map((category, index) => {
                  const colors = getCategoryColors();
                  const maxCount = Math.max(...categoryData.map(c => c.articleCount));
                  return (
                    <div key={index} className="category-bar-item">
                      <div className="category-bar-label">{category.categoryName || 'Uncategorized'}</div>
                      <div className="category-bar-container">
                        <div 
                          className="category-bar"
                          style={{ 
                            width: `${(category.articleCount / maxCount) * 100}%`,
                            backgroundColor: colors[index % colors.length]
                          }}
                        ></div>
                        <span className="category-count">{category.articleCount}</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Monthly Engagement Chart */}
            <div className="monthly-chart-container">
              <div className="chart-card">
                <div className="chart-header">
                  <h3>Monthly Volunteer Engagement</h3>
                  <p>Articles published per month</p>
                </div>
                <div className="chart-content">
                  <div className="engagement-chart">
                    {monthlyData.slice(-12).map((month, index) => (
                      <div key={index} className="month-engagement-item">
                        <div className="month-bars">
                          <div 
                            className="engagement-bar articles"
                            style={{ height: `${(month.articleCount / getMaxEngagement()) * 200}px` }}
                            title={`Articles: ${formatNumber(month.articleCount)}`}
                          ></div>
                        </div>
                        <div className="month-label">{getMonthName(month.month)} {month.year}</div>
                        <div className="month-total">{formatNumber(month.articleCount)}</div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>

            {/* Top 3 Volunteers */}
            <div className="top-volunteers-container">
              <div className="top-volunteers-header">
                <h3>Top 3 Most Engaged Volunteers</h3>
                <p>Volunteers with the most published articles</p>
              </div>
              <div className="top-volunteers-list">
                {topVolunteers.map((volunteer, index) => (
                  <div key={index} className="top-volunteer-item">
                    <div className="volunteer-rank">#{volunteer.rank}</div>
                    <div className="volunteer-info">
                      <div className="volunteer-name">{volunteer.volunteerName}</div>
                      <div className="volunteer-id">ID: {volunteer.volunteerId}</div>
                    </div>
                    <div className="volunteer-stats">
                      <div className="volunteer-articles">{volunteer.articleCount} articles</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
              </>
            )}

            {activeTab === 'volunteers' && (
              <div className="volunteers-details-container">
                <div className="details-header">
                  <h3>Detailed Volunteer Information</h3>
                  <p>Complete list of volunteers with their contribution details</p>
                </div>
                <div className="volunteers-details-table">
                  <table>
                    <thead>
                      <tr>
                        <th>Volunteer ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Articles Published</th>
                        <th>Join Date</th>
                      </tr>
                    </thead>
                    <tbody>
                      {volunteersDetails.map((volunteer, index) => (
                        <tr key={index}>
                          <td>{volunteer.volunteerId}</td>
                          <td>{volunteer.volunteerName}</td>
                          <td>{volunteer.volunteerEmail || 'N/A'}</td>
                          <td>{volunteer.phoneNumber || 'N/A'}</td>
                          <td>{volunteer.articleCount}</td>
                          <td>{volunteer.joinDate ? new Date(volunteer.joinDate).toLocaleDateString() : 'N/A'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {volunteersDetails.length === 0 && (
                    <div className="no-data">No volunteer details available</div>
                  )}
                </div>
              </div>
            )}

            {activeTab === 'articles' && (
              <div className="articles-details-container">
                <div className="details-header">
                  <h3>Detailed Article Information</h3>
                  <p>Complete list of published articles with author and category details</p>
                </div>
                <div className="articles-details-table">
                  <table>
                    <thead>
                      <tr>
                        <th>Article ID</th>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Published Date</th>
                        <th>Tags</th>
                      </tr>
                    </thead>
                    <tbody>
                      {articlesDetails.map((article, index) => (
                        <tr key={index}>
                          <td>{article.articleId}</td>
                          <td>{article.title}</td>
                          <td>{article.volunteerName}</td>
                          <td>{article.categoryName}</td>
                          <td>
                            <span className={`status-badge ${article.status.toLowerCase()}`}>
                              {article.status}
                            </span>
                          </td>
                          <td>{article.createdAt ? new Date(article.createdAt).toLocaleDateString() : 'N/A'}</td>
                          <td>{article.tagname || 'N/A'}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {articlesDetails.length === 0 && (
                    <div className="no-data">No article details available</div>
                  )}
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

export default VolunteerEngagement;
