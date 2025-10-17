import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final _nameController = TextEditingController(text: 'Sarah Johnson');
  final _emailController = TextEditingController(text: 'sarah.johnson@email.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _genderController = TextEditingController(text: 'Female');
  final _birthdayController = TextEditingController(text: 'March 15, 1985');
  final _addressController = TextEditingController(text: '123 Oak Street, Apt 4B\nSpringfield, IL 62701');
  final _emergencyContactNameController = TextEditingController(text: 'Michael Johnson (Spouse)');
  final _emergencyContactPhoneController = TextEditingController(text: '+1 (555) 987-6543');
  final _allergiesController = TextEditingController(text: 'Penicillin, Shellfish');
  final _medicationsController = TextEditingController(text: 'Lisinopril 10mg daily\nMetformin 500mg twice daily');
  final _conditionsController = TextEditingController(text: 'Type 2 Diabetes, Hypertension');
  final _insuranceProviderController = TextEditingController(text: 'Blue Cross Blue Shield');
  final _policyNumberController = TextEditingController(text: 'BCBS123456789');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.background,
      appBar: AppBar(
        backgroundColor: PatientColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PatientColors.onSurface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: PatientColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: PatientColors.onSurface),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.patientSettings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              color: PatientColors.surface,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                        backgroundColor: PatientColors.onSurfaceVariant,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: PatientColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: PatientColors.onPrimary,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Patient',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Patient ID: #P12345',
                        style: TextStyle(
                          fontSize: 14,
                          color: PatientColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Form
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildLabeledTextField(
                    label: 'Full Name',
                    icon: Icons.person,
                    controller: _nameController,
                  ),
                  _buildLabeledTextField(
                    label: 'Date of Birth',
                    icon: Icons.cake_outlined,
                    controller: _birthdayController,
                  ),
                  _buildLabeledTextField(
                    label: 'Gender',
                    icon: Icons.person_outline,
                    controller: _genderController,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledTextField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                  ),
                  _buildLabeledTextField(
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                  _buildLabeledTextField(
                    label: 'Address',
                    icon: Icons.location_on_outlined,
                    controller: _addressController,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledTextField(
                    label: 'Contact Name',
                    icon: Icons.person_outline,
                    controller: _emergencyContactNameController,
                  ),
                  _buildLabeledTextField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _emergencyContactPhoneController,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledTextField(
                    label: 'Allergies',
                    icon: Icons.warning_amber_outlined,
                    controller: _allergiesController,
                    iconColor: PatientColors.error,
                  ),
                  _buildLabeledTextField(
                    label: 'Current Medications',
                    icon: Icons.medication_outlined,
                    controller: _medicationsController,
                    iconColor: PatientColors.primary,
                  ),
                  _buildLabeledTextField(
                    label: 'Medical Conditions',
                    icon: Icons.favorite_outline,
                    controller: _conditionsController,
                    iconColor: PatientColors.primary,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Insurance Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledTextField(
                    label: 'Insurance Provider',
                    icon: Icons.shield_outlined,
                    controller: _insuranceProviderController,
                  ),
                  _buildLabeledTextField(
                    label: 'Policy Number',
                    icon: Icons.credit_card_outlined,
                    controller: _policyNumberController,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PatientColors.primary,
                        foregroundColor: PatientColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PatientColors.onSurfaceVariant,
                        side: BorderSide(color: PatientColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Download Medical Records',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PatientColors.onSurfaceVariant,
                        side: BorderSide(color: PatientColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Share Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          height: 1.4,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: iconColor ?? Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: PatientColors.primary, width: 2),
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
}