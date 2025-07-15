import React, { useState } from 'react';
import '../styles/Caregiver.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample caregiver data with Sri Lankan details
const caregiversData = [
  { 
    id: 1, 
    name: 'Kumari Perera', 
    phone: '+94 77 123 4567', 
    address: '45 Galle Road, Colombo 03', 
    age: 35,
    gender: 'Female',
    experience: '8 years',
    qualification: 'Certificate in Elderly Care, First Aid Certified',
    patients: [
      { name: 'W.A. Silva', condition: 'Alzheimer\'s Stage 2' },
      { name: 'K.D. Fernando', condition: 'Vascular Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 2, 
    name: 'Saman Rajapaksa', 
    phone: '+94 71 234 5678', 
    address: '78 Kandy Road, Maharagama', 
    age: 42,
    gender: 'Male',
    experience: '12 years',
    qualification: 'Diploma in Care Giving, CPR Certified',
    patients: [
      { name: 'H.M. Jayawardena', condition: 'Early Alzheimer\'s' }
    ],
    status: 'Active' 
  },
  { 
    id: 3, 
    name: 'Nimalka Wijesinghe', 
    phone: '+94 76 345 6789', 
    address: '156 High Level Road, Nugegoda', 
    age: 38,
    gender: 'Female',
    experience: '10 years',
    qualification: 'Certificate in Dementia Care, Basic Medical Training',
    patients: [
      { name: 'P.B. Mendis', condition: 'Lewy Body Dementia' },
      { name: 'S.A. Gunawardena', condition: 'Frontotemporal Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 4, 
    name: 'Ruwan Dissanayake', 
    phone: '+94 70 456 7890', 
    address: '89 Malabe Road, Kaduwela', 
    age: 45,
    gender: 'Male',
    experience: '15 years',
    qualification: 'Advanced Care Certificate, Mental Health Support Training',
    patients: [],
    status: 'Disabled' 
  },
  { 
    id: 5, 
    name: 'Chaminda Bandara', 
    phone: '+94 75 567 8901', 
    address: '234 Gampaha Road, Kiribathgoda', 
    age: 33,
    gender: 'Male',
    experience: '6 years',
    qualification: 'Certificate in Elder Care, Basic Health Monitoring',
    patients: [
      { name: 'M.H. Rathnayake', condition: 'Moderate Alzheimer\'s' },
      { name: 'A.P. Amarasinghe', condition: 'Vascular Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 6, 
    name: 'Sanduni Wickramasinghe', 
    phone: '+94 78 678 9012', 
    address: '67 Moratuwa Road, Piliyandala', 
    age: 29,
    gender: 'Female',
    experience: '4 years',
    qualification: 'Personal Care Assistant Training, First Aid Certified',
    patients: [
      { name: 'T.B. Samaraweera', condition: 'Early Stage Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 7, 
    name: 'Pradeep Jayasuriya', 
    phone: '+94 72 789 0123', 
    address: '123 Kelaniya Road, Peliyagoda', 
    age: 41,
    gender: 'Male',
    experience: '13 years',
    qualification: 'Home Care Training, Medication Management Certified',
    patients: [],
    status: 'Disabled' 
  },
  { 
    id: 8, 
    name: 'Madushani Senanayake', 
    phone: '+94 74 890 1234', 
    address: '345 Ratnapura Road, Homagama', 
    age: 36,
    gender: 'Female',
    experience: '9 years',
    qualification: 'Certified Nursing Assistant, Dementia Care Specialist',
    patients: [
      { name: 'D.S. Liyanage', condition: 'Mixed Dementia' },
      { name: 'C.K. Weerasinghe', condition: 'Alzheimer\'s Stage 1' }
    ],
    status: 'Active' 
  }
];

const Caregiver = () => {
  const [selectedCaregiver, setSelectedCaregiver] = useState(null);
  const [showModal, setShowModal] = useState(false);

  const totalCaregivers = caregiversData.length;
  const activeCaregivers = caregiversData.filter(caregiver => caregiver.status === 'Active').length;
  const disabledCaregivers = caregiversData.filter(caregiver => caregiver.status === 'Disabled').length;

  const handleRowClick = (caregiver) => {
    setSelectedCaregiver(caregiver);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedCaregiver(null);
  };

  const handleDisableCaregiver = () => {
    // UI only - no backend functionality
    alert(`Caregiver ${selectedCaregiver.name} has been disabled (UI only)`);
    handleCloseModal();
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="caregiver" />
      
      <div className="main-content">
        <Header pageTitle="Caregivers" />
        
        <div className="content">
          <div className="caregivers-page">
            {/* Search Section */}
            <div className="search-section">
              <div className="search-box">
                <input 
                  type="text" 
                  placeholder="Search caregivers..." 
                  className="search-input"
                />
                <span className="search-icon">🔍</span>
              </div>
            </div>

            {/* Stats Cards Section */}
            <div className="stats-cards">
              <div className="stat-card">
                <div className="stat-icon">👩‍⚕️</div>
                <div className="stat-content">
                  <div className="stat-number">{totalCaregivers}</div>
                  <div className="stat-label">Total Caregivers</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <div className="stat-number">{activeCaregivers}</div>
                  <div className="stat-label">Active Caregivers</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">❌</div>
                <div className="stat-content">
                  <div className="stat-number">{disabledCaregivers}</div>
                  <div className="stat-label">Disabled Caregivers</div>
                </div>
              </div>
            </div>

            {/* Caregivers Table */}
            <div className="table-container">
              <table className="caregivers-table">
                <thead>
                  <tr>
                    <th>Caregiver Name</th>
                    <th>Phone Number</th>
                    <th>Address</th>
                    <th>Number of Patients</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {caregiversData.map(caregiver => (
                    <tr 
                      key={caregiver.id}
                      onClick={() => handleRowClick(caregiver)}
                      className="clickable-row"
                    >
                      <td className="caregiver-name">{caregiver.name}</td>
                      <td>{caregiver.phone}</td>
                      <td>{caregiver.address}</td>
                      <td>{caregiver.patients.length}</td>
                      <td>
                        <span className={`status-badge ${caregiver.status.toLowerCase()}`}>
                          {caregiver.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Caregiver Details Modal */}
            {showModal && selectedCaregiver && (
              <div className="modal-overlay" onClick={handleCloseModal}>
                <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-header">
                    <h2>Caregiver Details</h2>
                    <button className="close-btn" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="modal-body">
                    <div className="details-grid">
                      {/* Basic Information */}
                      <div className="details-section">
                        <h3>Personal Information</h3>
                        <div className="detail-item">
                          <span className="detail-label">Name:</span>
                          <span className="detail-value">{selectedCaregiver.name}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Age:</span>
                          <span className="detail-value">{selectedCaregiver.age} years</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Gender:</span>
                          <span className="detail-value">{selectedCaregiver.gender}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Phone:</span>
                          <span className="detail-value">{selectedCaregiver.phone}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Address:</span>
                          <span className="detail-value">{selectedCaregiver.address}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Status:</span>
                          <span className={`detail-badge ${selectedCaregiver.status.toLowerCase()}`}>
                            {selectedCaregiver.status}
                          </span>
                        </div>
                      </div>

                      {/* Professional Information */}
                      <div className="details-section">
                        <h3>Professional Information</h3>
                        <div className="detail-item">
                          <span className="detail-label">Experience:</span>
                          <span className="detail-value">{selectedCaregiver.experience}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Training & Certifications:</span>
                          <span className="detail-value">{selectedCaregiver.qualification}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Active Patients:</span>
                          <span className="detail-value">{selectedCaregiver.patients.length}/2</span>
                        </div>
                      </div>

                      {/* Assigned Patients */}
                      <div className="details-section full-width">
                        <h3>Assigned Patients ({selectedCaregiver.patients.length}/2)</h3>
                        {selectedCaregiver.patients.length > 0 ? (
                          <div className="patients-list">
                            {selectedCaregiver.patients.map((patient, index) => (
                              <div key={index} className="patient-item">
                                <div className="patient-name">{patient.name}</div>
                                <div className="patient-condition">{patient.condition}</div>
                              </div>
                            ))}
                            {selectedCaregiver.patients.length < 2 && (
                              <div className="available-slot">
                                <span className="slot-text">Available slot for 1 more patient</span>
                              </div>
                            )}
                          </div>
                        ) : (
                          <div className="no-patients">
                            <span>No patients assigned. Available for 2 patients.</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="modal-footer">
                    <button className="btn-secondary" onClick={handleCloseModal}>
                      Close
                    </button>
                    <button 
                      className="btn-danger" 
                      onClick={handleDisableCaregiver}
                      disabled={selectedCaregiver.status === 'Disabled'}
                    >
                      {selectedCaregiver.status === 'Disabled' ? 'Already Disabled' : 'Disable Caregiver'}
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
