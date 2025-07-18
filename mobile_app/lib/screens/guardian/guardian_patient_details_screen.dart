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
  Map<String, dynamic>? patientData;

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
    // Initialize with constructor parameter if available
    if (widget.patient != null) {
      patientData = widget.patient!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get patient data from route arguments if not already set
    if (patientData == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      print("Route arguments: $args"); // Debug print
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          patientData = args;
        });
      } else {
        // If no arguments, set a default or handle error
        print("No valid arguments found");
        // You might want to pop back or show an error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if patient data is not yet available
    if (patientData == null) {
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
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                        '${patientData!['fname'] ?? ''} ${patientData!['lname'] ?? ''}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        patientData!['label'] ?? 'Patient',
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
            _buildInfoRow('Date of Birth', patientData!['birthdate'] ?? 'N/A'),
            _buildInfoRow('Contact Number', patientData!['phoneNumber'] ?? 'N/A'),
            _buildInfoRow('Address', '${patientData!['street'] ?? ''}, ${patientData!['city'] ?? ''}, ${patientData!['state'] ?? ''}'),
            _buildInfoRow('Dementia Stage', patientData!['dementiaStage'] ?? 'N/A'),
            _buildInfoRow('Dementia Type', patientData!['dementiaType'] ?? 'N/A'),
            _buildInfoRow('Email', patientData!['email'] ?? 'N/A'),
            _buildInfoRow('Gender', patientData!['gender'] ?? 'N/A'),

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
    );
  }
}