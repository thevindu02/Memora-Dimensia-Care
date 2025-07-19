import React, { useState } from 'react';
import '../styles/Caregiver.css';
import '../styles/UserManagement.css';
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
    email: 'kumari.perera@gmail.com',
    phone: '+94 77 123 4567', 
    address: '45 Galle Road, Colombo 03', 
    birthday: '1988-03-15',
    age: 35,
    gender: 'Female',
    experience: '8 years',
    qualification: 'Certificate in Elderly Care, First Aid Certified',
    profilePicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=KP',
    patients: [
      { name: 'W.A. Silva', condition: 'Alzheimer\'s Stage 2' },
      { name: 'K.D. Fernando', condition: 'Vascular Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 2, 
    name: 'Saman Rajapaksa',
    email: 'saman.rajapaksa@yahoo.com',
    phone: '+94 71 234 5678', 
    address: '78 Kandy Road, Maharagama', 
    birthday: '1981-07-22',
    age: 42,
    gender: 'Male',
    experience: '12 years',
    qualification: 'Diploma in Care Giving, CPR Certified',
    profilePicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=SR',
    patients: [
      { name: 'H.M. Jayawardena', condition: 'Early Alzheimer\'s' }
    ],
    status: 'Active' 
  },
  { 
    id: 3, 
    name: 'Nimalka Wijesinghe',
    email: 'nimalka.w@hotmail.com',
    phone: '+94 76 345 6789', 
    address: '156 High Level Road, Nugegoda', 
    birthday: '1985-11-08',
    age: 38,
    gender: 'Female',
    experience: '10 years',
    qualification: 'Certificate in Dementia Care, Basic Medical Training',
    profilePicture: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=NW',
    patients: [
      { name: 'P.B. Mendis', condition: 'Lewy Body Dementia' },
      { name: 'S.A. Gunawardena', condition: 'Frontotemporal Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 4, 
    name: 'Ruwan Dissanayake',
    email: 'ruwan.d@gmail.com',
    phone: '+94 70 456 7890', 
    address: '89 Malabe Road, Kaduwela', 
    birthday: '1978-12-03',
    age: 45,
    gender: 'Male',
    experience: '15 years',
    qualification: 'Advanced Care Certificate, Mental Health Support Training',
    profilePicture: 'https://via.placeholder.com/150/9B59B6/FFFFFF?text=RD',
    patients: [],
    status: 'Disabled' 
  },
  { 
    id: 5, 
    name: 'Chaminda Bandara',
    email: 'chaminda.bandara@outlook.com',
    phone: '+94 75 567 8901', 
    address: '234 Gampaha Road, Kiribathgoda', 
    birthday: '1990-05-18',
    age: 33,
    gender: 'Male',
    experience: '6 years',
    qualification: 'Certificate in Elder Care, Basic Health Monitoring',
    profilePicture: 'https://via.placeholder.com/150/F39C12/FFFFFF?text=CB',
    patients: [
      { name: 'M.H. Rathnayake', condition: 'Moderate Alzheimer\'s' },
      { name: 'A.P. Amarasinghe', condition: 'Vascular Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 6, 
    name: 'Sanduni Wickramasinghe',
    email: 'sanduni.w@live.com',
    phone: '+94 78 678 9012', 
    address: '67 Moratuwa Road, Piliyandala', 
    birthday: '1994-09-25',
    age: 29,
    gender: 'Female',
    experience: '4 years',
    qualification: 'Personal Care Assistant Training, First Aid Certified',
    profilePicture: 'https://via.placeholder.com/150/E74C3C/FFFFFF?text=SW',
    patients: [
      { name: 'T.B. Samaraweera', condition: 'Early Stage Dementia' }
    ],
    status: 'Active' 
  },
  { 
    id: 7, 
    name: 'Pradeep Jayasuriya',
    email: 'pradeep.j@gmail.com',
    phone: '+94 72 789 0123', 
    address: '123 Kelaniya Road, Peliyagoda', 
    birthday: '1982-04-12',
    age: 41,
    gender: 'Male',
    experience: '13 years',
    qualification: 'Home Care Training, Medication Management Certified',
    profilePicture: 'https://via.placeholder.com/150/3498DB/FFFFFF?text=PJ',
    patients: [],
    status: 'Disabled' 
  },
  { 
    id: 8, 
    name: 'Madushani Senanayake',
    email: 'madushani.sen@yahoo.com',
    phone: '+94 74 890 1234', 
    address: '345 Ratnapura Road, Homagama', 
    birthday: '1987-08-30',
    age: 36,
    gender: 'Female',
    experience: '9 years',
    qualification: 'Certified Nursing Assistant, Dementia Care Specialist',
    profilePicture: 'https://via.placeholder.com/150/1ABC9C/FFFFFF?text=MS',
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
          <div className="user-management-container">
            {/* Search Section */}
            <div className="um-search-filters">
              <div className="um-search-row">
                <div className="um-search-box">
                  <input 
                    type="text" 
                    placeholder="Search caregivers..." 
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
                    <option value="">Experience Level</option>
                    <option value="0-5">0-5 years</option>
                    <option value="5-10">5-10 years</option>
                    <option value="10+">10+ years</option>
                  </select>
                  
                  <select className="um-filter-select">
                    <option value="">Patient Load</option>
                    <option value="available">Available</option>
                    <option value="partial">Partially Full</option>
                    <option value="full">Full Capacity</option>
                  </select>
                </div>
              </div>
            </div>

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
                  {caregiversData.map(caregiver => (
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
                                <span className="um-detail-value" style={{color: '#28a745'}}>
                                  ✨ {2 - selectedCaregiver.patients.length} slot(s) available
                                </span>
                              </div>
                            )}
                          </div>
                        ) : (
                          <div className="um-detail-row">
                            <span className="um-detail-label">Patient Assignment</span>
                            <span className="um-detail-value" style={{color: '#28a745'}}>
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
