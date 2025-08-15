import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

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
  late TextEditingController _contactNumberController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

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
    "Lewy Body Dementia": 'LEWY_BODY_DEMENTIA',
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
    _contactNumberController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();

    // Add listeners to update UI when text changes
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _labelController.addListener(() => setState(() {}));
    _dateOfBirthController.addListener(() => setState(() {}));
    _contactNumberController.addListener(() => setState(() {}));
    _streetController.addListener(() => setState(() {}));
    _cityController.addListener(() => setState(() {}));
    _stateController.addListener(() => setState(() {}));

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
    _contactNumberController.text = patientData['phoneNumber'] ?? '';
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

    // Initialize date of birth
    if (patientData['birthdate'] != null &&
        patientData['birthdate'].isNotEmpty) {
      try {
        List<String> dateParts = patientData['birthdate'].split('/');
        if (dateParts.length == 3) {
          _selectedDateOfBirth = DateTime(
            int.parse(dateParts[2]), // year
            int.parse(dateParts[1]), // month
            int.parse(dateParts[0]), // day
          );
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
    _contactNumberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
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
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
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
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              color: controller.text == originalValue
                  ? AppColors.onSurfaceVariant
                  : AppColors.onSurface,
              fontSize: 14,
            ),
            onChanged: (value) {
              // Force rebuild when text changes
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
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
              fillColor: controller.text == originalValue
                  ? AppColors.surfaceVariant
                  : AppColors.surface,
            ),
          ),
        ],
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

  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
    required DateTime? selectedDate,
    required VoidCallback onTap,
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
          TextFormField(
            controller: controller,
            validator: validator,
            readOnly: true,
            onTap: onTap,
            style: TextStyle(color: AppColors.onSurface, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Select $label',
              hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
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
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate API call
        await Future.delayed(Duration(seconds: 2));

        // Update original values
        _originalName =
            '${_firstNameController.text} ${_lastNameController.text}';
        _originalLabel = _labelController.text;
        _originalDateOfBirth = _dateOfBirthController.text;
        _originalContactNumber = _contactNumberController.text;
        _originalAddress =
            '${_streetController.text}, ${_cityController.text}, ${_stateController.text}';
        _originalDementiaType = _selectedDementiaType != null
            ? dementiaTypeMap[_selectedDementiaType!] ?? ''
            : '';
        _originalDementiaStage = _selectedDementiaStage ?? '';

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient details updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating patient details: ${e.toString()}'),
            backgroundColor: AppColors.error,
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
        _dateOfBirthController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a label';
                        }
                        return null;
                      },
                    ),

                    _buildDatePickerField(
                      label: 'Date of Birth',
                      controller: _dateOfBirthController,
                      selectedDate: _selectedDateOfBirth,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date of birth';
                        }
                        return null;
                      },
                    ),

                    _buildDropdownField(
                      label: 'Gender',
                      value: patientData['gender'] ?? '',
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        setState(() {
                          patientData['gender'] = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select gender';
                        }
                        return null;
                      },
                    ),

                    _buildTextField(
                      label: 'Contact Number',
                      controller: _contactNumberController,
                      originalValue: _originalContactNumber,
                      fieldName: 'contactNumber',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter contact number';
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
                      controller: TextEditingController(
                        text: patientData['email'] ?? '',
                      ),
                      originalValue: patientData['email'] ?? '',
                      fieldName: 'email',
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

                    _buildDropdownField(
                      label: 'Dementia Type',
                      value: _selectedDementiaType,
                      items: dementiaTypeMap.keys.toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDementiaType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select dementia type';
                        }
                        return null;
                      },
                    ),

                    _buildDropdownField(
                      label: 'Dementia Stage',
                      value: _selectedDementiaStage,
                      items: _dementiaStages,
                      onChanged: (value) {
                        setState(() {
                          _selectedDementiaStage = value;
                        });
                      },
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
