import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GuardianAddUnknownCaregiverScreen extends StatefulWidget {
  @override
  _GuardianAddUnknownCaregiverScreenState createState() => _GuardianAddUnknownCaregiverScreenState();
}

class _GuardianAddUnknownCaregiverScreenState extends State<GuardianAddUnknownCaregiverScreen> {
  Map<String, dynamic>? selectedPatient;
  String? selectedCity;
  List<Map<String, dynamic>> filteredCaregivers = [];

  // Sri Lankan cities
  final List<String> sriLankanCities = [
    'All Cities',
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Kurunegala',
    'Ratnapura',
    'Batticaloa',
    'Trincomalee',
    'Matara',
    'Badulla',
    'Kalutara',
    'Gampaha',
    'Nuwara Eliya',
    'Chilaw',
    'Embilipitiya',
    'Wattala',
    'Moratuwa',
  ];

  // Mock caregiver data
  final List<Map<String, dynamic>> allCaregivers = [
    {
      'id': 1,
      'name': 'Sarah Johnson',
      'location': 'Colombo',
      'experience': '5 years',
      'specialization': 'Elderly Care',
      'rating': 4.8,
      'avatar': 'assets/images/caregiver1.jpg',
      'verified': true,
      'phone': '+94 77 123 4567',
      'description': 'Experienced caregiver specializing in elderly care with compassionate approach.',
    },
    {
      'id': 2,
      'name': 'Michael Fernando',
      'location': 'Kandy',
      'experience': '3 years',
      'specialization': 'Disability Care',
      'rating': 4.6,
      'avatar': 'assets/images/caregiver2.jpg',
      'verified': true,
      'phone': '+94 77 234 5678',
      'description': 'Dedicated caregiver with expertise in disability support and rehabilitation.',
    },
    {
      'id': 3,
      'name': 'Priya Perera',
      'location': 'Galle',
      'experience': '7 years',
      'specialization': 'Medical Care',
      'rating': 4.9,
      'avatar': 'assets/images/caregiver3.jpg',
      'verified': false,
      'phone': '+94 77 345 6789',
      'description': 'Skilled medical caregiver with extensive experience in patient care.',
    },
    {
      'id': 4,
      'name': 'David Silva',
      'location': 'Colombo',
      'experience': '4 years',
      'specialization': 'Elderly Care',
      'rating': 4.7,
      'avatar': 'assets/images/caregiver4.jpg',
      'verified': true,
      'phone': '+94 77 456 7890',
      'description': 'Professional caregiver focusing on elderly care and daily living assistance.',
    },
    {
      'id': 5,
      'name': 'Nimali Rathnayake',
      'location': 'Kandy',
      'experience': '6 years',
      'specialization': 'Rehabilitation',
      'rating': 4.5,
      'avatar': 'assets/images/caregiver5.jpg',
      'verified': true,
      'phone': '+94 77 567 8901',
      'description': 'Rehabilitation specialist with focus on recovery and mobility support.',
    },
    {
      'id': 6,
      'name': 'James Rodrigo',
      'location': 'Negombo',
      'experience': '2 years',
      'specialization': 'Personal Care',
      'rating': 4.3,
      'avatar': 'assets/images/caregiver6.jpg',
      'verified': false,
      'phone': '+94 77 678 9012',
      'description': 'Personal care assistant with attention to individual needs and preferences.',
    },
  ];

  // Mock guardian data (this would be fetched from database)
  final Map<String, dynamic> guardianInfo = {
    'name': 'John Smith',
    'email': 'john.smith@email.com',
    'phone': '+94 77 123 4567',
    'relationship': 'Son',
  };

  @override
  void initState() {
    super.initState();
    selectedCity = 'All Cities';
    filteredCaregivers = allCaregivers;

    // Get the selected patient from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          selectedPatient = args;
        });
      }
    });
  }

  void _filterCaregivers(String? city) {
    setState(() {
      selectedCity = city;
      if (city == null || city.isEmpty || city == 'All Cities') {
        filteredCaregivers = allCaregivers;
      } else {
        filteredCaregivers = allCaregivers
            .where((caregiver) => caregiver['location'] == city)
            .toList();
      }
    });
  }

  void _showConnectionRequestDialog(Map<String, dynamic> caregiver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Send Connection Request',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Caregiver Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  ),
                ),
                SizedBox(height: 8),
                _buildInfoRow('Name:', caregiver['name']),
                _buildInfoRow('Location:', caregiver['location']),
                _buildInfoRow('Specialization:', caregiver['specialization']),
                _buildInfoRow('Experience:', caregiver['experience']),
                SizedBox(height: 16),
                Text(
                  'Guardian Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  ),
                ),
                SizedBox(height: 8),
                _buildInfoRow('Name:', guardianInfo['name']),
                _buildInfoRow('Email:', guardianInfo['email']),
                _buildInfoRow('Phone:', guardianInfo['phone']),
                _buildInfoRow('Relationship:', guardianInfo['relationship']),
                SizedBox(height: 16),
                Text(
                  'Patient Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  ),
                ),
                SizedBox(height: 8),
                _buildInfoRow('Patient Name:', selectedPatient?['name'] ?? 'N/A'),
                _buildInfoRow('Patient Label:', selectedPatient?['label'] ?? 'N/A'),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _sendConnectionRequest(caregiver);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2B3F99),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendConnectionRequest(Map<String, dynamic> caregiver) {
    // Simulate sending connection request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection request sent successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to caregiver adding interface
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.guardianAddCaregiver,
        arguments: selectedPatient,
      );
    });
  }

  void _viewProfile(Map<String, dynamic> caregiver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Caregiver Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    caregiver['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        ' ${caregiver['rating']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8),
                      if (caregiver['verified'])
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                _buildInfoRow('Location:', caregiver['location']),
                _buildInfoRow('Experience:', caregiver['experience']),
                _buildInfoRow('Specialization:', caregiver['specialization']),
                _buildInfoRow('Phone:', caregiver['phone']),
                SizedBox(height: 16),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  caregiver['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showConnectionRequestDialog(caregiver);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2B3F99),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Send Connection Request'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard(Map<String, dynamic> caregiver) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          caregiver['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (caregiver['verified'])
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        caregiver['location'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    caregiver['specialization'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2B3F99),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Experience: ${caregiver['experience']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${caregiver['rating']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, color: Color(0xFF2B3F99)),
                  onPressed: () => _viewProfile(caregiver),
                  tooltip: 'View Profile',
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showConnectionRequestDialog(caregiver),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B3F99),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Unknown Caregiver',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF2B3F99),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedPatient != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF2B3F99)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Patient',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            selectedPatient!['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B3F99),
                            ),
                          ),
                          Text(
                            selectedPatient!['label'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24),
            Text(
              'Filter by Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedCity,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  hintText: 'Select City',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                ),
                items: sriLankanCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: _filterCaregivers,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Caregivers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${filteredCaregivers.length} found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredCaregivers.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No caregivers found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try selecting a different location',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: filteredCaregivers.length,
                itemBuilder: (context, index) {
                  return _buildCaregiverCard(filteredCaregivers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}