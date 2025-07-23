import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GuardianPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const GuardianPatientDetailsScreen({Key? key, this.patient})
    : super(key: key);

  @override
  _GuardianPatientDetailsScreenState createState() =>
      _GuardianPatientDetailsScreenState();
}

class _GuardianPatientDetailsScreenState
    extends State<GuardianPatientDetailsScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? patientData;

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B73FF),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
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
            icon: Icon(Icons.arrow_back, color: Color(0xFF2B3F99)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B3F99),
            ),
          ),
          centerTitle: false,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2B3F99)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Patient Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2B3F99),
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
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F9FF),
                    Color(0xFFE8EFFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Color(0xFF6B73FF),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${patientData!['fName'] ?? patientData!['FName'] ?? patientData!['fname'] ?? ''} ${patientData!['lName'] ?? patientData!['LName'] ?? patientData!['lname'] ?? ''}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3F99),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFF6B73FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            patientData!['label'] ?? 'Patient',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B73FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Patient details section
            _buildInfoRow('Date of Birth', patientData!['birthdate'] ?? 'N/A'),
            _buildInfoRow(
              'Contact Number',
              patientData!['phoneNumber'] ?? 'N/A',
            ),
            _buildInfoRow(
              'Address',
              '${patientData!['street'] ?? ''}, ${patientData!['city'] ?? ''}, ${patientData!['state'] ?? ''}',
            ),
            _buildInfoRow(
              'Dementia Stage',
              patientData!['dementiaStage'] ?? 'N/A',
            ),
            _buildInfoRow(
              'Dementia Type',
              patientData!['dementiaType'] ?? 'N/A',
            ),
            _buildInfoRow('Email', patientData!['email'] ?? 'N/A'),
            _buildInfoRow('Gender', patientData!['gender'] ?? 'N/A'),

            SizedBox(height: 40),

            // Action buttons
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _editPatient,
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  'Edit Patient Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B73FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Color(0xFF6B73FF).withOpacity(0.3),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
