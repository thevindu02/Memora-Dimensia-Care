import React, { useState } from 'react';
import '../styles/VolunteerEngagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

const VolunteerEngagement = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('monthly');
  const [selectedMonth, setSelectedMonth] = useState('july');

  // Volunteer engagement data by category
  const engagementByCategory = [
    {
      category: 'Articles',
      totalEngagements: 2847,
      uniqueVolunteers: 68,
      avgTimeSpent: 12.5,
      popularItems: ['Dementia Care Tips', 'Family Support Guide', 'Memory Enhancement'],
      monthlyGrowth: 15.3,
      patientPreference: 78.4,
      color: '#3b82f6'
    },
    {
      category: 'Blog Posts',
      totalEngagements: 1924,
      uniqueVolunteers: 52,
      avgTimeSpent: 8.7,
      popularItems: ['Daily Care Routine', 'Nutrition for Seniors', 'Exercise Activities'],
      monthlyGrowth: 12.8,
      patientPreference: 65.2,
      color: '#10b981'
    },
    {
      category: 'Video Lessons',
      totalEngagements: 3156,
      uniqueVolunteers: 71,
      avgTimeSpent: 18.3,
      popularItems: ['Patient Communication', 'Emergency Response', 'Medication Management'],
      monthlyGrowth: 22.1,
      patientPreference: 89.7,
      color: '#f59e0b'
    }
  ];

  // Monthly engagement data
  const monthlyEngagement = [
    { month: 'Jan', articles: 420, blogPosts: 280, videoLessons: 380, total: 1080 },
    { month: 'Feb', articles: 465, blogPosts: 315, videoLessons: 425, total: 1205 },
    { month: 'Mar', articles: 510, blogPosts: 340, videoLessons: 470, total: 1320 },
    { month: 'Apr', articles: 485, blogPosts: 325, videoLessons: 445, total: 1255 },
    { month: 'May', articles: 520, blogPosts: 360, videoLessons: 485, total: 1365 },
    { month: 'Jun', articles: 545, blogPosts: 375, videoLessons: 510, total: 1430 },
    { month: 'Jul', articles: 580, blogPosts: 395, videoLessons: 535, total: 1510 }
  ];

  // Top engaged volunteers by month and category
  const topVolunteersByCategory = {
    july: {
      articles: [
        { name: 'Sarah Mitchell', engagements: 45, timeSpent: '12.5 hrs', specialty: 'Memory Care' },
        { name: 'David Chen', engagements: 38, timeSpent: '10.2 hrs', specialty: 'Family Support' },
        { name: 'Maria Rodriguez', engagements: 35, timeSpent: '9.8 hrs', specialty: 'Daily Care' }
      ],
      blogPosts: [
        { name: 'Jennifer Adams', engagements: 28, timeSpent: '8.5 hrs', specialty: 'Nutrition' },
        { name: 'Robert Kim', engagements: 25, timeSpent: '7.2 hrs', specialty: 'Exercise' },
        { name: 'Lisa Thompson', engagements: 22, timeSpent: '6.8 hrs', specialty: 'Mental Health' }
      ],
      videoLessons: [
        { name: 'Michael Brown', engagements: 52, timeSpent: '18.5 hrs', specialty: 'Emergency Care' },
        { name: 'Emma Wilson', engagements: 48, timeSpent: '16.8 hrs', specialty: 'Communication' },
        { name: 'James Garcia', engagements: 44, timeSpent: '15.2 hrs', specialty: 'Medication' }
      ]
    }
  };

  // Patient preference data
  const patientPreferences = [
    { category: 'Video Lessons', preference: 89.7, reason: 'Visual learning preferred' },
    { category: 'Articles', preference: 78.4, reason: 'Detailed information needed' },
    { category: 'Blog Posts', preference: 65.2, reason: 'Personal experiences valued' }
  ];

  // Engagement statistics
  const engagementStats = {
    totalVolunteers: 78,
    activeVolunteers: 72,
    avgEngagementPerVolunteer: 42.5,
    totalContentViews: 7927,
    avgSessionDuration: 13.2,
    retentionRate: 94.7
  };

  const formatNumber = (num) => {
    return num.toLocaleString();
  };

  const getMaxEngagement = () => {
    return Math.max(...monthlyEngagement.map(item => item.total));
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="volunteer-engagement" />
      
      <div className="main-content">
        <Header pageTitle="Volunteer Engagement Report" />
        
        <div className="content">
          <div className="volunteer-engagement-page">
            {/* Header Controls */}
            <div className="engagement-header">
              <div className="period-selector">
                <button 
                  className={selectedPeriod === 'monthly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('monthly')}
                >
                  Monthly View
                </button>
                <button 
                  className={selectedPeriod === 'quarterly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('quarterly')}
                >
                  Quarterly View
                </button>
              </div>
              
              <div className="month-selector">
                <select 
                  value={selectedMonth}
                  onChange={(e) => setSelectedMonth(e.target.value)}
                  className="month-select"
                >
                  <option value="july">July 2025</option>
                  <option value="june">June 2025</option>
                  <option value="may">May 2025</option>
                </select>
              </div>
            </div>

            {/* Engagement Overview Cards */}
            <div className="engagement-overview">
              <div className="overview-card primary">
                <div className="card-icon">👥</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(engagementStats.totalVolunteers)}</div>
                  <div className="card-label">Total Volunteers</div>
                  <div className="card-trend positive">+{engagementStats.retentionRate}% retention</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">📚</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(engagementStats.totalContentViews)}</div>
                  <div className="card-label">Total Content Views</div>
                  <div className="card-note">Across all categories</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">⏱️</div>
                <div className="card-content">
                  <div className="card-number">{engagementStats.avgSessionDuration} min</div>
                  <div className="card-label">Avg Session Duration</div>
                  <div className="card-note">Per volunteer</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">🎯</div>
                <div className="card-content">
                  <div className="card-number">{engagementStats.avgEngagementPerVolunteer}</div>
                  <div className="card-label">Avg Engagements</div>
                  <div className="card-note">Per volunteer/month</div>
                </div>
              </div>
            </div>

            {/* Engagement by Category */}
            <div className="category-engagement-container">
              <div className="category-header">
                <h3>Volunteer Engagement by Category</h3>
                <p>Detailed breakdown of volunteer activity across content types</p>
              </div>
              <div className="category-grid">
                {engagementByCategory.map((category, index) => (
                  <div key={index} className="category-card">
                    <div className="category-card-header">
                      <div 
                        className="category-indicator"
                        style={{ backgroundColor: category.color }}
                      ></div>
                      <h4>{category.category}</h4>
                      <div className={`growth-badge positive`}>
                        +{category.monthlyGrowth}%
                      </div>
                    </div>
                    <div className="category-stats">
                      <div className="stat-row primary">
                        <span className="stat-label">Total Engagements:</span>
                        <span className="stat-value">{formatNumber(category.totalEngagements)}</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Active Volunteers:</span>
                        <span className="stat-value">{category.uniqueVolunteers}</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Avg Time Spent:</span>
                        <span className="stat-value">{category.avgTimeSpent} min</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Patient Preference:</span>
                        <span className="stat-value preference">{category.patientPreference}%</span>
                      </div>
                    </div>
                    <div className="popular-items">
                      <h5>Most Popular Content:</h5>
                      <ul>
                        {category.popularItems.map((item, idx) => (
                          <li key={idx}>{item}</li>
                        ))}
                      </ul>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Monthly Engagement Chart */}
            <div className="monthly-chart-container">
              <div className="chart-card">
                <div className="chart-header">
                  <h3>Monthly Engagement Trends - 2025</h3>
                  <p>Volunteer activity across all content categories</p>
                </div>
                <div className="chart-content">
                  <div className="engagement-chart">
                    {monthlyEngagement.map((month, index) => (
                      <div key={index} className="month-engagement-item">
                        <div className="month-bars">
                          <div 
                            className="engagement-bar articles"
                            style={{ height: `${(month.articles / getMaxEngagement()) * 200}px` }}
                            title={`Articles: ${formatNumber(month.articles)}`}
                          ></div>
                          <div 
                            className="engagement-bar blog-posts"
                            style={{ height: `${(month.blogPosts / getMaxEngagement()) * 200}px` }}
                            title={`Blog Posts: ${formatNumber(month.blogPosts)}`}
                          ></div>
                          <div 
                            className="engagement-bar video-lessons"
                            style={{ height: `${(month.videoLessons / getMaxEngagement()) * 200}px` }}
                            title={`Video Lessons: ${formatNumber(month.videoLessons)}`}
                          ></div>
                        </div>
                        <div className="month-label">{month.month}</div>
                        <div className="month-total">{formatNumber(month.total)}</div>
                      </div>
                    ))}
                  </div>
                  <div className="chart-legend">
                    <div className="legend-item">
                      <div className="legend-color articles"></div>
                      <span>Articles</span>
                    </div>
                    <div className="legend-item">
                      <div className="legend-color blog-posts"></div>
                      <span>Blog Posts</span>
                    </div>
                    <div className="legend-item">
                      <div className="legend-color video-lessons"></div>
                      <span>Video Lessons</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Top Volunteers by Category */}
            <div className="top-volunteers-container">
              <div className="top-volunteers-header">
                <h3>Most Engaged Volunteers - {selectedMonth.charAt(0).toUpperCase() + selectedMonth.slice(1)} 2025</h3>
                <p>Top performing volunteers in each content category</p>
              </div>
              <div className="volunteers-grid">
                {Object.entries(topVolunteersByCategory[selectedMonth] || {}).map(([category, volunteers]) => (
                  <div key={category} className="volunteers-category-card">
                    <div className="volunteers-category-header">
                      <h4>{category.charAt(0).toUpperCase() + category.slice(1).replace(/([A-Z])/g, ' $1')}</h4>
                    </div>
                    <div className="volunteers-list">
                      {volunteers.map((volunteer, index) => (
                        <div key={index} className="volunteer-item">
                          <div className="volunteer-rank">#{index + 1}</div>
                          <div className="volunteer-info">
                            <div className="volunteer-name">{volunteer.name}</div>
                            <div className="volunteer-specialty">{volunteer.specialty}</div>
                          </div>
                          <div className="volunteer-stats">
                            <div className="volunteer-engagements">{volunteer.engagements} engagements</div>
                            <div className="volunteer-time">{volunteer.timeSpent}</div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Patient Preferences */}
            <div className="patient-preferences-container">
              <div className="preferences-card">
                <div className="preferences-header">
                  <h3>Patient Content Preferences</h3>
                  <p>Which content categories are most preferred by patients</p>
                </div>
                <div className="preferences-list">
                  {patientPreferences.map((pref, index) => (
                    <div key={index} className="preference-item">
                      <div className="preference-info">
                        <div className="preference-category">{pref.category}</div>
                        <div className="preference-reason">{pref.reason}</div>
                      </div>
                      <div className="preference-stats">
                        <div className="preference-percentage">{pref.preference}%</div>
                        <div className="preference-bar">
                          <div 
                            className="preference-fill"
                            style={{ width: `${pref.preference}%` }}
                          ></div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default VolunteerEngagement;
