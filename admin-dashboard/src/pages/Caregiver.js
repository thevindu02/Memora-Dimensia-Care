import React, { useState, useEffect } from 'react';
import '../styles/Caregiver.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';
import caregiverApiService from '../services/caregiverApiService';
import userApiService from '../services/userApiService';

const Caregiver = () => {
  const [selectedCaregiver, setSelectedCaregiver] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [caregivers, setCaregivers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [experienceFilter, setExperienceFilter] = useState('');

  // Fetch caregivers from API
  useEffect(() => {
    fetchCaregivers();
  }, []);

  const fetchCaregivers = async () => {
    try {
      setLoading(true);
      const data = await caregiverApiService.getAllCaregivers();
      setCaregivers(data || []);
      setError(null);
    } catch (error) {
      console.error('Error fetching caregivers:', error);
      setError('Failed to load caregivers');
    } finally {
      setLoading(false);
    }
  };

  // Helper function to calculate age
  const calculateAge = (birthdate) => {
    if (!birthdate) return 'N/A';
    const birth = new Date(birthdate);
    const today = new Date();
    let age = today.getFullYear() - birth.getFullYear();
    const monthDiff = today.getMonth() - birth.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
      age--;
    }
    return age;
  };

  // Transform API data to match frontend expectations
  const transformedCaregivers = caregivers.map(caregiver => ({
    id: caregiver.caregiverId,
    userId: caregiver.userId,
    name: caregiver.name || `${caregiver.fName || ''} ${caregiver.lName || ''}`.trim(),
    email: caregiver.email || 'N/A',
    phone: caregiver.phoneNumber || 'N/A',
    address: caregiver.address || 'N/A',
    birthday: caregiver.birthdate || 'N/A',
    age: calculateAge(caregiver.birthdate),
    gender: caregiver.gender || 'N/A',
    experience: caregiver.experience || 'N/A',
    qualification: caregiver.qualifications || 'N/A',
    profilePicture: caregiver.profilePic || 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=CG',
    patients: [], // We'll assume empty for now, can be populated from connections
    status: caregiver.status === 'ACTIVE' ? 'Active' : 'Disabled',
    skills: caregiver.skills || []
  }));

  // Filter caregivers
  const filteredCaregivers = transformedCaregivers.filter(caregiver => {
    const matchesSearch = caregiver.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         caregiver.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         caregiver.phone.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesStatus = statusFilter === '' || caregiver.status.toLowerCase() === statusFilter.toLowerCase();
    
    const matchesExperience = experienceFilter === '' || 
      (experienceFilter === '0-5' && /^[0-5]/.test(caregiver.experience)) ||
      (experienceFilter === '5-10' && /^[5-9]|^10/.test(caregiver.experience)) ||
      (experienceFilter === '10+' && /^1[0-9]|^[2-9][0-9]/.test(caregiver.experience));
    
    return matchesSearch && matchesStatus && matchesExperience;
  });

  const totalCaregivers = transformedCaregivers.length;
  const activeCaregivers = transformedCaregivers.filter(caregiver => caregiver.status === 'Active').length;
  const disabledCaregivers = transformedCaregivers.filter(caregiver => caregiver.status === 'Disabled').length;

  const handleRowClick = (caregiver) => {
    setSelectedCaregiver(caregiver);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedCaregiver(null);
  };

  const handleDisableCaregiver = async () => {
    try {
      if (!selectedCaregiver || !selectedCaregiver.userId) {
        alert('Error: Caregiver information not available');
        return;
      }

      await userApiService.updateUserStatus(selectedCaregiver.userId, 'INACTIVE');
      alert(`Caregiver ${selectedCaregiver.name} status updated to Inactive successfully`);
      
      // Refresh the caregiver list to show updated status
      fetchCaregivers();
      handleCloseModal();
    } catch (error) {
      console.error('Error updating caregiver status:', error);
      alert('Error updating caregiver status: ' + error.message);
    }
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="caregiver" />
      
      <div className="main-content">
        <Header pageTitle="Caregivers" />
        
        <div className="content">
          <div className="user-management-container">
            {/* Search Section */}
            <div className="um-search-filters">
              <div className="um-search-row">
                <div className="um-search-box">
                  <input 
                    type="text" 
                    placeholder="Search caregivers..." 
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
                    <option value="disabled">Disabled</option>
                  </select>
                  
                  <select 
                    className="um-filter-select"
                    value={experienceFilter}
                    onChange={(e) => setExperienceFilter(e.target.value)}
                  >
                    <option value="">Experience Level</option>
                    <option value="0-5">0-5 years</option>
                    <option value="5-10">5-10 years</option>
                    <option value="10+">10+ years</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Error Display */}
            {error && (
              <div style={{
                backgroundColor: '#ffebee',
                border: '1px solid #f44336',
                color: '#c62828',
                padding: '1rem',
                borderRadius: '4px',
                marginBottom: '1rem'
              }}>
                {error}
              </div>
            )}

            {/* Loading Display */}
            {loading && (
              <div style={{
                textAlign: 'center',
                padding: '2rem',
                color: '#666'
              }}>
                Loading caregivers...
              </div>
            )}

            {/* Stats Cards Section */}
            <div className="um-stats-grid">
              <div className="um-stat-card">
                <div className="um-stat-icon">👩‍⚕️</div>
                <div className="um-stat-content">
                  <h3>{totalCaregivers}</h3>
                  <p>Total Caregivers</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">✅</div>
                <div className="um-stat-content">
                  <h3>{activeCaregivers}</h3>
                  <p>Active Caregivers</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{disabledCaregivers}</h3>
                  <p>Disabled Caregivers</p>
                </div>
              </div>
            </div>

            {/* Caregivers Table */}
            <div className="um-table-container">
              <table className="um-table">
                <thead>
                  <tr>
                    <th>Full Name</th>
                    <th>Experience</th>
                    <th>Gender</th>
                    <th>Phone Number</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {!loading && filteredCaregivers.map(caregiver => (
                    <tr key={caregiver.id}>
                      <td className="um-name-cell">{caregiver.name}</td>
                      <td>{caregiver.experience}</td>
                      <td>{caregiver.gender}</td>
                      <td>{caregiver.phone}</td>
                      <td>
                        <span className={`um-status-badge ${caregiver.status.toLowerCase()}`}>
                          {caregiver.status}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="um-btn um-btn-primary"
                          onClick={() => handleRowClick(caregiver)}
                        >
                          View Details
                        </button>
                      </td>
                    </tr>
                  ))}
                  {!loading && filteredCaregivers.length === 0 && (
                    <tr>
                      <td colSpan="6" style={{ textAlign: 'center', padding: '2rem', color: '#666' }}>
                        No caregivers found
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* Caregiver Details Modal */}
            {showModal && selectedCaregiver && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">👩‍⚕️</div>
                      <div>
                        <h2>Caregiver Details</h2>
                        <div className="um-modal-subtitle">ID: #{selectedCaregiver.id}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedCaregiver.profilePicture} 
                          alt={selectedCaregiver.name}
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
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedCaregiver.name}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>{selectedCaregiver.qualification}</p>
                      </div>

                      {/* Personal Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">👤</div>
                          <h3 className="um-section-title">Personal Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Full Name</span>
                          <span className="um-detail-value">{selectedCaregiver.name}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Email</span>
                          <span className="um-detail-value">{selectedCaregiver.email}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Phone Number</span>
                          <span className="um-detail-value">{selectedCaregiver.phone}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Birthday</span>
                          <span className="um-detail-value">{new Date(selectedCaregiver.birthday).toLocaleDateString()}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Gender</span>
                          <span className="um-detail-value">{selectedCaregiver.gender}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Address</span>
                          <span className="um-detail-value">{selectedCaregiver.address}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedCaregiver.status.toLowerCase()}`}>
                            {selectedCaregiver.status}
                          </span>
                        </div>
                      </div>

                      {/* Professional Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">🎓</div>
                          <h3 className="um-section-title">Professional Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Experience</span>
                          <span className="um-detail-value">{selectedCaregiver.experience}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Qualifications</span>
                          <span className="um-detail-value">{selectedCaregiver.qualification}</span>
                        </div>
                        {selectedCaregiver.skills && selectedCaregiver.skills.length > 0 && (
                          <div className="um-detail-row">
                            <span className="um-detail-label">Skills</span>
                            <span className="um-detail-value">{selectedCaregiver.skills.join(', ')}</span>
                          </div>
                        )}
                        <div className="um-detail-row">
                          <span className="um-detail-label">Active Patients</span>
                          <span className="um-detail-value">{selectedCaregiver.patients.length}/2</span>
                        </div>
                      </div>

                      {/* Assigned Patients */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1'}}>
                        <div className="um-section-header">
                          <div className="um-section-icon">🏥</div>
                          <h3 className="um-section-title">Assigned Patients ({selectedCaregiver.patients.length}/2)</h3>
                        </div>
                        {selectedCaregiver.patients.length > 0 ? (
                          <div className="um-patients-list">
                            {selectedCaregiver.patients.map((patient, index) => (
                              <div key={index} className="um-detail-row">
                                <span className="um-detail-label">{patient.name}</span>
                                <span className="um-detail-value">{patient.condition}</span>
                              </div>
                            ))}
                            {selectedCaregiver.patients.length < 2 && (
                              <div className="um-detail-row">
                                <span className="um-detail-label">Available Slots</span>
                                <span className="um-detail-value" style={{color: '#2B3F99'}}>
                                  ✨ {2 - selectedCaregiver.patients.length} slot(s) available
                                </span>
                              </div>
                            )}
                          </div>
                        ) : (
                          <div className="um-detail-row">
                            <span className="um-detail-label">Patient Assignment</span>
                            <span className="um-detail-value" style={{color: '#2B3F99'}}>
                              📋 Available for 2 patients
                            </span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    <div className="um-modal-actions">
                      <button 
                        className="um-btn um-btn-danger"
                        onClick={handleDisableCaregiver}
                        disabled={selectedCaregiver.status === 'Disabled'}
                      >
                        {selectedCaregiver.status === 'Disabled' ? 'Already Inactive' : 'Set as Inactive'}
                      </button>
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

export default Caregiver;