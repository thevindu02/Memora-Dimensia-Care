import React, { useState, useEffect } from 'react';
import '../styles/Volunteer.css';
import '../styles/UserManagement.css';
import volunteerApiService from '../services/volunteerApiService';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

const Volunteer = () => {
  const [volunteers, setVolunteers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedVolunteer, setSelectedVolunteer] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [volunteerPassword, setVolunteerPassword] = useState('');
  const [showPasswordInput, setShowPasswordInput] = useState(false);

  // Fetch volunteer data on component mount
  useEffect(() => {
    fetchVolunteers();
  }, []);

  const fetchVolunteers = async () => {
    try {
      console.log('Fetching volunteer data...');
      setLoading(true);
      setError(null);
      const data = await volunteerApiService.getAllVolunteersAndRequests();
      console.log('Received volunteer data:', data);
      setVolunteers(data);
    } catch (error) {
      console.error('Error fetching volunteers:', error);
      setError('Failed to load volunteer data. Please try again later.');
    } finally {
      setLoading(false);
    }
  };

  // Transform backend data to match frontend expectations
  const transformVolunteerData = (volunteer) => {
    // Extract filename from full path for volunteer ID image
    let volunteerIdImageFilename = volunteer.volunteerIdImage;
    if (volunteerIdImageFilename && volunteerIdImageFilename.includes('/')) {
      volunteerIdImageFilename = volunteerIdImageFilename.split('/').pop();
    }
    
    // Handle both volunteer requests and accepted volunteers
    let id, name, status, createdAt, city, birthdate, profilePic;
    
    if (volunteer.type === 'request') {
      // This is from volunteer_requests table
      id = volunteer.requestId;
      name = volunteer.volunteerName;
      status = volunteer.requestStatus;
      createdAt = volunteer.createdAt;
      city = 'N/A';
      birthdate = 'N/A';
      profilePic = null;
    } else {
      // This is from volunteers table (accepted volunteer)
      id = volunteer.volunteerId;
      name = volunteer.volunteerName || `${volunteer.firstName || ''} ${volunteer.lastName || ''}`.trim();
      // Use displayStatus which maps INACTIVE to "pending" and SUSPENDED to "disabled"
      status = volunteer.displayStatus || volunteer.userStatus || 'active';
      createdAt = volunteer.createdAt;
      city = volunteer.city || 'N/A';
      birthdate = volunteer.birthdate ? new Date(volunteer.birthdate).toLocaleDateString() : 'N/A';
      profilePic = volunteer.profilePic;
    }
    
    return {
      id: id,
      name: name,
      email: volunteer.email,
      phone: volunteer.phoneNumber,
      gender: volunteer.gender,
      status: status,
      createdAt: createdAt,
      volunteerIdImage: volunteerIdImageFilename,
      city: city,
      birthdate: birthdate,
      profilePic: profilePic,
      type: volunteer.type, // 'request' or 'volunteer'
      userId: volunteer.userId, // For accepted volunteers
      volunteerId: volunteer.volunteerId, // For accepted volunteers
      requestId: volunteer.requestId // For volunteer requests
    };
  };

  const transformedVolunteers = volunteers.map(transformVolunteerData);

  const totalVolunteers = transformedVolunteers.length;
  const approvedVolunteers = transformedVolunteers.filter(volunteer => 
    volunteer.status === 'accepted'
  ).length;
  const pendingVolunteers = transformedVolunteers.filter(volunteer => volunteer.status === 'pending').length;
  const rejectedVolunteers = transformedVolunteers.filter(volunteer => 
    volunteer.status === 'rejected'
  ).length;

  const handleVolunteerClick = (volunteer) => {
    setSelectedVolunteer(volunteer);
  };

  const handleCloseModal = () => {
    setSelectedVolunteer(null);
    setVolunteerPassword('');
    setShowPasswordInput(false);
  };

  const handleAcceptVolunteer = async (volunteerId) => {
    // Only allow accepting for volunteer requests (not already accepted volunteers)
    if (selectedVolunteer && selectedVolunteer.type !== 'request') {
      alert('This volunteer is already accepted.');
      return;
    }

    if (!showPasswordInput) {
      // Show password input first
      setShowPasswordInput(true);
      return;
    }
    
    if (!volunteerPassword.trim()) {
      alert('Please enter a password for the volunteer');
      return;
    }
    
    try {
      await volunteerApiService.acceptVolunteerRequest(volunteerId, volunteerPassword);
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
      // Reset password fields
      setVolunteerPassword('');
      setShowPasswordInput(false);
    } catch (error) {
      console.error('Error accepting volunteer:', error);
      alert('Error accepting volunteer. Please try again.');
    }
  };

  const handleRejectVolunteer = async (volunteerId) => {
    // Only allow rejecting for volunteer requests (not already accepted volunteers)
    if (selectedVolunteer && selectedVolunteer.type !== 'request') {
      alert('Cannot reject an already accepted volunteer. Please use user management instead.');
      return;
    }

    try {
      await volunteerApiService.rejectVolunteerRequest(volunteerId);
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
    } catch (error) {
      console.error('Error rejecting volunteer:', error);
    }
  };

  const handleDisableVolunteer = async (volunteerId) => {
    try {
      await volunteerApiService.disableVolunteer(volunteerId);
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
    } catch (error) {
      console.error('Error disabling volunteer:', error);
      alert('Error disabling volunteer. Please try again.');
    }
  };

  const handleEnableVolunteer = async (volunteerId) => {
    try {
      await volunteerApiService.enableVolunteer(volunteerId);
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
    } catch (error) {
      console.error('Error enabling volunteer:', error);
      alert('Error enabling volunteer. Please try again.');
    }
  };

  // Filter volunteers based on search term and status
  const filteredVolunteers = transformedVolunteers.filter(volunteer => {
    const matchesSearch = volunteer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         volunteer.email.toLowerCase().includes(searchTerm.toLowerCase());
    
    let matchesStatus = statusFilter === '';
    if (!matchesStatus) {
      if (statusFilter === 'pending') {
        matchesStatus = volunteer.status === 'pending';
      } else if (statusFilter === 'accepted') {
        matchesStatus = volunteer.status === 'accepted';
      } else if (statusFilter === 'rejected') {
        matchesStatus = volunteer.status === 'rejected';
      } else {
        matchesStatus = volunteer.status === statusFilter;
      }
    }
    
    return matchesSearch && matchesStatus;
  });

  // Data is already sorted by backend (pending first, then active, then disabled)
  const sortedVolunteers = filteredVolunteers;

  return (
    <div className="dashboard">
      <Sidebar currentPage="volunteer" />
      
      <div className="main-content">
        <Header pageTitle="Volunteers" />
        
        <div className="content">
          <div className="user-management-container">
            
            {error && (
              <div style={{
                backgroundColor: '#C3B1E1',
                border: '1px solid #A0C4FD',
                color: '#390797',
                padding: '0.75rem 1.25rem',
                marginBottom: '1rem',
                borderRadius: '0.25rem'
              }}>
                {error}
              </div>
            )}

            {/* Search and Filters Section */}
            <div className="um-search-filters">
              <div className="um-search-row">
                <div className="um-search-box">
                  <input 
                    type="text" 
                    placeholder="Search volunteers..." 
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
                    <option value="pending">Pending</option>
                    <option value="accepted">Accepted</option>
                    <option value="rejected">Rejected</option>
                  </select>
                  
                  <select className="um-filter-select">
                    <option value="">Engaging Field</option>
                    <option value="transport">Patient Transport</option>
                    <option value="counseling">Counseling Support</option>
                    <option value="activities">Activity Organization</option>
                    <option value="meals">Meal Assistance</option>
                    <option value="technology">Technology Support</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="um-stats-grid">
              <div className="um-stat-card">
                <div className="um-stat-icon">👥</div>
                <div className="um-stat-content">
                  <h3>{totalVolunteers}</h3>
                  <p>Total Volunteers</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">✅</div>
                <div className="um-stat-content">
                  <h3>{approvedVolunteers}</h3>
                  <p>Accepted Volunteers</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">⏳</div>
                <div className="um-stat-content">
                  <h3>{pendingVolunteers}</h3>
                  <p>Pending</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{rejectedVolunteers}</h3>
                  <p>Rejected</p>
                </div>
              </div>
            </div>

            {/* Volunteers Table */}
            <div className="um-table-container">
              {loading ? (
                <div style={{ textAlign: 'center', padding: '2rem' }}>
                  <p>Loading volunteers...</p>
                </div>
              ) : error ? (
                <div style={{ textAlign: 'center', padding: '2rem', color: 'red' }}>
                  <p>{error}</p>
                </div>
              ) : (
                <table className="um-table">
                  <thead>
                    <tr>
                      <th>Name</th>
                      <th>Email</th>
                      <th>Phone Number</th>
                      <th>Gender</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {sortedVolunteers.length === 0 ? (
                      <tr>
                        <td colSpan="6" style={{ textAlign: 'center', padding: '2rem' }}>
                          No volunteers found
                        </td>
                      </tr>
                    ) : (
                      sortedVolunteers.map((volunteer) => (
                        <tr key={volunteer.id}>
                          <td className="um-name-cell">{volunteer.name}</td>
                          <td>{volunteer.email}</td>
                          <td>{volunteer.phone || 'N/A'}</td>
                          <td>{volunteer.gender || 'N/A'}</td>
                          <td>
                            <span className={`um-status-badge ${volunteer.status.toLowerCase()}`}>
                              {volunteer.status === 'accepted' ? 'Accepted' :
                               volunteer.status === 'pending' ? 'Pending' :
                               volunteer.status === 'rejected' ? 'Rejected' :
                               volunteer.status.charAt(0).toUpperCase() + volunteer.status.slice(1)}
                            </span>
                          </td>
                          <td>
                            <button 
                              className="um-btn um-btn-primary"
                              onClick={() => handleVolunteerClick(volunteer)}
                            >
                              View Details
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              )}
            </div>

            {/* Volunteer Details Modal */}
            {selectedVolunteer && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()} style={{maxWidth: '1300px', width: '90vw'}}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">🤝</div>
                      <div>
                        <h2>{selectedVolunteer.type === 'request' ? 'Volunteer Request Details' : 'Active Volunteer Details'}</h2>
                        <div className="um-modal-subtitle">
                          {selectedVolunteer.type === 'request' 
                            ? `Request ID: #${selectedVolunteer.requestId}` 
                            : `Volunteer ID: #${selectedVolunteer.volunteerId} | User ID: #${selectedVolunteer.userId}`
                          }
                        </div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Volunteer ID Image Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedVolunteer.volunteerIdImage ? `http://localhost:8080/uploads/${selectedVolunteer.volunteerIdImage}` : 'https://via.placeholder.com/1000x400/4A90E2/FFFFFF?text=ID+Not+Available'} 
                          alt="Volunteer ID"
                          style={{
                            width: '100%',
                            maxWidth: '1000px',
                            height: '400px',
                            borderRadius: '8px',
                            objectFit: 'cover',
                            border: '2px solid var(--um-primary)',
                            marginBottom: '1rem',
                            display: 'block',
                            margin: '0 auto 1rem auto',
                            boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
                          }}
                        />
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedVolunteer.name}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>Volunteer ID Document</p>
                      </div>

                      {/* Volunteer Information */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', maxWidth: '1100px', margin: '0 auto'}}>
                        <div className="um-section-header">
                          <div className="um-section-icon">👤</div>
                          <h3 className="um-section-title">Volunteer Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Name</span>
                          <span className="um-detail-value">{selectedVolunteer.name}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Email</span>
                          <span className="um-detail-value">{selectedVolunteer.email}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Phone Number</span>
                          <span className="um-detail-value">{selectedVolunteer.phone || 'N/A'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Gender</span>
                          <span className="um-detail-value">{selectedVolunteer.gender || 'N/A'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedVolunteer.status.toLowerCase()}`}>
                            {selectedVolunteer.status === 'accepted' ? 'Accepted' :
                             selectedVolunteer.status === 'pending' ? 'Pending' :
                             selectedVolunteer.status === 'rejected' ? 'Rejected' :
                             selectedVolunteer.status.charAt(0).toUpperCase() + selectedVolunteer.status.slice(1)}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">
                            {selectedVolunteer.type === 'request' ? 'Request Date' : 'Join Date'}
                          </span>
                          <span className="um-detail-value">
                            {selectedVolunteer.createdAt ? new Date(selectedVolunteer.createdAt).toLocaleDateString() : 'N/A'}
                          </span>
                        </div>
                        {selectedVolunteer.type === 'volunteer' && (
                          <>
                            <div className="um-detail-row">
                              <span className="um-detail-label">City</span>
                              <span className="um-detail-value">{selectedVolunteer.city}</span>
                            </div>
                            <div className="um-detail-row">
                              <span className="um-detail-label">Birth Date</span>
                              <span className="um-detail-value">{selectedVolunteer.birthdate}</span>
                            </div>
                            <div className="um-detail-row">
                              <span className="um-detail-label">Account Type</span>
                              <span className="um-detail-value">Active Volunteer</span>
                            </div>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    {selectedVolunteer.status === 'pending' && showPasswordInput && (
                      <div className="um-password-section" style={{ marginBottom: '1rem' }}>
                        <label htmlFor="volunteerPassword" style={{ display: 'block', marginBottom: '0.5rem', fontWeight: '600' }}>
                          Create Password for Volunteer:
                        </label>
                        <input
                          type="password"
                          id="volunteerPassword"
                          value={volunteerPassword}
                          onChange={(e) => setVolunteerPassword(e.target.value)}
                          placeholder="Enter password for volunteer account"
                          style={{
                            width: '100%',
                            padding: '0.75rem',
                            border: '1px solid #A0C4FD',
                            borderRadius: '6px',
                            fontSize: '0.875rem'
                          }}
                        />
                      </div>
                    )}
                    <div className="um-modal-actions">
                      {selectedVolunteer.type === 'request' && selectedVolunteer.status === 'pending' && (
                        <>
                          <button 
                            className="um-btn um-btn-success"
                            onClick={() => handleAcceptVolunteer(selectedVolunteer.id)}
                          >
                            {showPasswordInput ? 'Confirm Accept' : 'Accept Volunteer'}
                          </button>
                          <button 
                            className="um-btn um-btn-danger"
                            onClick={() => handleRejectVolunteer(selectedVolunteer.id)}
                          >
                            Reject Volunteer
                          </button>
                        </>
                      )}
                      {selectedVolunteer.type === 'request' && selectedVolunteer.status === 'accepted' && (
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleRejectVolunteer(selectedVolunteer.id)}
                        >
                          Reject Volunteer
                        </button>
                      )}
                      {selectedVolunteer.type === 'volunteer' && selectedVolunteer.status === 'accepted' && (
                        <button 
                          className="um-btn um-btn-warning"
                          onClick={() => handleDisableVolunteer(selectedVolunteer.volunteerId)}
                        >
                          Disable Volunteer
                        </button>
                      )}
                      {selectedVolunteer.type === 'volunteer' && selectedVolunteer.status === 'pending' && (
                        <button 
                          className="um-btn um-btn-success"
                          onClick={() => handleEnableVolunteer(selectedVolunteer.volunteerId)}
                        >
                          Enable Volunteer
                        </button>
                      )}
                      {selectedVolunteer.type === 'volunteer' && selectedVolunteer.status === 'rejected' && (
                        <div style={{ padding: '1rem', textAlign: 'center', color: '#666' }}>
                          <p>This volunteer account has been rejected.</p>
                          <p>Use the User Management section to modify their account status.</p>
                        </div>
                      )}
                    </div>
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

export default Volunteer;
