import React, { useState } from 'react';
import '../styles/Patients.css';
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
          <div className="patients-page">
            {/* Search and Filters Section */}
            <div className="search-filters-section">
              <div className="search-box">
                <input 
                  type="text" 
                  placeholder="Search patients..." 
                  className="search-input"
                />
                <span className="search-icon">🔍</span>
              </div>
              
              <div className="filters-section">
                <select className="filter-dropdown">
                  <option value="">Status</option>
                  <option value="active">Active</option>
                  <option value="disabled">Disabled</option>
                </select>
                
                <select className="filter-dropdown">
                  <option value="">Dementia Type</option>
                  <option value="alzheimers">Alzheimer's</option>
                  <option value="vascular">Vascular</option>
                  <option value="lewy">Lewy Body</option>
                  <option value="frontotemporal">Frontotemporal</option>
                </select>
                
                <select className="filter-dropdown">
                  <option value="">Dementia Stage</option>
                  <option value="early">Early</option>
                  <option value="moderate">Moderate</option>
                  <option value="advanced">Advanced</option>
                </select>
              </div>
            </div>

            {/* Stats Cards Section */}
            <div className="stats-cards">
              <div className="stat-card">
                <div className="stat-icon">👥</div>
                <div className="stat-content">
                  <div className="stat-number">{totalPatients}</div>
                  <div className="stat-label">Total Patients</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <div className="stat-number">{activePatients}</div>
                  <div className="stat-label">Active Patients</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">❌</div>
                <div className="stat-content">
                  <div className="stat-number">{disabledPatients}</div>
                  <div className="stat-label">Disabled Patients</div>
                </div>
              </div>
            </div>

            {/* Patients Table */}
            <div className="table-container">
              <table className="patients-table">
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
                      <td>{patient.name}</td>
                      <td>{patient.dementiaType}</td>
                      <td>{patient.dementiaStage}</td>
                      <td>{patient.phone}</td>
                      <td>
                        <span className={`status-badge ${patient.status.toLowerCase()}`}>
                          {patient.status}
                        </span>
                      </td>
                      <td>
                        <button 
                          className="view-details-btn"
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
              <div className="modal-overlay" onClick={handleCloseModal}>
                <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-header">
                    <h2>Patient Details</h2>
                    <button className="close-btn" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="modal-body">
                    {/* Patient Basic Information */}
                    <div className="details-section">
                      <h3>Basic Information</h3>
                      <div className="details-grid">
                        <div className="detail-item">
                          <label>Full Name:</label>
                          <span>{selectedPatient.name}</span>
                        </div>
                        <div className="detail-item">
                          <label>Age:</label>
                          <span>{selectedPatient.age}</span>
                        </div>
                        <div className="detail-item">
                          <label>Gender:</label>
                          <span>{selectedPatient.gender}</span>
                        </div>
                        <div className="detail-item">
                          <label>Phone:</label>
                          <span>{selectedPatient.phone}</span>
                        </div>
                        <div className="detail-item full-width">
                          <label>Address:</label>
                          <span>{selectedPatient.address}</span>
                        </div>
                      </div>
                    </div>

                    {/* Medical Information */}
                    <div className="details-section">
                      <h3>Medical Information</h3>
                      <div className="details-grid">
                        <div className="detail-item">
                          <label>Dementia Type:</label>
                          <span>{selectedPatient.dementiaType}</span>
                        </div>
                        <div className="detail-item">
                          <label>Dementia Stage:</label>
                          <span>{selectedPatient.dementiaStage}</span>
                        </div>
                        <div className="detail-item">
                          <label>Status:</label>
                          <span className={`status-badge ${selectedPatient.status.toLowerCase()}`}>
                            {selectedPatient.status}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Guardian Information */}
                    <div className="details-section">
                      <h3>Guardian Information</h3>
                      <div className="details-grid">
                        <div className="detail-item">
                          <label>Guardian Name:</label>
                          <span>{selectedPatient.guardian.name}</span>
                        </div>
                        <div className="detail-item">
                          <label>Guardian Phone:</label>
                          <span>{selectedPatient.guardian.phone}</span>
                        </div>
                        <div className="detail-item full-width">
                          <label>Guardian Address:</label>
                          <span>{selectedPatient.guardian.address}</span>
                        </div>
                      </div>
                    </div>

                    {/* Caregiver Information */}
                    <div className="details-section">
                      <h3>Caregiver Information</h3>
                      <div className="details-grid">
                        <div className="detail-item">
                          <label>Caregiver Name:</label>
                          <span>{selectedPatient.caregiver.name}</span>
                        </div>
                        <div className="detail-item">
                          <label>Caregiver Phone:</label>
                          <span>{selectedPatient.caregiver.phone}</span>
                        </div>
                        <div className="detail-item full-width">
                          <label>Caregiver Address:</label>
                          <span>{selectedPatient.caregiver.address}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="modal-footer">
                    <button className="disable-btn" onClick={handleDisablePatient}>
                      Disable Patient
                    </button>
                    <button className="close-modal-btn" onClick={handleCloseModal}>
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