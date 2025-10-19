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
  bool _isEditing = false;
  Map<String, dynamic>? _patientData;

  final _formKey = GlobalKey<FormState>();

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

  // Store original values for cancel logic
  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalGender = '';
  String _originalBirthday = '';
  String _originalStreet = '';
  String _originalCity = '';
  String _originalState = '';
  String _originalDementiaType = '';
  String _originalDementiaStage = '';
  String _originalLabel = '';

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
    _firstNameController.text =
      _patientData!['fName'] ??
      _patientData!['FName'] ??
      _patientData!['fname'] ??
      '';
    _lastNameController.text =
      _patientData!['lName'] ??
      _patientData!['LName'] ??
      _patientData!['lname'] ??
      '';
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

    // Store originals for cancel logic
    _originalFirstName = _firstNameController.text;
    _originalLastName = _lastNameController.text;
    _originalEmail = _emailController.text;
    _originalPhone = _phoneController.text;
    _originalGender = _genderController.text;
    _originalBirthday = _birthdayController.text;
    _originalStreet = _streetController.text;
    _originalCity = _cityController.text;
    _originalState = _stateController.text;
    _originalDementiaType = _dementiaTypeController.text;
    _originalDementiaStage = _dementiaStageController.text;
    _originalLabel = _labelController.text;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    setState(() {
      _firstNameController.text = _originalFirstName;
      _lastNameController.text = _originalLastName;
      _emailController.text = _originalEmail;
      _phoneController.text = _originalPhone;
      _genderController.text = _originalGender;
      _birthdayController.text = _originalBirthday;
      _streetController.text = _originalStreet;
      _cityController.text = _originalCity;
      _stateController.text = _originalState;
      _dementiaTypeController.text = _originalDementiaType;
      _dementiaStageController.text = _originalDementiaStage;
      _labelController.text = _originalLabel;
      _isEditing = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await PatientService.updateProfile(
        patientId: widget.patientId,
        fName: _firstNameController.text.trim(),
        lName: _lastNameController.text.trim(),
        birthdate: _birthdayController.text.trim(),
        gender: _genderController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        email: _emailController.text.trim(),
        dementiaType: _dementiaTypeController.text.trim(),
        dementiaStage: _dementiaStageController.text.trim(),
        label: _labelController.text.trim(),
        profilePic: null, // or your logic
      );

      setState(() {
        _isLoading = false;
      });

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
        });
        _loadPatientProfile(widget.patientId); // reload updated data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${result.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectDate() async {
    if (!_isEditing) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_birthdayController.text) ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
        automaticallyImplyLeading: false,
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
          if (!_isEditing)
            TextButton(
              onPressed: _toggleEdit,
              child: Text(
                'Edit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PatientColors.primary,
                ),
              ),
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
              child: Form(
                key: _formKey,
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

                    _buildEditableTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      icon: Icons.person,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    _buildEditableTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    _buildEditableTextField(
                      controller: _birthdayController,
                      label: 'Date of Birth',
                      icon: Icons.cake_outlined,
                      enabled: _isEditing, // <-- allow editing when in edit mode
                      onTap: _isEditing ? _selectDate : null,
                    ),
                    _buildEditableTextField(
                      controller: _genderController,
                      label: 'Gender',
                      icon: Icons.person_outline,
                      enabled: _isEditing,
                    ),
                    _buildEditableTextField(
                      controller: _streetController,
                      label: 'Street',
                      icon: Icons.location_on_outlined,
                      enabled: _isEditing,
                    ),
                    _buildEditableTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: Icons.location_city,
                      enabled: _isEditing,
                    ),
                    _buildEditableTextField(
                      controller: _stateController,
                      label: 'State',
                      icon: Icons.map,
                      enabled: _isEditing,
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

                    _buildEditableTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      enabled: _isEditing,
                    ),
                    _buildEditableTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
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

                    _buildEditableTextField(
                      controller: _dementiaTypeController,
                      label: 'Dementia Type',
                      icon: Icons.medical_services,
                      enabled: _isEditing,
                    ),
                    _buildEditableTextField(
                      controller: _dementiaStageController,
                      label: 'Dementia Stage',
                      icon: Icons.timeline,
                      enabled: _isEditing,
                    ),

                    if (_isEditing) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _cancelEdit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PatientColors.primaryLight.withOpacity(0.35),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: PatientColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PatientColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          PatientColors.primary,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: PatientColors.primary,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: onTap != null,
        validator: validator,
        onTap: onTap,
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
          prefixIcon: Icon(icon, color: Colors.grey[600]),
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
          fillColor: enabled ? Colors.grey[50] : Colors.grey[100],
        ),
      ),
    );
  }
}

