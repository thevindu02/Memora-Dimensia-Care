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
  Map<String, dynamic>? patientData;

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
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

                  _buildInfoField(
                    label: 'First Name',
                    value: NameUtils.capitalizeName(
                      patientData!['fName'] ??
                          patientData!['FName'] ??
                          patientData!['fname'] ??
                          'N/A',
                    ),
                    icon: Icons.person,
                  ),
                  _buildInfoField(
                    label: 'Last Name',
                    value: NameUtils.capitalizeName(
                      patientData!['lName'] ??
                          patientData!['LName'] ??
                          patientData!['lname'] ??
                          'N/A',
                    ),
                    icon: Icons.person_outline,
                  ),
                  _buildInfoField(
                    label: 'Date of Birth',
                    value: patientData!['birthdate'] ?? 'N/A',
                    icon: Icons.calendar_today,
                  ),
                  _buildInfoField(
                    label: 'Gender',
                    value: NameUtils.capitalizeName(
                      patientData!['gender'] ?? 'N/A',
                    ),
                    icon: Icons.person,
                  ),
                  _buildInfoField(
                    label: 'Street',
                    value: NameUtils.capitalizeName(
                      patientData!['street'] ?? 'N/A',
                    ),
                    icon: Icons.location_on,
                  ),
                  _buildInfoField(
                    label: 'City',
                    value: NameUtils.capitalizeName(
                      patientData!['city'] ?? 'N/A',
                    ),
                    icon: Icons.location_city,
                  ),
                  _buildInfoField(
                    label: 'State',
                    value: NameUtils.capitalizeName(
                      patientData!['state'] ?? 'N/A',
                    ),
                    icon: Icons.map,
                  ),
                  _buildInfoField(
                    label: 'Contact Number',
                    value: patientData!['phoneNumber'] ?? 'N/A',
                    icon: Icons.phone,
                  ),
                  _buildInfoField(
                    label: 'Email',
                    value: patientData!['email'] ?? 'N/A',
                    icon: Icons.email,
                  ),

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

                  _buildInfoField(
                    label: 'Dementia Type',
                    value: patientData!['dementiaType'] ?? 'N/A',
                    icon: Icons.medical_services,
                  ),
                  _buildInfoField(
                    label: 'Dementia Stage',
                    value: patientData!['dementiaStage'] ?? 'N/A',
                    icon: Icons.timeline,
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
