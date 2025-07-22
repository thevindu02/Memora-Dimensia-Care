import React, { useState } from 'react';
import '../styles/Patients.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Enhanced sample patient data with detailed information
const patientsData = [
  { 
    id: 1, 
    name: 'John Smith', 
    dementiaType: 'Alzheimer\'s', 
    dementiaStage: 'Early', 
    phone: '(555) 123-4567', 
    status: 'Active',
    address: '123 Oak Street, Springfield, IL 62701',
    gender: 'Male',
    age: 72,
    profilePicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=JS',
    guardian: {
      name: 'Mary Smith',
      address: '123 Oak Street, Springfield, IL 62701',
      phone: '(555) 123-4568'
    },
    caregiver: {
      name: 'Sarah Johnson',
      address: '456 Pine Avenue, Springfield, IL 62702',
      phone: '(555) 987-6543'
    }
  },
  { 
    id: 2, 
    name: 'Mary Johnson', 
    dementiaType: 'Vascular', 
    dementiaStage: 'Moderate', 
    phone: '(555) 234-5678', 
    status: 'Active',
    address: '456 Elm Street, Chicago, IL 60601',
    gender: 'Female',
    age: 68,
    profilePicture: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=MJ',
    guardian: {
      name: 'Robert Johnson',
      address: '456 Elm Street, Chicago, IL 60601',
      phone: '(555) 234-5679'
    },
    caregiver: {
      name: 'Lisa Brown',
      address: '789 Maple Drive, Chicago, IL 60602',
      phone: '(555) 876-5432'
    }
  },
  { 
    id: 3, 
    name: 'Robert Brown', 
    dementiaType: 'Lewy Body', 
    dementiaStage: 'Advanced', 
    phone: '(555) 345-6789', 
    status: 'Disabled',
    address: '789 Birch Lane, Peoria, IL 61601',
    gender: 'Male',
    age: 75,
    profilePicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=RB',
    guardian: {
      name: 'Susan Brown',
      address: '789 Birch Lane, Peoria, IL 61601',
      phone: '(555) 345-6790'
    },
    caregiver: {
      name: 'Mike Davis',
      address: '321 Cedar Road, Peoria, IL 61602',
      phone: '(555) 765-4321'
    }
  }
];

const Patients = () => {
  const [selectedPatient, setSelectedPatient] = useState(null);
  const [showModal, setShowModal] = useState(false);
  
  const totalPatients = patientsData.length;
  const activePatients = patientsData.filter(patient => patient.status === 'Active').length;
  const disabledPatients = patientsData.filter(patient => patient.status === 'Disabled').length;

  const handlePatientClick = (patient) => {
    setSelectedPatient(patient);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedPatient(null);
  };

  const handleDisablePatient = () => {
    // UI only - no backend function needed
    alert('Patient status updated to Disabled');
    handleCloseModal();
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
                  />
                  <span className="um-search-icon">🔍</span>
                </div>
                
                <div className="um-filters">
                  <select className="um-filter-select">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="disabled">Disabled</option>
                  </select>
                  
                  <select className="um-filter-select">
                    <option value="">Dementia Type</option>
                    <option value="alzheimers">Alzheimer's</option>
                    <option value="vascular">Vascular</option>
                    <option value="lewy">Lewy Body</option>
                    <option value="frontotemporal">Frontotemporal</option>
                  </select>
                  
                  <select className="um-filter-select">
                    <option value="">Dementia Stage</option>
                    <option value="early">Early</option>
                    <option value="moderate">Moderate</option>
                    <option value="advanced">Advanced</option>
                  </select>
                </div>
              </div>
            </div>

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
                  {patientsData.map(patient => (
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
                        </div>
                      )}

                      {/* Caregiver Information */}
                      {selectedPatient.caregiver && (
                        <div className="um-detail-section">
                          <div className="um-section-header">
                            <div className="um-section-icon">👩‍⚕️</div>
                            <h3 className="um-section-title">Assigned Caregiver</h3>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Name</span>
                            <span className="um-detail-value">{selectedPatient.caregiver.name}</span>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Phone</span>
                            <span className="um-detail-value">{selectedPatient.caregiver.phone}</span>
                          </div>
                          <div className="um-detail-row">
                            <span className="um-detail-label">Address</span>
                            <span className="um-detail-value">{selectedPatient.caregiver.address}</span>
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