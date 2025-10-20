import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart';
import '../../constants/color_constants.dart';

class GuardianAddPatientScreen extends StatefulWidget {
  @override
  _GuardianAddPatientScreenState createState() =>
      _GuardianAddPatientScreenState();
}

class _GuardianAddPatientScreenState extends State<GuardianAddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _contactController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _diagnosisDateController = TextEditingController();
  final _emailController = TextEditingController();
  //final _passwordController = TextEditingController();
  final _customRelationshipController = TextEditingController();

  String? _selectedDementiaStage;
  String? _selectedDementiaType;
  String? _selectedRelationship;
  DateTime? _selectedDOB;
  DateTime? _selectedDiagnosisDate;
  String? _selectedGender;
  bool _isLoading = false;

  final List<String> _relationshipOptions = [
    'Mother',
    'Father',
    'Spouse',
    'Daughter',
    'Son',
    'Grandmother',
    'Grandfather',
    'Sister',
    'Brother',
    'Aunt',
    'Uncle',
    'Cousin',
    'Friend',
    'Caregiver',
    'Other',
  ];

  final List<String> _dementiaStages = [
    'Mild',
    'Moderate',
    'Severe',
    'Very Severe',
  ];

  final Map<String, String> dementiaTypeMap = {
    "Alzheimer's Disease": 'ALZHEIMERS_DISEASE',
    "Vascular Dementia": 'VASCULAR_DEMENTIA',
    "Lewy Body Dementia": 'LEWY_BODY_DEMENTIA',
    "Frontotemporal Dementia": 'FRONTOTEMPORAL_DEMENTIA',
    "Mixed Dementia": 'MIXED_DEMENTIA',
    "Parkinson's Disease Dementia": 'PARKINSONS_DISEASE_DEMENTIA',
    "Creutzfeldt-Jakob Disease": 'CREUTZFELDT_JAKOB_DISEASE',
    "Normal Pressure Hydrocephalus": 'NORMAL_PRESSURE_HYDROCEPHALUS',
    "Huntington's Disease": 'HUNTINGTONS_DISEASE',
    "Wernicke-Korsakoff Syndrome": 'WERNICKE_KORSAKOFF_SYNDROME',
  };

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _diagnosisDateController.dispose();
    _emailController.dispose();
    //_passwordController.dispose();
    _customRelationshipController.dispose();
    super.dispose();
  }

  // Enhanced validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    String cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanedValue.length < 10) {
      return 'Contact number must be at least 10 digits';
    }
    if (!RegExp(r'^[\+]?[\d\s\-\(\)]{10,15}$').hasMatch(value.trim())) {
      return 'Please enter a valid contact number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 3) {
      return 'Address must be at least 3 characters';
    }
    return null;
  }

  String? _validateRelationship(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a relationship';
    }
    return null;
  }

  String? _validateCustomRelationship(String? value) {
    if (_selectedRelationship == 'Other') {
      if (value == null || value.trim().isEmpty) {
        return 'Please specify the relationship';
      }
      if (value.trim().length < 2) {
        return 'Relationship must be at least 2 characters';
      }
      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
        return 'Relationship can only contain letters and spaces';
      }
    }
    return null;
  }

  String? _validateDateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateDOB() {
    if (_selectedDOB == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age = now.year - _selectedDOB!.year;

    if (_selectedDOB!.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }

    if (age > 150) {
      return 'Please enter a valid date of birth';
    }

    return null;
  }

  String? _validateDiagnosisDate() {
    if (_selectedDiagnosisDate == null) {
      return 'Diagnosis date is required';
    }

    final now = DateTime.now();

    if (_selectedDiagnosisDate!.isAfter(now)) {
      return 'Diagnosis date cannot be in the future';
    }

    if (_selectedDOB != null &&
        _selectedDiagnosisDate!.isBefore(_selectedDOB!)) {
      return 'Diagnosis date cannot be before date of birth';
    }

    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDOB) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDOB) {
          _selectedDOB = picked;
          _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        } else {
          _selectedDiagnosisDate = picked;
          _diagnosisDateController.text =
              "${picked.day}/${picked.month}/${picked.year}";
        }
      });
    }
  }

  void _handleSavePatient() async {
    try {
      print('Save Patient button pressed');
      if (_formKey.currentState!.validate()) {
        // Additional custom validations for dates
        String? dobError = _validateDOB();
        String? diagnosisError = _validateDiagnosisDate();

        if (dobError != null || diagnosisError != null) {
          String errorMessage = '';
          if (dobError != null) errorMessage += dobError + '\n';
          if (diagnosisError != null) errorMessage += diagnosisError;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage.trim()),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });
        print('Form validated, preparing patient data for payment');

        // Get the current user id (from user table)
        final int? currentUserId = await AuthService.getCurrentUserId();
        print('Current User ID: $currentUserId');

        // Fetch the guardianId from the guardian table using the user id
        int? guardianId;
        if (currentUserId != null) {
          guardianId = await GuardianService.getGuardianIdByUserId(
            currentUserId,
          );
        }
        print('Guardian Table ID: $guardianId');

        if (guardianId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You must be logged in as a guardian to add a patient.',
              ),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Collect all form data to pass to subscription screen
        // Patient will be created AFTER successful payment
        final String? backendDementiaType = _selectedDementiaType != null
            ? dementiaTypeMap[_selectedDementiaType]
            : null;

        final Map<String, dynamic> patientData = {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
          'gender': _selectedGender ?? '',
          'contactNumber': _contactController.text.trim(),
          'email': _emailController.text.trim(),
          'street': _streetController.text.trim(),
          'city': _cityController.text.trim(),
          'state': _stateController.text.trim(),
          'dementiaType': backendDementiaType ?? '',
          'dementiaStage': _selectedDementiaStage ?? '',
          'dateOfDiagnosis': _diagnosisDateController.text.trim(),
          'relationship': _selectedRelationship == 'Other'
              ? _customRelationshipController.text.trim()
              : (_selectedRelationship ?? ''),
        };

        setState(() {
          _isLoading = false;
        });

        print('Navigating to subscription plans with patient data');

        // Navigate to subscription plans with data (patient created after payment)
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.guardianSubscriptionPlans,
          (route) => false,
          arguments: {'guardianId': guardianId, 'patientData': patientData},
        );
      } else {
        print('Form validation failed');
      }
    } catch (e, stack) {
      print('Exception in _handleSavePatient: $e');
      print(stack);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _dementiaTypeDisplayNames = dementiaTypeMap.keys
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Patient',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _firstNameController,
                hintText: 'First Name',
                validator: _validateName,
              ),

              _buildTextField(
                controller: _lastNameController,
                hintText: 'Last Name',
                validator: _validateName,
              ),

              _buildTextField(
                controller: _dobController,
                hintText: 'Date of Birth',
                readOnly: true,
                onTap: () => _selectDate(context, true),
                validator: (value) =>
                    _validateDateField(value, 'Date of birth'),
              ),

              _buildDropdownField(
                hintText: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),

              _buildTextField(
                controller: _contactController,
                hintText: 'Contact Number',
                validator: _validatePhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),

              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                validator: _validateEmail,
              ),
              // _buildTextField(
              //   controller: _passwordController,
              //   hintText: 'Password',
              //   validator: _validatePassword,
              // ),

              // Relationship field with dropdown
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relationship (Patient is my...)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedRelationship,
                        decoration: InputDecoration(
                          hintText: 'Select relationship',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        items: _relationshipOptions.map((String relationship) {
                          return DropdownMenuItem<String>(
                            value: relationship,
                            child: Text(
                              relationship,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRelationship = newValue;
                            if (newValue != 'Other') {
                              _customRelationshipController.clear();
                            }
                          });
                        },
                        validator: _validateRelationship,
                      ),
                    ),
                    if (_selectedRelationship == 'Other') ...[
                      SizedBox(height: 12),
                      _buildTextField(
                        controller: _customRelationshipController,
                        hintText: 'Please specify the relationship',
                        validator: _validateCustomRelationship,
                      ),
                    ],
                  ],
                ),
              ),

              // Address section
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildTextField(
                      controller: _streetController,
                      hintText: 'Street',
                      validator: _validateAddress,
                    ),
                    _buildTextField(
                      controller: _cityController,
                      hintText: 'City',
                      validator: _validateAddress,
                    ),
                    _buildTextField(
                      controller: _stateController,
                      hintText: 'State',
                      validator: _validateAddress,
                    ),
                  ],
                ),
              ),

              _buildDropdownField(
                hintText: 'Dementia Type',
                value: _selectedDementiaType,
                items: _dementiaTypeDisplayNames,
                onChanged: (value) {
                  setState(() {
                    _selectedDementiaType = value;
                  });
                },
              ),

              _buildDropdownField(
                hintText: 'Dementia Stage',
                value: _selectedDementiaStage,
                items: _dementiaStages,
                onChanged: (value) {
                  setState(() {
                    _selectedDementiaStage = value;
                  });
                },
              ),

              _buildTextField(
                controller: _diagnosisDateController,
                hintText: 'Date of diagnosis',
                readOnly: true,
                onTap: () => _selectDate(context, false),
                validator: (value) =>
                    _validateDateField(value, 'Diagnosis date'),
              ),

              SizedBox(height: 24),

              // Save Patient button
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSavePatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.info,
                          ),
                          strokeWidth: 2,
                        )
                      : Text(
                          'Save Patient',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
