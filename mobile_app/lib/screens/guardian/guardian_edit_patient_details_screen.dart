import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../services/patient_service.dart';

class GuardianEditPatientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? patient;

  const GuardianEditPatientDetailsScreen({Key? key, this.patient})
    : super(key: key);

  @override
  _GuardianEditPatientDetailsScreenState createState() =>
      _GuardianEditPatientDetailsScreenState();
}

class _GuardianEditPatientDetailsScreenState
    extends State<GuardianEditPatientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _labelController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _contactNumberController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _dementiaTypeController;
  late TextEditingController _dementiaStageController;

  // Changed from TextEditingController to String for dropdown
  String? _selectedDementiaStage;
  String? _selectedDementiaType;
  DateTime? _selectedDateOfBirth;

  // List of dementia stages for dropdown
  final List<String> _dementiaStages = [
    'MILD',
    'MODERATE',
    'SEVERE',
    'VERY_SEVERE',
  ];

  // Dementia types from add patient screen
final Map<String, String> dementiaTypeMap = {
  "Alzheimer's Disease": 'ALZHEIMERS_DISEASE',
  "Vascular Dementia": 'VASCULAR_DEMENTIA',
  "Lewy Body Dementia": 'LEWY_BODY_DEMENTIA', // ✅ FIXED
  "Frontotemporal Dementia": 'FRONTOTEMPORAL_DEMENTIA',
  "Mixed Dementia": 'MIXED_DEMENTIA',
  "Parkinson's Disease Dementia": 'PARKINSONS_DISEASE_DEMENTIA',
  "Creutzfeldt-Jakob Disease": 'CREUTZFELDT_JAKOB_DISEASE',
  "Normal Pressure Hydrocephalus": 'NORMAL_PRESSURE_HYDROCEPHALUS',
  "Huntington's Disease": 'HUNTINGTONS_DISEASE',
  "Wernicke-Korsakoff Syndrome": 'WERNICKE_KORSAKOFF_SYNDROME',
};


  bool _isLoading = false;

  Map<String, dynamic> patientData = {};

  // Store original values
  String _originalName = '';
  String _originalLabel = '';
  String _originalDateOfBirth = '';
  String _originalGender = '';
  String _originalContactNumber = '';
  String _originalAddress = '';
  String _originalDementiaType = '';
  String _originalDementiaStage = '';

  @override
  void initState() {
    super.initState();

    // Initialize controllers first
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _labelController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    _contactNumberController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _dementiaTypeController = TextEditingController();
    _dementiaStageController = TextEditingController();

    // Add listeners to update UI when text changes
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _labelController.addListener(() => setState(() {}));
    _dateOfBirthController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _genderController.addListener(() => setState(() {}));
    _contactNumberController.addListener(() => setState(() {}));
    _streetController.addListener(() => setState(() {}));
    _cityController.addListener(() => setState(() {}));
    _stateController.addListener(() => setState(() {}));
    _dementiaTypeController.addListener(() => setState(() {}));
    _dementiaStageController.addListener(() => setState(() {}));

    // Initialize data in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePatientData();
    });
  }

  void _initializePatientData() {
    // Get patient data from route arguments if not provided via constructor
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (widget.patient != null) {
      patientData = widget.patient!;
    } else if (args != null) {
      patientData = args;
    }

    // Initialize controllers with patient data
    _firstNameController.text =
        patientData['fName'] ??
        patientData['FName'] ??
        patientData['fname'] ??
        '';
    _lastNameController.text =
        patientData['lName'] ??
        patientData['LName'] ??
        patientData['lname'] ??
        '';
    _labelController.text = patientData['label'] ?? 'Patient';
    _dateOfBirthController.text = patientData['birthdate'] ?? '';
    _genderController.text = patientData['gender'] ?? '';
    _contactNumberController.text = patientData['phoneNumber'] ?? '';
    _emailController.text = patientData['email'] ?? '';
    _streetController.text = patientData['street'] ?? '';
    _cityController.text = patientData['city'] ?? '';
    _stateController.text = patientData['state'] ?? '';

    // Initialize dementia type dropdown
    String currentDementiaType = patientData['dementiaType'] ?? '';
    _selectedDementiaType = dementiaTypeMap.entries
        .firstWhere(
          (entry) => entry.value == currentDementiaType,
          orElse: () => MapEntry('', ''),
        )
        .key;
    if (_selectedDementiaType!.isEmpty) {
      _selectedDementiaType = null;
    }
    _dementiaTypeController.text = _selectedDementiaType ?? '';

    _selectedDementiaStage = patientData['dementiaStage'];
    _dementiaStageController.text = _selectedDementiaStage ?? '';

    // Initialize date of birth
    if (patientData['birthdate'] != null && patientData['birthdate'].isNotEmpty) {
      try {
        if (patientData['birthdate'].contains('/')) {
          List<String> dateParts = patientData['birthdate'].split('/');
          if (dateParts.length == 3) {
            _selectedDateOfBirth = DateTime(
              int.parse(dateParts[2]), // year
              int.parse(dateParts[1]), // month
              int.parse(dateParts[0]), // day
            );
          }
        } else if (patientData['birthdate'].contains('-')) {
          _selectedDateOfBirth = DateTime.parse(patientData['birthdate']);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    _selectedDementiaStage = patientData['dementiaStage'];

    // Store original values AFTER setting the controllers
    _originalName = '${_firstNameController.text} ${_lastNameController.text}';
    _originalLabel = _labelController.text;
    _originalDateOfBirth = _dateOfBirthController.text;
    _originalGender = _genderController.text;
    _originalContactNumber = _contactNumberController.text;
    _originalAddress =
        '${_streetController.text}, ${_cityController.text}, ${_stateController.text}';
    _originalDementiaType = currentDementiaType;
    _originalDementiaStage = _selectedDementiaStage ?? '';

    setState(() {});
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _labelController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _contactNumberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _dementiaTypeController.dispose();
    _dementiaStageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get patient data from route arguments if not already set
    if (patientData.isEmpty) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _initializePatientData();
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String originalValue,
    required String fieldName,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          color:
              textColor ??
              (controller.text == originalValue
                  ? Colors.grey[500]!
                  : Colors.black87),
        ),
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          hintText: 'Enter $label',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: readOnly
              ? Icon(Icons.arrow_drop_down, color: Colors.grey[600])
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  String _getDisplayText(String value) {
    switch (value) {
      case 'MILD':
        return 'Mild';
      case 'MODERATE':
        return 'Moderate';
      case 'SEVERE':
        return 'Severe';
      case 'VERY_SEVERE':
        return 'Very Severe';
      default:
        return value;
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
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
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  _getDisplayText(item),
                  style: TextStyle(color: AppColors.onSurface, fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              onChanged(value);
              // Force rebuild when selection changes
              setState(() {});
            },
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.outline),
              ),
              filled: true,
              fillColor: value == _originalDementiaStage
                  ? AppColors.surfaceVariant
                  : AppColors.surface,
            ),
            dropdownColor: AppColors.surface,
            style: TextStyle(
              color: value == _originalDementiaStage
                  ? AppColors.onSurfaceVariant
                  : AppColors.onSurface,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      // --- Safe patientId extraction ---
      final rawId = patientData['patientId'] ?? patientData['id'];
      final int? patientIdSafe = (rawId is int)
          ? rawId
          : int.tryParse(rawId?.toString() ?? '');

      if (patientIdSafe == null || patientIdSafe <= 0) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing or invalid patient ID')),
        );
        return;
      }

      final result = await PatientService.updateProfile(
        patientId: patientIdSafe,
        fName: _firstNameController.text.trim(),
        lName: _lastNameController.text.trim(),
        birthdate: _dateOfBirthController.text.isNotEmpty
            ? _dateOfBirthController.text.trim() // must be yyyy-MM-dd
            : '',
        gender: _genderController.text.trim(),
        phoneNumber: _contactNumberController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        email: _emailController.text.trim(), // <-- use edited email
        dementiaType: dementiaTypeMap[_selectedDementiaType ?? ''] ?? '',
        dementiaStage: _selectedDementiaStage ?? '',
        label: _labelController.text.trim(),
        profilePic: null,
      );

      setState(() => _isLoading = false);

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.success, // green
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: ${result.message}'),
            backgroundColor: AppColors.error, // red
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: AppColors.error, // red
        ),
      );
    }
  }
}


  void _cancelEdit() {
    // Reset to original values
    setState(() {
      // Split the original name back to first and last name
      List<String> nameParts = _originalName.split(' ');
      _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
      _lastNameController.text = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      _labelController.text = _originalLabel;
      _dateOfBirthController.text = _originalDateOfBirth;
      _contactNumberController.text = _originalContactNumber;
      // Split the original address back to components
      List<String> addressParts = _originalAddress.split(', ');
      _streetController.text = addressParts.isNotEmpty ? addressParts[0] : '';
      _cityController.text = addressParts.length > 1 ? addressParts[1] : '';
      _stateController.text = addressParts.length > 2 ? addressParts[2] : '';

      // Reset dementia type dropdown
      _selectedDementiaType = dementiaTypeMap.entries
          .firstWhere(
            (entry) => entry.value == _originalDementiaType,
            orElse: () => MapEntry('', ''),
          )
          .key;
      if (_selectedDementiaType!.isEmpty) {
        _selectedDementiaType = null;
      }

      _selectedDementiaStage = _originalDementiaStage;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
        // Always use yyyy-MM-dd format for backend
        _dateOfBirthController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showGenderPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Male', 'Female', 'Other'].map((gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    _genderController.text = gender;
                    patientData['gender'] = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDementiaTypePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Dementia Type'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: dementiaTypeMap.keys.map((type) {
                return ListTile(
                  title: Text(type),
                  onTap: () {
                    setState(() {
                      _selectedDementiaType = type;
                      _dementiaTypeController.text = type;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showDementiaStagePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Dementia Stage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _dementiaStages.map((stage) {
              String displayText = _getDisplayText(stage);
              return ListTile(
                title: Text(displayText),
                onTap: () {
                  setState(() {
                    _selectedDementiaStage = stage;
                    _dementiaStageController.text = displayText;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit Patient Details',
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
                          'Edit Patient',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Update patient information',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Edit Form
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
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

                    _buildTextField(
                      label: 'First Name',
                      controller: _firstNameController,
                      originalValue: _originalName.split(' ').isNotEmpty
                          ? _originalName.split(' ')[0]
                          : '',
                      fieldName: 'firstName',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      originalValue: _originalName.split(' ').length > 1
                          ? _originalName.split(' ').sublist(1).join(' ')
                          : '',
                      fieldName: 'lastName',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Label',
                      controller: _labelController,
                      originalValue: _originalLabel,
                      fieldName: 'label',
                      icon: Icons.label,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a label';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Date of Birth',
                      controller: _dateOfBirthController,
                      originalValue: _originalDateOfBirth,
                      fieldName: 'dateOfBirth',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date of birth';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Gender',
                      controller: _genderController,
                      originalValue: _originalGender,
                      fieldName: 'gender',
                      icon: Icons.person,
                      readOnly: true,
                      onTap: _showGenderPicker,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select gender';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Street',
                      controller: _streetController,
                      originalValue: _originalAddress.split(', ').isNotEmpty
                          ? _originalAddress.split(', ')[0]
                          : '',
                      fieldName: 'street',
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter street address';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'City',
                      controller: _cityController,
                      originalValue: _originalAddress.split(', ').length > 1
                          ? _originalAddress.split(', ')[1]
                          : '',
                      fieldName: 'city',
                      icon: Icons.location_city,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'State',
                      controller: _stateController,
                      originalValue: _originalAddress.split(', ').length > 2
                          ? _originalAddress.split(', ')[2]
                          : '',
                      fieldName: 'state',
                      icon: Icons.map,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Contact Number',
                      controller: _contactNumberController,
                      originalValue: _originalContactNumber,
                      fieldName: 'contactNumber',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      originalValue: patientData['email'] ?? '',
                      fieldName: 'email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
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

                    _buildTextField(
                      label: 'Dementia Type',
                      controller: _dementiaTypeController,
                      originalValue: _originalDementiaType,
                      fieldName: 'dementiaType',
                      icon: Icons.medical_services,
                      readOnly: true,
                      onTap: _showDementiaTypePicker,
                      textColor: Colors.grey[600],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select dementia type';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Dementia Stage',
                      controller: _dementiaStageController,
                      originalValue: _originalDementiaStage,
                      fieldName: 'dementiaStage',
                      icon: Icons.timeline,
                      readOnly: true,
                      onTap: _showDementiaStagePicker,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select dementia stage';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _cancelEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight
                                  .withOpacity(0.35),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.info,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.info,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
