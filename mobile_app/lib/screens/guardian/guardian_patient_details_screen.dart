import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.outline.withOpacity(0.5)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
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
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          centerTitle: false,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Patient Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.info,
                    child: Icon(
                      Icons.person,
                      color: AppColors.onInfo,
                      size: 35,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NameUtils.formatPatientName(patientData!),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            patientData!['label'] ?? 'Patient',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info,
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

            SizedBox(height: 16),

            // Patient Information
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildInfoRow(
                    'First Name',
                    NameUtils.capitalizeName(
                      patientData!['fName'] ??
                          patientData!['FName'] ??
                          patientData!['fname'] ??
                          'N/A',
                    ),
                  ),
                  _buildInfoRow(
                    'Last Name',
                    NameUtils.capitalizeName(
                      patientData!['lName'] ??
                          patientData!['LName'] ??
                          patientData!['lname'] ??
                          'N/A',
                    ),
                  ),
                  _buildInfoRow(
                    'Date of Birth',
                    patientData!['birthdate'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Gender',
                    NameUtils.capitalizeName(patientData!['gender'] ?? 'N/A'),
                  ),
                  _buildInfoRow(
                    'Street',
                    NameUtils.capitalizeName(patientData!['street'] ?? 'N/A'),
                  ),
                  _buildInfoRow(
                    'City',
                    NameUtils.capitalizeName(patientData!['city'] ?? 'N/A'),
                  ),
                  _buildInfoRow(
                    'State',
                    NameUtils.capitalizeName(patientData!['state'] ?? 'N/A'),
                  ),
                  _buildInfoRow(
                    'Contact Number',
                    patientData!['phoneNumber'] ?? 'N/A',
                  ),
                  _buildInfoRow('Email', patientData!['email'] ?? 'N/A'),

                  SizedBox(height: 16),

                  Text(
                    'Diseases Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildInfoRow(
                    'Dementia Type',
                    patientData!['dementiaType'] ?? 'N/A',
                  ),
                  _buildInfoRow(
                    'Dementia Stage',
                    patientData!['dementiaStage'] ?? 'N/A',
                  ),

                  SizedBox(height: 16),

                  // Edit Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _editPatient,
                      child: Text(
                        'Edit Patient Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
