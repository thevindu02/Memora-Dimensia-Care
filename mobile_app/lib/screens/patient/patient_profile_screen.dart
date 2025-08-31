import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';

class PatientProfileScreen extends StatefulWidget {
  final int patientId;
  const PatientProfileScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _patientData;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _dementiaTypeController = TextEditingController();
  final _dementiaStageController = TextEditingController();
  final _labelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatientProfile(widget.patientId);
  }

  Future<void> _loadPatientProfile(int patientId) async {
    final result = await PatientService.getPatientProfile(patientId);
    if (result.success && result.data != null) {
      setState(() {
        _patientData = result.data;
        _isLoading = false;
      });
      _updateControllers();
    } else {
      setState(() {
        _isLoading = false;
      });
      // Optionally show error
    }
  }

  void _updateControllers() {
    if (_patientData == null) return;
    _firstNameController.text = _patientData!['FName'] ?? '';
    _lastNameController.text = _patientData!['LName'] ?? '';
    _emailController.text = _patientData!['email'] ?? '';
    _phoneController.text = _patientData!['phoneNumber'] ?? '';
    _genderController.text = _patientData!['gender'] ?? '';
    _birthdayController.text = _patientData!['birthdate'] ?? '';
    _streetController.text = _patientData!['street'] ?? '';
    _cityController.text = _patientData!['city'] ?? '';
    _stateController.text = _patientData!['state'] ?? '';
    _dementiaTypeController.text = _patientData!['dementiaType'] ?? '';
    _dementiaStageController.text = _patientData!['dementiaStage'] ?? '';
    _labelController.text = _patientData!['label'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
                        '${_firstNameController.text} ${_lastNameController.text}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labelController.text,
                        style: const TextStyle(
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
                    label: 'First Name',
                    icon: Icons.person,
                    controller: _firstNameController,
                  ),
                  _buildLabeledTextField(
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    controller: _lastNameController,
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
                  _buildLabeledTextField(
                    label: 'Street',
                    icon: Icons.location_on_outlined,
                    controller: _streetController,
                  ),
                  _buildLabeledTextField(
                    label: 'City',
                    icon: Icons.location_city,
                    controller: _cityController,
                  ),
                  _buildLabeledTextField(
                    label: 'State',
                    icon: Icons.map,
                    controller: _stateController,
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

                  const SizedBox(height: 24),
                  const Text(
                    'Diseases Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabeledTextField(
                    label: 'Dementia Type',
                    icon: Icons.medical_services,
                    controller: _dementiaTypeController,
                  ),
                  _buildLabeledTextField(
                    label: 'Dementia Stage',
                    icon: Icons.timeline,
                    controller: _dementiaStageController,
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

