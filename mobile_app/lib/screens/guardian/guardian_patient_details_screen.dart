import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GuardianPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const GuardianPatientDetailsScreen({Key? key, this.patient}) : super(key: key);

  @override
  _GuardianPatientDetailsScreenState createState() => _GuardianPatientDetailsScreenState();
}

class _GuardianPatientDetailsScreenState extends State<GuardianPatientDetailsScreen> {
  int _selectedIndex = 0;

  // Mock patient data - in real app, this would come from the arguments or API
  Map<String, dynamic> patientData = {
    'id': 1,
    'name': 'John Doe',
    'label': 'Patient',
    'dateOfBirth': '01/01/1950',
    'contactNumber': '+1 (999) 111-0000',
    'address': '123 Main St, Anytown',
    'dementiaStage': 'Severe',
    'avatar': 'assets/images/patient1.jpg',
  };

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.guardianDashboard,
              (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.guardianForums);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.guardianProfile);
        break;
    }
  }

  void _editPatient() {
    Navigator.pushNamed(
      context,
      AppRoutes.guardianEditPatientDetails,
      arguments: patientData,
    );
  }

  @override
  void initState() {
    super.initState();
    // If patient data is passed through arguments, use it
    if (widget.patient != null) {
      patientData = widget.patient!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Patient Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient header section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientData['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        patientData['label'] ?? 'Patient',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Patient details section
            _buildInfoRow('Date of Birth', patientData['dateOfBirth'] ?? 'N/A'),
            _buildInfoRow('Contact Number', patientData['contactNumber'] ?? 'N/A'),
            _buildInfoRow('Address', patientData['address'] ?? 'N/A'),
            _buildInfoRow('Dementia Stage', patientData['dementiaStage'] ?? 'N/A'),

            SizedBox(height: 40),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _editPatient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA0C4FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}