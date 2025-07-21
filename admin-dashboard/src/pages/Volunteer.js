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

  // Fetch volunteer data on component mount
  useEffect(() => {
    fetchVolunteers();
  }, []);

  const fetchVolunteers = async () => {
    try {
      console.log('Fetching volunteer data...');
      setLoading(true);
      setError(null);
      const data = await volunteerApiService.getAllVolunteerRequestsWithUserData();
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
  const transformVolunteerData = (volunteer) => ({
    id: volunteer.requestId,
    name: `${volunteer.firstName} ${volunteer.lastName}`,
    email: volunteer.email,
    phone: volunteer.phoneNumber,
    gender: volunteer.gender,
    status: volunteer.requestStatus,
    createdAt: volunteer.createdAt,
    userId: volunteer.userId,
    volunteerIdImage: volunteer.volunteerIdImage,
    birthdate: volunteer.birthdate,
    city: volunteer.city,
    state: volunteer.state,
    profilePic: volunteer.profilePic
  });

  const transformedVolunteers = volunteers.map(transformVolunteerData);

  const totalVolunteers = transformedVolunteers.length;
  const approvedVolunteers = transformedVolunteers.filter(volunteer => volunteer.status === 'approved').length;
  const pendingVolunteers = transformedVolunteers.filter(volunteer => volunteer.status === 'pending').length;
  const rejectedVolunteers = transformedVolunteers.filter(volunteer => volunteer.status === 'rejected').length;

  const handleVolunteerClick = (volunteer) => {
    setSelectedVolunteer(volunteer);
  };

  const handleCloseModal = () => {
    setSelectedVolunteer(null);
  };

  const handleAcceptVolunteer = async (volunteerId) => {
    try {
      await volunteerApiService.updateVolunteerRequestStatus(volunteerId, 'approved');
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
    } catch (error) {
      console.error('Error accepting volunteer:', error);
    }
  };

  const handleRejectVolunteer = async (volunteerId) => {
    try {
      await volunteerApiService.updateVolunteerRequestStatus(volunteerId, 'rejected');
      // Refresh the data after updating
      await fetchVolunteers();
      handleCloseModal();
    } catch (error) {
      console.error('Error rejecting volunteer:', error);
    }
  };

  // Filter volunteers based on search term and status
  const filteredVolunteers = transformedVolunteers.filter(volunteer => {
    const matchesSearch = volunteer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         volunteer.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || volunteer.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  // Sort volunteers to show pending first
  const sortedVolunteers = [...filteredVolunteers].sort((a, b) => {
    if (a.status === 'pending' && b.status !== 'pending') return -1;
    if (a.status !== 'pending' && b.status === 'pending') return 1;
    return 0;
  });

  return (
    <div className="dashboard">
      <Sidebar currentPage="volunteer" />
      
      <div className="main-content">
        <Header pageTitle="Volunteers" />
        
        <div className="content">
          <div className="user-management-container">
            
            {error && (
              <div style={{
                backgroundColor: '#f8d7da',
                border: '1px solid #f5c6cb',
                color: '#721c24',
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
                    <option value="approved">Approved</option>
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
                  
                  <select className="um-filter-select">
                    <option value="">Availability</option>
                    <option value="weekdays">Weekdays</option>
                    <option value="weekends">Weekends</option>
                    <option value="flexible">Flexible</option>
                    <option value="mornings">Mornings</option>
                    <option value="afternoons">Afternoons</option>
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
                  <p>Approved Volunteers</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">⏳</div>
                <div className="um-stat-content">
                  <h3>{pendingVolunteers}</h3>
                  <p>Pending Approval</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{rejectedVolunteers}</h3>
                  <p>Rejected Volunteers</p>
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
                              {volunteer.status.charAt(0).toUpperCase() + volunteer.status.slice(1)}
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
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">🤝</div>
                      <div>
                        <h2>Volunteer Details</h2>
                        <div className="um-modal-subtitle">ID: #{selectedVolunteer.id}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedVolunteer.profilePic || 'https://via.placeholder.com/120/4A90E2/FFFFFF?text=V'} 
                          alt={selectedVolunteer.name}
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
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedVolunteer.name}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>Volunteer Request</p>
                      </div>

                      {/* Volunteer Information */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1'}}>
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
                          <span className="um-detail-label">City</span>
                          <span className="um-detail-value">{selectedVolunteer.city || 'N/A'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">State</span>
                          <span className="um-detail-value">{selectedVolunteer.state || 'N/A'}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedVolunteer.status.toLowerCase()}`}>
                            {selectedVolunteer.status.charAt(0).toUpperCase() + selectedVolunteer.status.slice(1)}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Request Date</span>
                          <span className="um-detail-value">
                            {selectedVolunteer.createdAt ? new Date(selectedVolunteer.createdAt).toLocaleDateString() : 'N/A'}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    <div className="um-modal-actions">
                      {selectedVolunteer.status === 'pending' && (
                        <>
                          <button 
                            className="um-btn um-btn-success"
                            onClick={() => handleAcceptVolunteer(selectedVolunteer.id)}
                          >
                            Accept Volunteer
                          </button>
                          <button 
                            className="um-btn um-btn-danger"
                            onClick={() => handleRejectVolunteer(selectedVolunteer.id)}
                          >
                            Reject Volunteer
                          </button>
                        </>
                      )}
                      {selectedVolunteer.status === 'approved' && (
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleRejectVolunteer(selectedVolunteer.id)}
                        >
                          Reject Volunteer
                        </button>
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
