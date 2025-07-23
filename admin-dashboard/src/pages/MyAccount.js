import React, { useState } from 'react';
import '../styles/Dashboard.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Admin account data
const initialAdminData = {
  fullName: 'Dr. Priyantha Wickramasinghe',
  email: 'admin@memoracare.lk',
  password: '••••••••••',
  phoneNumber: '+94 77 234 5678',
  birthday: '1980-03-15',
  profilePicture: 'https://via.placeholder.com/150/2563eb/FFFFFF?text=PW',
  address: '45/1 Galle Road, Bambalapitiya, Colombo 04, Sri Lanka',
  gender: 'Male',
  role: 'System Administrator',
  lastLogin: new Date().toLocaleDateString(),
  status: 'Active'
};

const MyAccount = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [adminData, setAdminData] = useState(initialAdminData);
  const [formData, setFormData] = useState(initialAdminData);

  const handleEditToggle = () => {
    if (isEditing) {
      // Reset form data if canceling
      setFormData(adminData);
    }
    setIsEditing(!isEditing);
  };

  const handleInputChange = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handleSave = () => {
    // Update the admin data with form data
    setAdminData(formData);
    alert('Profile updated successfully');
    setIsEditing(false);
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="my-account" />
      
      <div className="main-content">
        <Header pageTitle="My Account" />
        
        <div className="content">
          <div className="user-management-container">
            <div className="um-modal-content" style={{margin: '0 auto', maxWidth: '800px', position: 'relative'}}>
              <div className="um-modal-header">
                <div className="um-modal-title">
                  <div className="um-modal-icon">👤</div>
                  <div>
                    <h2>Admin Profile</h2>
                    <div className="um-modal-subtitle">System Administrator Account</div>
                  </div>
                </div>
                <button className="um-btn um-btn-primary" onClick={handleEditToggle}>
                  {isEditing ? 'Cancel' : 'Edit Profile'}
                </button>
              </div>
              
              <div className="um-modal-body">
                <div className="um-details-grid">
                  {/* Profile Picture Section */}
                  <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                    <img 
                      src={adminData.profilePicture} 
                      alt={adminData.fullName}
                      style={{
                        width: '150px',
                        height: '150px',
                        borderRadius: '50%',
                        objectFit: 'cover',
                        border: '4px solid var(--um-primary)',
                        marginBottom: '1rem'
                      }}
                    />
                    <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{adminData.fullName}</h3>
                    <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>{adminData.role}</p>
                  </div>

                  {/* Personal Information */}
                  <div className="um-detail-section">
                    <div className="um-section-header">
                      <div className="um-section-icon">👤</div>
                      <h3 className="um-section-title">Personal Information</h3>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Full Name</span>
                      {isEditing ? (
                        <input 
                          type="text" 
                          value={formData.fullName}
                          onChange={(e) => handleInputChange('fullName', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{adminData.fullName}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Email</span>
                      {isEditing ? (
                        <input 
                          type="email" 
                          value={formData.email}
                          onChange={(e) => handleInputChange('email', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{adminData.email}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Password</span>
                      {isEditing ? (
                        <input 
                          type="password" 
                          value={formData.password === '••••••••••' ? '' : formData.password}
                          onChange={(e) => handleInputChange('password', e.target.value)}
                          placeholder="Enter new password"
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{adminData.password}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Phone Number</span>
                      {isEditing ? (
                        <input 
                          type="tel" 
                          value={formData.phoneNumber}
                          onChange={(e) => handleInputChange('phoneNumber', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{adminData.phoneNumber}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Birthday</span>
                      {isEditing ? (
                        <input 
                          type="date" 
                          value={formData.birthday}
                          onChange={(e) => handleInputChange('birthday', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{new Date(adminData.birthday).toLocaleDateString()}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Gender</span>
                      {isEditing ? (
                        <select 
                          value={formData.gender}
                          onChange={(e) => handleInputChange('gender', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px'}}
                        >
                          <option value="Female">Female</option>
                          <option value="Male">Male</option>
                          <option value="Other">Other</option>
                        </select>
                      ) : (
                        <span className="um-detail-value">{adminData.gender}</span>
                      )}
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Address</span>
                      {isEditing ? (
                        <textarea 
                          value={formData.address}
                          onChange={(e) => handleInputChange('address', e.target.value)}
                          className="um-input"
                          style={{maxWidth: '250px', minHeight: '60px'}}
                        />
                      ) : (
                        <span className="um-detail-value">{adminData.address}</span>
                      )}
                    </div>
                  </div>

                  {/* Account Information */}
                  <div className="um-detail-section">
                    <div className="um-section-header">
                      <div className="um-section-icon">🔐</div>
                      <h3 className="um-section-title">Account Information</h3>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Role</span>
                      <span className="um-detail-value">{adminData.role}</span>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Last Login</span>
                      <span className="um-detail-value">{adminData.lastLogin}</span>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Account Status</span>
                      <span className={`um-status-badge ${adminData.status.toLowerCase()}`}>
                        {adminData.status}
                      </span>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Account Type</span>
                      <span className="um-detail-value">Administrator</span>
                    </div>
                    <div className="um-detail-row">
                      <span className="um-detail-label">Permissions</span>
                      <span className="um-detail-value">Full System Access</span>
                    </div>
                  </div>
                </div>
              </div>
              
              {isEditing && (
                <div className="um-modal-footer">
                  <div className="um-modal-actions">
                    <button 
                      className="um-btn um-btn-primary"
                      onClick={handleSave}
                    >
                      Save Changes
                    </button>
                  </div>
                  <button className="um-btn um-btn-secondary" onClick={handleEditToggle}>
                    Cancel
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default MyAccount;
