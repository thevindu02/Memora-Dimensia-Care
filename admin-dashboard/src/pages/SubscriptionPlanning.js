import React, { useState } from 'react';
import '../styles/SubscriptionPlanning.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample subscription plans data
const subscriptionPlansData = [
  {
    id: 1,
    title: 'Basic Care',
    description: 'Essential dementia care features including basic monitoring and simple reminders.',
    durations: {
      '3months': 15000,
      '6months': 25000,
      'annual': 45000
    },
    features: ['Basic Health Monitoring', 'Medication Reminders', 'Emergency Alerts', 'Family Updates'],
    isActive: true,
    createdAt: '2024-01-15',
    updatedAt: '2024-02-20'
  },
  {
    id: 2,
    title: 'Premium Care',
    description: 'Comprehensive dementia care with advanced monitoring, AI assistance, and caregiver support.',
    durations: {
      '3months': 25000,
      '6months': 45000,
      'annual': 80000
    },
    features: ['Advanced Health Monitoring', 'AI Health Assistant', 'Video Consultations', 'Caregiver Network', 'Priority Support'],
    isActive: true,
    createdAt: '2024-01-15',
    updatedAt: '2024-03-10'
  },
  {
    id: 3,
    title: 'Family Plus',
    description: 'Complete family care solution with multiple patient support and extensive caregiver resources.',
    durations: {
      '3months': 35000,
      '6months': 65000,
      'annual': 120000
    },
    features: ['Multi-Patient Support', 'Family Dashboard', 'Professional Caregiver Access', '24/7 Support', 'Advanced Analytics', 'Telehealth Integration'],
    isActive: true,
    createdAt: '2024-02-01',
    updatedAt: '2024-03-15'
  },
  {
    id: 4,
    title: 'Student Plan',
    description: 'Affordable plan for students and researchers studying dementia care.',
    durations: {
      '3months': 8000,
      '6months': 14000,
      'annual': 25000
    },
    features: ['Basic Monitoring', 'Educational Resources', 'Research Tools', 'Limited Support'],
    isActive: false,
    createdAt: '2024-01-20',
    updatedAt: '2024-03-01'
  }
];

const SubscriptionPlanning = () => {
  const [subscriptionPlans, setSubscriptionPlans] = useState(subscriptionPlansData);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  
  // Form state
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    durations: {
      '3months': '',
      '6months': '',
      'annual': ''
    },
    features: [],
    isActive: true
  });
  
  const [newFeature, setNewFeature] = useState('');

  // Statistics
  const totalPlans = subscriptionPlans.length;
  const activePlans = subscriptionPlans.filter(plan => plan.isActive).length;
  const inactivePlans = subscriptionPlans.filter(plan => !plan.isActive).length;

  const handleCreatePlan = () => {
    setEditingPlan(null);
    setFormData({
      title: '',
      description: '',
      durations: {
        '3months': '',
        '6months': '',
        'annual': ''
      },
      features: [],
      isActive: true
    });
    setShowCreateModal(true);
  };

  const handleEditPlan = (plan) => {
    setEditingPlan(plan);
    setFormData({
      title: plan.title,
      description: plan.description,
      durations: plan.durations,
      features: [...plan.features],
      isActive: plan.isActive
    });
    setShowCreateModal(true);
  };

  const handleCloseModal = () => {
    setShowCreateModal(false);
    setEditingPlan(null);
    setFormData({
      title: '',
      description: '',
      durations: {
        '3months': '',
        '6months': '',
        'annual': ''
      },
      features: [],
      isActive: true
    });
    setNewFeature('');
  };

  const handleInputChange = (field, value) => {
    if (field.startsWith('durations.')) {
      const duration = field.split('.')[1];
      setFormData(prev => ({
        ...prev,
        durations: {
          ...prev.durations,
          [duration]: value
        }
      }));
    } else {
      setFormData(prev => ({
        ...prev,
        [field]: value
      }));
    }
  };

  const handleAddFeature = () => {
    if (newFeature.trim() && !formData.features.includes(newFeature.trim())) {
      setFormData(prev => ({
        ...prev,
        features: [...prev.features, newFeature.trim()]
      }));
      setNewFeature('');
    }
  };

  const handleRemoveFeature = (index) => {
    setFormData(prev => ({
      ...prev,
      features: prev.features.filter((_, i) => i !== index)
    }));
  };

  const handleSavePlan = () => {
    if (!formData.title || !formData.description || 
        !formData.durations['3months'] || !formData.durations['6months'] || !formData.durations['annual']) {
      alert('Please fill in all required fields');
      return;
    }

    const planData = {
      ...formData,
      durations: {
        '3months': parseInt(formData.durations['3months']),
        '6months': parseInt(formData.durations['6months']),
        'annual': parseInt(formData.durations['annual'])
      },
      updatedAt: new Date().toISOString().split('T')[0]
    };

    if (editingPlan) {
      // Update existing plan
      setSubscriptionPlans(prev => prev.map(plan => 
        plan.id === editingPlan.id 
          ? { ...plan, ...planData }
          : plan
      ));
    } else {
      // Create new plan
      const newPlan = {
        ...planData,
        id: Math.max(...subscriptionPlans.map(p => p.id)) + 1,
        createdAt: new Date().toISOString().split('T')[0]
      };
      setSubscriptionPlans(prev => [...prev, newPlan]);
    }

    handleCloseModal();
  };

  const handleTogglePlanStatus = (planId) => {
    setSubscriptionPlans(prev => prev.map(plan => 
      plan.id === planId 
        ? { ...plan, isActive: !plan.isActive, updatedAt: new Date().toISOString().split('T')[0] }
        : plan
    ));
  };

  // Filter plans based on search term and status
  const filteredPlans = subscriptionPlans.filter(plan => {
    const matchesSearch = plan.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         plan.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || 
                         (statusFilter === 'active' && plan.isActive) ||
                         (statusFilter === 'inactive' && !plan.isActive);
    return matchesSearch && matchesStatus;
  });

  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-LK', {
      style: 'currency',
      currency: 'LKR',
      minimumFractionDigits: 0
    }).format(price);
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="subscription-planning" />
      
      <div className="main-content">
        <Header pageTitle="Subscription Planning" />
        
        <div className="content">
          <div className="user-management-container">
            {/* Header Actions */}
            <div className="um-header-actions">
              <button 
                className="um-btn um-btn-primary"
                onClick={handleCreatePlan}
              >
                + Create New Plan
              </button>
            </div>

            {/* Search and Filters Section */}
            <div className="um-search-filters">
              <div className="um-search-row">
                <div className="um-search-box">
                  <input 
                    type="text" 
                    placeholder="Search subscription plans..." 
                    className="um-search-input"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                  />
                  <span className="um-search-icon">🔍</span>
                </div>
                
                <div className="um-filters">
                  <select 
                    className="um-filter-select"
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                  >
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="um-stats-grid">
              <div className="um-stat-card">
                <div className="um-stat-icon">📋</div>
                <div className="um-stat-content">
                  <h3>{totalPlans}</h3>
                  <p>Total Plans</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">✅</div>
                <div className="um-stat-content">
                  <h3>{activePlans}</h3>
                  <p>Active Plans</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{inactivePlans}</h3>
                  <p>Inactive Plans</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">💰</div>
                <div className="um-stat-content">
                  <h3>{formatPrice(subscriptionPlans.reduce((sum, plan) => sum + plan.durations.annual, 0) / subscriptionPlans.length)}</h3>
                  <p>Avg Annual Price</p>
                </div>
              </div>
            </div>

            {/* Subscription Plans Grid */}
            <div className="subscription-plans-grid">
              {filteredPlans.map((plan) => (
                <div key={plan.id} className={`subscription-plan-card ${!plan.isActive ? 'inactive' : ''}`}>
                  <div className="plan-header">
                    <h3 className="plan-title">{plan.title}</h3>
                    <span className={`plan-status-badge ${plan.isActive ? 'active' : 'inactive'}`}>
                      {plan.isActive ? 'Active' : 'Inactive'}
                    </span>
                  </div>
                  
                  <p className="plan-description">{plan.description}</p>
                  
                  <div className="plan-pricing">
                    <div className="pricing-option">
                      <span className="duration">3 Months</span>
                      <span className="price">{formatPrice(plan.durations['3months'])}</span>
                    </div>
                    <div className="pricing-option">
                      <span className="duration">6 Months</span>
                      <span className="price">{formatPrice(plan.durations['6months'])}</span>
                    </div>
                    <div className="pricing-option featured">
                      <span className="duration">Annual</span>
                      <span className="price">{formatPrice(plan.durations['annual'])}</span>
                    </div>
                  </div>
                  
                  <div className="plan-features">
                    <h4>Features:</h4>
                    <ul>
                      {plan.features.slice(0, 3).map((feature, index) => (
                        <li key={index}>{feature}</li>
                      ))}
                      {plan.features.length > 3 && (
                        <li className="more-features">+{plan.features.length - 3} more features</li>
                      )}
                    </ul>
                  </div>
                  
                  <div className="plan-actions">
                    <button 
                      className="um-btn um-btn-secondary"
                      onClick={() => handleEditPlan(plan)}
                    >
                      Edit Plan
                    </button>
                    <button 
                      className={`um-btn ${plan.isActive ? 'um-btn-danger' : 'um-btn-success'}`}
                      onClick={() => handleTogglePlanStatus(plan.id)}
                    >
                      {plan.isActive ? 'Deactivate' : 'Activate'}
                    </button>
                  </div>
                  
                  <div className="plan-meta">
                    <small>Created: {plan.createdAt}</small>
                    <small>Updated: {plan.updatedAt}</small>
                  </div>
                </div>
              ))}
            </div>

            {/* Create/Edit Plan Modal */}
            {showCreateModal && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content large-modal" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">💳</div>
                      <div>
                        <h2>{editingPlan ? 'Edit Subscription Plan' : 'Create New Subscription Plan'}</h2>
                        <div className="um-modal-subtitle">
                          {editingPlan ? `Editing: ${editingPlan.title}` : 'Add a new subscription plan'}
                        </div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="subscription-form">
                      {/* Basic Information */}
                      <div className="form-section">
                        <h3>Basic Information</h3>
                        <div className="form-row">
                          <div className="form-group">
                            <label>Plan Title *</label>
                            <input
                              type="text"
                              className="um-input"
                              placeholder="e.g., Premium Care"
                              value={formData.title}
                              onChange={(e) => handleInputChange('title', e.target.value)}
                            />
                          </div>
                          <div className="form-group">
                            <label>Status</label>
                            <select
                              className="um-input"
                              value={formData.isActive ? 'active' : 'inactive'}
                              onChange={(e) => handleInputChange('isActive', e.target.value === 'active')}
                            >
                              <option value="active">Active</option>
                              <option value="inactive">Inactive</option>
                            </select>
                          </div>
                        </div>
                        <div className="form-group">
                          <label>Description *</label>
                          <textarea
                            className="um-input"
                            rows="3"
                            placeholder="Describe the subscription plan features and benefits..."
                            value={formData.description}
                            onChange={(e) => handleInputChange('description', e.target.value)}
                          />
                        </div>
                      </div>

                      {/* Pricing */}
                      <div className="form-section">
                        <h3>Pricing (LKR)</h3>
                        <div className="pricing-inputs">
                          <div className="form-group">
                            <label>3 Months Price *</label>
                            <input
                              type="number"
                              className="um-input"
                              placeholder="15000"
                              value={formData.durations['3months']}
                              onChange={(e) => handleInputChange('durations.3months', e.target.value)}
                            />
                          </div>
                          <div className="form-group">
                            <label>6 Months Price *</label>
                            <input
                              type="number"
                              className="um-input"
                              placeholder="25000"
                              value={formData.durations['6months']}
                              onChange={(e) => handleInputChange('durations.6months', e.target.value)}
                            />
                          </div>
                          <div className="form-group">
                            <label>Annual Price *</label>
                            <input
                              type="number"
                              className="um-input"
                              placeholder="45000"
                              value={formData.durations['annual']}
                              onChange={(e) => handleInputChange('durations.annual', e.target.value)}
                            />
                          </div>
                        </div>
                      </div>

                      {/* Features */}
                      <div className="form-section">
                        <h3>Plan Features</h3>
                        <div className="features-input">
                          <div className="add-feature">
                            <input
                              type="text"
                              className="um-input"
                              placeholder="Add a feature..."
                              value={newFeature}
                              onChange={(e) => setNewFeature(e.target.value)}
                              onKeyPress={(e) => e.key === 'Enter' && handleAddFeature()}
                            />
                            <button 
                              type="button"
                              className="um-btn um-btn-primary"
                              onClick={handleAddFeature}
                            >
                              Add
                            </button>
                          </div>
                          <div className="features-list">
                            {formData.features.map((feature, index) => (
                              <div key={index} className="feature-item">
                                <span>{feature}</span>
                                <button
                                  type="button"
                                  className="remove-feature"
                                  onClick={() => handleRemoveFeature(index)}
                                >
                                  ×
                                </button>
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    <div className="um-modal-actions">
                      <button 
                        className="um-btn um-btn-primary"
                        onClick={handleSavePlan}
                      >
                        {editingPlan ? 'Update Plan' : 'Create Plan'}
                      </button>
                    </div>
                    <button className="um-btn um-btn-secondary" onClick={handleCloseModal}>
                      Cancel
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

export default SubscriptionPlanning;
