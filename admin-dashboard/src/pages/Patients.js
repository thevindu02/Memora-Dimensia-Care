import React, { useState, useEffect } from 'react';
import '../styles/Patients.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';
import patientApiService from '../services/patientApiService';
import userApiService from '../services/userApiService';

const Patients = () => {
  const [selectedPatient, setSelectedPatient] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [patients, setPatients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [dementiaTypeFilter, setDementiaTypeFilter] = useState('');
  const [dementiaStageFilter, setDementiaStageFilter] = useState('');

  // Fetch patients from API
  useEffect(() => {
    fetchPatients();
  }, []);

  const fetchPatients = async () => {
    try {
      setLoading(true);
      const data = await patientApiService.getAllPatients();
      setPatients(data || []);
      setError(null);
    } catch (error) {
      console.error('Error fetching patients:', error);
      setError('Failed to load patients');
    } finally {
      setLoading(false);
    }
  };

  // Helper functions to format enum values
  const formatDementiaType = (type) => {
    if (!type) return 'N/A';
    return type.replace(/_/g, ' ')
               .toLowerCase()
               .replace(/\b\w/g, l => l.toUpperCase());
  };

  const formatDementiaStage = (stage) => {
    if (!stage) return 'N/A';
    return stage.toLowerCase()
                .replace(/\b\w/g, l => l.toUpperCase());
  };

  // Transform API data to match frontend expectations
  const transformedPatients = patients.map(patient => ({
    id: patient.patientId,
    userId: patient.userId,
    name: patient.patientName || `${patient.fName || ''} ${patient.lName || ''}`.trim(),
    dementiaType: formatDementiaType(patient.dementiaType),
    dementiaStage: formatDementiaStage(patient.dementiaStage),
    phone: patient.phoneNumber || 'N/A',
    status: patient.userStatus === 'ACTIVE' ? 'Active' : 'Disabled',
    address: `${patient.street || ''} ${patient.city || ''} ${patient.state || ''}`.trim() || 'N/A',
    gender: patient.gender || 'N/A',
    age: patient.patientAge || 'N/A',
    profilePicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=PT',
    guardian: patient.guardianName ? {
      name: patient.guardianName,
      address: patient.guardianCity || 'N/A',
      phone: patient.guardianPhone || 'N/A'
    } : null,
    email: patient.email || 'N/A',
    birthdate: patient.birthdate || 'N/A',
    dateOfDiagnosis: patient.dateOfDiagnosis || 'N/A',
    relationship: patient.relationship || 'N/A'
  }));

  // Filter patients
  const filteredPatients = transformedPatients.filter(patient => {
    const matchesSearch = patient.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         patient.phone.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         patient.email.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesStatus = statusFilter === '' || patient.status.toLowerCase() === statusFilter.toLowerCase();
    const matchesDementiaType = dementiaTypeFilter === '' || patient.dementiaType.toLowerCase().includes(dementiaTypeFilter.toLowerCase());
    const matchesDementiaStage = dementiaStageFilter === '' || patient.dementiaStage.toLowerCase() === dementiaStageFilter.toLowerCase();
    
    return matchesSearch && matchesStatus && matchesDementiaType && matchesDementiaStage;
  });

  const totalPatients = transformedPatients.length;
  const activePatients = transformedPatients.filter(patient => patient.status === 'Active').length;
  const disabledPatients = transformedPatients.filter(patient => patient.status === 'Disabled').length;

  const handlePatientClick = (patient) => {
    setSelectedPatient(patient);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedPatient(null);
  };

  const handleDisablePatient = async () => {
    try {
      if (!selectedPatient || !selectedPatient.userId) {
        alert('Error: Patient information not available');
        return;
      }

      await userApiService.updateUserStatus(selectedPatient.userId, 'INACTIVE');
      alert(`Patient ${selectedPatient.name} status updated to Inactive successfully`);
      
      // Refresh the patient list to show updated status
      fetchPatients();
      handleCloseModal();
    } catch (error) {
      console.error('Error updating patient status:', error);
      alert('Error updating patient status: ' + error.message);
    }
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="patients" />
      
      <div className="main-content">
        <Header pageTitle="Patients" />
        
        <div className="content">
          <div className="user-management-container">
            {/* Search and Filters Section */}
            <div className="um-search-filters">
              <div className="um-search-row">
                <div className="um-search-box">
                  <input 
                    type="text" 
                    placeholder="Search patients..." 
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
                    value={dementiaTypeFilter}
                    onChange={(e) => setDementiaTypeFilter(e.target.value)}
                  >
                    <option value="">Dementia Type</option>
                    <option value="alzheimer">Alzheimer's</option>
                    <option value="vascular">Vascular</option>
                    <option value="lewy">Lewy Body</option>
                    <option value="frontotemporal">Frontotemporal</option>
                    <option value="parkinson">Parkinson's</option>
                  </select>
                  
                  <select 
                    className="um-filter-select"
                    value={dementiaStageFilter}
                    onChange={(e) => setDementiaStageFilter(e.target.value)}
                  >
                    <option value="">Dementia Stage</option>
                    <option value="mild">Mild</option>
                    <option value="moderate">Moderate</option>
                    <option value="severe">Severe</option>
                    <option value="very severe">Very Severe</option>
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
                Loading patients...
              </div>
            )}

            {/* Stats Cards */}
            <div className="um-stats-grid">
              <div className="um-stat-card">
                <div className="um-stat-icon">👥</div>
                <div className="um-stat-content">
                  <h3>{totalPatients}</h3>
                  <p>Total Patients</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">✅</div>
                <div className="um-stat-content">
                  <h3>{activePatients}</h3>
                  <p>Active Patients</p>
                </div>
              </div>
              
              <div className="um-stat-card">
                <div className="um-stat-icon">❌</div>
                <div className="um-stat-content">
                  <h3>{disabledPatients}</h3>
                  <p>Disabled Patients</p>
                </div>
              </div>
            </div>

            {/* Patients Table */}
            <div className="um-table-container">
              <table className="um-table">
                <thead>
                  <tr>
                    <th>Patient Name</th>
                    <th>Dementia Type</th>
                    <th>Dementia Stage</th>
                    <th>Phone Number</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {!loading && filteredPatients.map(patient => (
                    <tr key={patient.id}>
                      <td className="um-name-cell">{patient.name}</td>
                      <td>{patient.dementiaType}</td>
                      <td>{patient.dementiaStage}</td>
                      <td>{patient.phone}</td>
                      <td>
                        <span className={`um-status-badge ${patient.status.toLowerCase()}`}>
                          {patient.status}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="um-btn um-btn-primary"
                          onClick={() => handlePatientClick(patient)}
                        >
                          View Details
                        </button>
                      </td>
                    </tr>
                  ))}
                  {!loading && filteredPatients.length === 0 && (
                    <tr>
                      <td colSpan="6" style={{ textAlign: 'center', padding: '2rem', color: '#666' }}>
                        No patients found
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* Patient Details Modal */}
            {showModal && selectedPatient && (
              <div className="um-modal-overlay" onClick={handleCloseModal}>
                <div className="um-modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="um-modal-header">
                    <div className="um-modal-title">
                      <div className="um-modal-icon">👤</div>
                      <div>
                        <h2>Patient Details</h2>
                        <div className="um-modal-subtitle">ID: #{selectedPatient.id}</div>
                      </div>
                    </div>
                    <button className="um-modal-close" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="um-modal-body">
                    <div className="um-details-grid">
                      {/* Profile Picture Section */}
                      <div className="um-detail-section" style={{gridColumn: '1 / -1', textAlign: 'center', marginBottom: '2rem'}}>
                        <img 
                          src={selectedPatient.profilePicture} 
                          alt={selectedPatient.name}
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
                        <h3 style={{margin: '0', color: 'var(--um-gray-800)'}}>{selectedPatient.name}</h3>
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>{selectedPatient.dementiaType} - {selectedPatient.dementiaStage} Stage</p>
                      </div>

                      {/* Basic Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">📋</div>
                          <h3 className="um-section-title">Basic Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Full Name</span>
                          <span className="um-detail-value">{selectedPatient.name}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Age</span>
                          <span className="um-detail-value">{selectedPatient.age}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Gender</span>
                          <span className="um-detail-value">{selectedPatient.gender}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Phone</span>
                          <span className="um-detail-value">{selectedPatient.phone}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedPatient.status.toLowerCase()}`}>
                            {selectedPatient.status}
                          </span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Address</span>
                          <span className="um-detail-value">{selectedPatient.address}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Email</span>
                          <span className="um-detail-value">{selectedPatient.email}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Date of Birth</span>
                          <span className="um-detail-value">{selectedPatient.birthdate}</span>
                        </div>
                      </div>

                      {/* Medical Information */}
                      <div className="um-detail-section">
                        <div className="um-section-header">
                          <div className="um-section-icon">🏥</div>
                          <h3 className="um-section-title">Medical Information</h3>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Dementia Type</span>
                          <span className="um-detail-value">{selectedPatient.dementiaType}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Dementia Stage</span>
                          <span className="um-detail-value">{selectedPatient.dementiaStage}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Date of Diagnosis</span>
                          <span className="um-detail-value">{selectedPatient.dateOfDiagnosis}</span>
                        </div>
                      </div>

                      {/* Guardian Information */}
                      {selectedPatient.guardian && (
                        <div className="um-detail-section">
                          <div className="um-section-header">
                            <div className="um-section-icon">👨‍👩‍👧‍👦</div>
                            <h3 className="um-section-title">Guardian Information</h3>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Name</span>
                            <span className="um-detail-value">{selectedPatient.guardian.name}</span>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Phone</span>
                            <span className="um-detail-value">{selectedPatient.guardian.phone}</span>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Address</span>
                            <span className="um-detail-value">{selectedPatient.guardian.address}</span>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Relationship</span>
                            <span className="um-detail-value">{selectedPatient.relationship}</span>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    <div className="um-modal-actions">
                      <button className="um-btn um-btn-danger" onClick={handleDisablePatient}>
                        Set as Inactive
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

export default Patients;