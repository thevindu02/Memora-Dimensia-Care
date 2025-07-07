import React, { useState } from 'react';
import '../styles/Volunteer.css';
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
    email: 'kasun.perera@email.com'
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
    email: 'nimali.fernando@email.com'
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
    email: 'ruwan.silva@email.com'
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
    email: 'sandani.rathnayake@email.com'
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
    email: 'chaminda.jayasinghe@email.com'
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
    email: 'malini.wickramasinghe@email.com'
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
    email: 'ajith.bandara@email.com'
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
    email: 'priyanka.gunasekara@email.com'
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
    email: 'tharaka.mendis@email.com'
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
    email: 'shani.dissanayake@email.com'
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
          <div className="volunteers-page">
            {/* Search and Filters Section */}
            <div className="search-filters-section">
              <div className="search-box">
                <input 
                  type="text" 
                  placeholder="Search volunteers..." 
                  className="search-input"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
                <span className="search-icon">🔍</span>
              </div>
              
              <div className="filters-section">
                <select 
                  className="filter-dropdown"
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                >
                  <option value="">All Status</option>
                  <option value="Active">Active</option>
                  <option value="Pending">Pending</option>
                  <option value="Disabled">Disabled</option>
                </select>
                
                <select className="filter-dropdown">
                  <option value="">Engaging Field</option>
                  <option value="transport">Patient Transport</option>
                  <option value="counseling">Counseling Support</option>
                  <option value="activities">Activity Organization</option>
                  <option value="meals">Meal Assistance</option>
                  <option value="technology">Technology Support</option>
                  <option value="companionship">Companionship</option>
                  <option value="emergency">Emergency Response</option>
                  <option value="education">Educational Support</option>
                  <option value="therapy">Physical Therapy Aid</option>
                  <option value="admin">Administrative Support</option>
                </select>
                
                <select className="filter-dropdown">
                  <option value="">Availability</option>
                  <option value="weekdays">Weekdays</option>
                  <option value="weekends">Weekends</option>
                  <option value="flexible">Flexible</option>
                  <option value="mornings">Mornings</option>
                  <option value="afternoons">Afternoons</option>
                  <option value="evenings">Evenings</option>
                  <option value="oncall">On-call</option>
                </select>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="stats-cards">
              <div className="stat-card">
                <div className="stat-icon">👥</div>
                <div className="stat-content">
                  <div className="stat-number">{totalVolunteers}</div>
                  <div className="stat-label">Total Volunteers</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">✅</div>
                <div className="stat-content">
                  <div className="stat-number">{activeVolunteers}</div>
                  <div className="stat-label">Active Volunteers</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">⏳</div>
                <div className="stat-content">
                  <div className="stat-number">{pendingVolunteers}</div>
                  <div className="stat-label">Pending Approval</div>
                </div>
              </div>
              
              <div className="stat-card">
                <div className="stat-icon">❌</div>
                <div className="stat-content">
                  <div className="stat-number">{disabledVolunteers}</div>
                  <div className="stat-label">Disabled Volunteers</div>
                </div>
              </div>
            </div>

            {/* Volunteers Table */}
            <div className="table-container">
              <table className="volunteers-table">
                <thead>
                  <tr>
                    <th>Volunteer Name</th>
                    <th>Age</th>
                    <th>Engaging Field</th>
                    <th>Address</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedVolunteers.map((volunteer) => (
                    <tr 
                      key={volunteer.id} 
                      onClick={() => handleVolunteerClick(volunteer)}
                      className="volunteer-row"
                    >
                      <td className="volunteer-name">{volunteer.name}</td>
                      <td>{volunteer.age}</td>
                      <td>{volunteer.engagingField}</td>
                      <td>{volunteer.address}</td>
                      <td>
                        <span className={`status-badge ${volunteer.status.toLowerCase()}`}>
                          {volunteer.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Volunteer Details Modal */}
            {selectedVolunteer && (
              <div className="modal-overlay" onClick={handleCloseModal}>
                <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                  <div className="modal-header">
                    <h2>Volunteer Details</h2>
                    <button className="close-button" onClick={handleCloseModal}>×</button>
                  </div>
                  
                  <div className="modal-body">
                    <div className="details-grid">
                      <div className="details-section">
                        <h3>Personal Information</h3>
                        <div className="detail-item">
                          <span className="detail-label">Name:</span>
                          <span className="detail-value">{selectedVolunteer.name}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Age:</span>
                          <span className="detail-value">{selectedVolunteer.age} years</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Gender:</span>
                          <span className="detail-value">{selectedVolunteer.gender}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Phone:</span>
                          <span className="detail-value">{selectedVolunteer.phone}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Email:</span>
                          <span className="detail-value">{selectedVolunteer.email}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Address:</span>
                          <span className="detail-value">{selectedVolunteer.address}</span>
                        </div>
                      </div>
                      
                      <div className="details-section">
                        <h3>Volunteer Information</h3>
                        <div className="detail-item">
                          <span className="detail-label">Engaging Field:</span>
                          <span className="detail-value">{selectedVolunteer.engagingField}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Experience:</span>
                          <span className="detail-value">{selectedVolunteer.experience}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Availability:</span>
                          <span className="detail-value">{selectedVolunteer.availability}</span>
                        </div>
                        <div className="detail-item">
                          <span className="detail-label">Status:</span>
                          <span className={`status-badge ${selectedVolunteer.status.toLowerCase()}`}>
                            {selectedVolunteer.status}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="modal-actions">
                    {selectedVolunteer.status === 'Pending' && (
                      <button 
                        className="accept-button"
                        onClick={() => handleAcceptVolunteer(selectedVolunteer.id)}
                      >
                        Accept Volunteer
                      </button>
                    )}
                    {selectedVolunteer.status === 'Active' && (
                      <button 
                        className="disable-button"
                        onClick={() => handleDisableVolunteer(selectedVolunteer.id)}
                      >
                        Disable Volunteer
                      </button>
                    )}
                    <button className="close-modal-button" onClick={handleCloseModal}>
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
