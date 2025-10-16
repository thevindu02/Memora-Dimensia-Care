import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
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

  late TextEditingController _nameController;
  late TextEditingController _labelController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;
  late TextEditingController _dementiaTypeController;

  // Changed from TextEditingController to String for dropdown
  String? _selectedDementiaStage;

  // List of dementia stages for dropdown
  final List<String> _dementiaStages = [
    'MILD',
    'MODERATE',
    'SEVERE',
    'VERY_SEVERE',
  ];

  List<dynamic> _patients = [];
  bool _isLoadingPatients = true;
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
    _fetchPatients();

    // Initialize controllers first
    _nameController = TextEditingController();
    _labelController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _contactNumberController = TextEditingController();
    _addressController = TextEditingController();
    _dementiaTypeController = TextEditingController();

    // Add listeners to update UI when text changes
    _nameController.addListener(() => setState(() {}));
    _labelController.addListener(() => setState(() {}));
    _dateOfBirthController.addListener(() => setState(() {}));
    _contactNumberController.addListener(() => setState(() {}));
    _addressController.addListener(() => setState(() {}));
    _dementiaTypeController.addListener(() => setState(() {}));

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
    _nameController.text =
        '${patientData['fName'] ?? patientData['FName'] ?? patientData['fname'] ?? ''} ${patientData['lName'] ?? patientData['LName'] ?? patientData['lname'] ?? ''}';
    _labelController.text = patientData['label'] ?? 'Patient';
    _dateOfBirthController.text = patientData['birthdate'] ?? '';
    _contactNumberController.text = patientData['phoneNumber'] ?? '';
    _addressController.text =
        '${patientData['street'] ?? ''}, ${patientData['city'] ?? ''}, ${patientData['state'] ?? ''}';
    _dementiaTypeController.text = patientData['dementiaType'] ?? '';
    _selectedDementiaStage = patientData['dementiaStage'];

    // Store original values AFTER setting the controllers
    _originalName = _nameController.text;
    _originalLabel = _labelController.text;
    _originalDateOfBirth = _dateOfBirthController.text;
    _originalContactNumber = _contactNumberController.text;
    _originalAddress = _addressController.text;
    _originalDementiaType = _dementiaTypeController.text;
    _originalDementiaStage = _selectedDementiaStage ?? '';

    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _labelController.dispose();
    _dateOfBirthController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _dementiaTypeController.dispose();
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

  Future<void> _fetchPatients() async {
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId != null) {
        final patients = await PatientService.getPatientsByGuardian(userId);
        setState(() {
          _patients = patients;
          _isLoadingPatients = false;
        });
      }
    } catch (e) {
      print('Error fetching patients: $e');
      setState(() {
        _isLoadingPatients = false;
      });
    }
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
        _originalName = _nameController.text;
        _originalLabel = _labelController.text;
        _originalDateOfBirth = _dateOfBirthController.text;
        _originalContactNumber = _contactNumberController.text;
        _originalAddress = _addressController.text;
        _originalDementiaType = _dementiaTypeController.text;
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
      _nameController.text = _originalName;
      _labelController.text = _originalLabel;
      _dateOfBirthController.text = _originalDateOfBirth;
      _contactNumberController.text = _originalContactNumber;
      _addressController.text = _originalAddress;
      _dementiaTypeController.text = _originalDementiaType;
      _selectedDementiaStage = _originalDementiaStage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? patient =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
                      label: 'Full Name',
                      controller: _nameController,
                      originalValue: _originalName,
                      fieldName: 'name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
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

                    _buildTextField(
                      label: 'Date of Birth',
                      controller: _dateOfBirthController,
                      originalValue: _originalDateOfBirth,
                      fieldName: 'dateOfBirth',
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter date of birth';
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
                      label: 'Address',
                      controller: _addressController,
                      originalValue: _originalAddress,
                      fieldName: 'address',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter dementia type';
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
