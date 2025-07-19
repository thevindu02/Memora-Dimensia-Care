import React, { useState } from 'react';
import '../styles/Volunteer.css';
import '../styles/UserManagement.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample volunteer data with Sri Lankan details
const volunteersData = [
  { 
    id: 1, 
    name: 'Kasun Perera', 
    address: '45/A, Galle Road, Colombo 03', 
    age: 28, 
    gender: 'Male',
    phone: '077-1234567',
    engagingField: 'Patient Transport', 
    status: 'Active',
    experience: '2 years',
    availability: 'Weekends',
    email: 'kasun.perera@email.com',
    profilePicture: 'https://via.placeholder.com/150/4A90E2/FFFFFF?text=KP'
  },
  { 
    id: 2, 
    name: 'Nimali Fernando', 
    address: '23, Temple Road, Kandy', 
    age: 35, 
    gender: 'Female',
    phone: '071-2345678',
    engagingField: 'Counseling Support', 
    status: 'Pending',
    experience: '4 years',
    availability: 'Weekdays',
    email: 'nimali.fernando@email.com',
    profilePicture: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=NF'
  },
  { 
    id: 3, 
    name: 'Ruwan Silva', 
    address: '67, Station Road, Galle', 
    age: 42, 
    gender: 'Male',
    phone: '075-3456789',
    engagingField: 'Activity Organization', 
    status: 'Active',
    experience: '6 years',
    availability: 'Flexible',
    email: 'ruwan.silva@email.com',
    profilePicture: 'https://via.placeholder.com/150/50C878/FFFFFF?text=RS'
  },
  { 
    id: 4, 
    name: 'Sandani Rathnayake', 
    address: '89, Hill Street, Nuwara Eliya', 
    age: 31, 
    gender: 'Female',
    phone: '072-4567890',
    engagingField: 'Meal Assistance', 
    status: 'Disabled',
    experience: '3 years',
    availability: 'Mornings',
    email: 'sandani.rathnayake@email.com',
    profilePicture: 'https://via.placeholder.com/150/9B59B6/FFFFFF?text=SR'
  },
  { 
    id: 5, 
    name: 'Chaminda Jayasinghe', 
    address: '12, Beach Road, Negombo', 
    age: 39, 
    gender: 'Male',
    phone: '076-5678901',
    engagingField: 'Technology Support', 
    status: 'Pending',
    experience: '5 years',
    availability: 'Evenings',
    email: 'chaminda.jayasinghe@email.com',
    profilePicture: 'https://via.placeholder.com/150/F39C12/FFFFFF?text=CJ'
  },
  { 
    id: 6, 
    name: 'Malini Wickramasinghe', 
    address: '34, Market Street, Matara', 
    age: 26, 
    gender: 'Female',
    phone: '078-6789012',
    engagingField: 'Companionship', 
    status: 'Active',
    experience: '1 year',
    availability: 'Weekends',
    email: 'malini.wickramasinghe@email.com',
    profilePicture: 'https://via.placeholder.com/150/E74C3C/FFFFFF?text=MW'
  },
  { 
    id: 7, 
    name: 'Ajith Bandara', 
    address: '56, Lake Road, Kurunegala', 
    age: 45, 
    gender: 'Male',
    phone: '070-7890123',
    engagingField: 'Emergency Response', 
    status: 'Active',
    experience: '8 years',
    availability: 'On-call',
    email: 'ajith.bandara@email.com',
    profilePicture: 'https://via.placeholder.com/150/3498DB/FFFFFF?text=AB'
  },
  { 
    id: 8, 
    name: 'Priyanka Gunasekara', 
    address: '78, School Lane, Anuradhapura', 
    age: 33, 
    gender: 'Female',
    phone: '074-8901234',
    engagingField: 'Educational Support', 
    status: 'Pending',
    experience: '3 years',
    availability: 'Afternoons',
    email: 'priyanka.gunasekara@email.com',
    profilePicture: 'https://via.placeholder.com/150/1ABC9C/FFFFFF?text=PG'
  },
  { 
    id: 9, 
    name: 'Tharaka Mendis', 
    address: '90, Fort Road, Jaffna', 
    age: 29, 
    gender: 'Male',
    phone: '073-9012345',
    engagingField: 'Physical Therapy Aid', 
    status: 'Active',
    experience: '2 years',
    availability: 'Weekdays',
    email: 'tharaka.mendis@email.com',
    profilePicture: 'https://via.placeholder.com/150/8E44AD/FFFFFF?text=TM'
  },
  { 
    id: 10, 
    name: 'Shani Dissanayake', 
    address: '21, Park Avenue, Batticaloa', 
    age: 37, 
    gender: 'Female',
    phone: '079-0123456',
    engagingField: 'Administrative Support', 
    status: 'Disabled',
    experience: '4 years',
    availability: 'Mornings',
    email: 'shani.dissanayake@email.com',
    profilePicture: 'https://via.placeholder.com/150/D35400/FFFFFF?text=SD'
  }
];

const Volunteer = () => {
  const [selectedVolunteer, setSelectedVolunteer] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');

  const totalVolunteers = volunteersData.length;
  const activeVolunteers = volunteersData.filter(volunteer => volunteer.status === 'Active').length;
  const pendingVolunteers = volunteersData.filter(volunteer => volunteer.status === 'Pending').length;
  const disabledVolunteers = volunteersData.filter(volunteer => volunteer.status === 'Disabled').length;

  const handleVolunteerClick = (volunteer) => {
    setSelectedVolunteer(volunteer);
  };

  const handleCloseModal = () => {
    setSelectedVolunteer(null);
  };

  const handleAcceptVolunteer = (volunteerId) => {
    // UI only - no backend functionality
    console.log('Accept volunteer:', volunteerId);
    handleCloseModal();
  };

  const handleDisableVolunteer = (volunteerId) => {
    // UI only - no backend functionality
    console.log('Disable volunteer:', volunteerId);
    handleCloseModal();
  };

  // Filter volunteers based on search term and status
  const filteredVolunteers = volunteersData.filter(volunteer => {
    const matchesSearch = volunteer.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         volunteer.engagingField.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === '' || volunteer.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  // Sort volunteers to show pending first
  const sortedVolunteers = [...filteredVolunteers].sort((a, b) => {
    if (a.status === 'Pending' && b.status !== 'Pending') return -1;
    if (a.status !== 'Pending' && b.status === 'Pending') return 1;
    return 0;
  });

  return (
    <div className="dashboard">
      <Sidebar currentPage="volunteer" />
      
      <div className="main-content">
        <Header pageTitle="Volunteers" />
        
        <div className="content">
          <div className="user-management-container">
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
                    <option value="Active">Active</option>
                    <option value="Pending">Pending</option>
                    <option value="Disabled">Disabled</option>
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
                  <h3>{activeVolunteers}</h3>
                  <p>Active Volunteers</p>
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
                  <h3>{disabledVolunteers}</h3>
                  <p>Disabled Volunteers</p>
                </div>
              </div>
            </div>

            {/* Volunteers Table */}
            <div className="um-table-container">
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
                  {sortedVolunteers.map((volunteer) => (
                    <tr key={volunteer.id}>
                      <td className="um-name-cell">{volunteer.name}</td>
                      <td>{volunteer.email}</td>
                      <td>{volunteer.phone}</td>
                      <td>{volunteer.gender}</td>
                      <td>
                        <span className={`um-status-badge ${volunteer.status.toLowerCase()}`}>
                          {volunteer.status}
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
                  ))}
                </tbody>
              </table>
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
                          src={selectedVolunteer.profilePicture} 
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
                        <p style={{margin: '0.5rem 0 0 0', color: 'var(--um-gray-600)'}}>Volunteer</p>
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
                          <span className="um-detail-value">{selectedVolunteer.phone}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Gender</span>
                          <span className="um-detail-value">{selectedVolunteer.gender}</span>
                        </div>
                        <div className="um-detail-row">
                          <span className="um-detail-label">Status</span>
                          <span className={`um-status-badge ${selectedVolunteer.status.toLowerCase()}`}>
                            {selectedVolunteer.status}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="um-modal-footer">
                    <div className="um-modal-actions">
                      {selectedVolunteer.status === 'Pending' && (
                        <button 
                          className="um-btn um-btn-success"
                          onClick={() => handleAcceptVolunteer(selectedVolunteer.id)}
                        >
                          Accept Volunteer
                        </button>
                      )}
                      {selectedVolunteer.status === 'Active' && (
                        <button 
                          className="um-btn um-btn-danger"
                          onClick={() => handleDisableVolunteer(selectedVolunteer.id)}
                        >
                          Set as Inactive
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
