import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/caregiver_service.dart';
import '../../utils/name_utils.dart';

class CaregiverProfileScreen extends StatefulWidget {
  @override
  _CaregiverProfileScreenState createState() => _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  int _currentIndex = 3; // Profile tab index
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isLoadingReviews = false;
  File? _profileImage;
  File? _originalProfileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Form key and controllers with hardcoded data
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Smith');
  final _emailController = TextEditingController(
    text: 'john.smith@example.com',
  );
  final _phoneController = TextEditingController(text: '+1 234 567 890');
  final _genderController = TextEditingController(text: 'Male');
  final _birthdayController = TextEditingController(text: '2001-01-14');
  final _streetController = TextEditingController(text: 'No. 123, Galle Road');
  final _cityController = TextEditingController(text: 'Colombo');
  final _stateController = TextEditingController(text: 'Western Province');
  final _experienceController = TextEditingController(text: '3-5 years');
  final _qualificationsController = TextEditingController(
    text: 'Nursing, CPR Certified',
  );
  final _skillsController = TextEditingController(
    text: 'Elder Care, Medical Care, Cooking',
  );
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Store original values
  String _originalName = 'John Smith';
  String _originalEmail = 'john.smith@example.com';
  String _originalPhone = '+1 234 567 890';
  String _originalGender = 'Male';
  String _originalBirthday = '2001-01-14';
  String _originalStreet = 'No. 123, Galle Road';
  String _originalCity = 'Colombo';
  String _originalState = 'Western Province';
  String _originalExperience = '3-5 years';
  String _originalQualifications = 'Nursing, CPR Certified';
  String _originalSkills = 'Elder Care, Medical Care, Cooking';

  // Reviews
  List<Map<String, dynamic>> _reviews = [];

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Track modified fields
  Set<String> _modifiedFields = {};
  Set<String> _focusedFields = {};

  @override
  void initState() {
    super.initState();
    _fetchCaregiverProfile();
    _fetchReviews();
  }

  Future<void> _fetchCaregiverProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final caregiverId = await AuthService.getCurrentCaregiverId();
      print('DEBUG: Fetched caregiverId = ' + caregiverId.toString());
      if (caregiverId != null) {
        final data = await CaregiverService.getCaregiverById(caregiverId);
        // Map backend fields to UI fields (adjust keys as needed)
        _nameController.text =
            (data['fName'] ?? '') + ' ' + (data['lName'] ?? '');
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _birthdayController.text = data['birthdate'] ?? '';

        // Split address into street, city, state
        String fullAddress = data['address'] ?? '';
        List<String> addressParts = fullAddress.split(', ');
        if (addressParts.length >= 3) {
          _streetController.text = addressParts[0];
          _cityController.text = addressParts[1];
          _stateController.text = addressParts.sublist(2).join(', ');
        } else if (addressParts.length == 2) {
          _streetController.text = addressParts[0];
          _cityController.text = addressParts[1];
          _stateController.text = '';
        } else if (addressParts.length == 1) {
          _streetController.text = addressParts[0];
          _cityController.text = '';
          _stateController.text = '';
        }

        _experienceController.text = data['experience'] ?? '';
        _qualificationsController.text = data['qualifications'] ?? '';
        _skillsController.text = (data['skills'] is List)
            ? (data['skills'] as List).join(', ')
            : (data['skills'] ?? '');
        // Set original values for change tracking
        _originalName = _nameController.text;
        _originalEmail = _emailController.text;
        _originalPhone = _phoneController.text;
        _originalGender = _genderController.text;
        _originalBirthday = _birthdayController.text;
        _originalStreet = _streetController.text;
        _originalCity = _cityController.text;
        _originalState = _stateController.text;
        _originalExperience = _experienceController.text;
        _originalQualifications = _qualificationsController.text;
        _originalSkills = _skillsController.text;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _updateNameDisplay();
    }
  }

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });
    try {
      final caregiverId = await AuthService.getCurrentCaregiverId();
      if (caregiverId != null) {
        _reviews = await CaregiverService.getCaregiverReviews(caregiverId);
      }
    } catch (e) {
      _reviews = [];
    }
    setState(() {
      _isLoadingReviews = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _experienceController.dispose();
    _qualificationsController.dispose();
    _skillsController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateNameDisplay() {
    // Always show capitalized version, both when viewing and editing (like guardian's profile)
    _nameController.text = NameUtils.capitalizeName(_originalName);
  }

  // Image picker functions
  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  Color _getTextColor(
    String fieldName,
    String currentValue,
    String originalValue,
  ) {
    if (!_isEditing) return Colors.black87;

    if (_modifiedFields.contains(fieldName)) {
      return Colors.black87;
    }

    // Special handling for name field - compare capitalized versions
    if (fieldName == 'name') {
      String capitalizedOriginal = NameUtils.capitalizeName(originalValue);
      if (currentValue == capitalizedOriginal) {
        return Colors.grey[500]!;
      }
    } else {
      if (currentValue == originalValue) {
        return Colors.grey[500]!;
      }
    }

    return Colors.black87;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      _updateNameDisplay();
    });
  }

  void _cancelEdit() {
    setState(() {
      _nameController.text = _originalName;
      _emailController.text = _originalEmail;
      _phoneController.text = _originalPhone;
      _genderController.text = _originalGender;
      _birthdayController.text = _originalBirthday;
      _streetController.text = _originalStreet;
      _cityController.text = _originalCity;
      _stateController.text = _originalState;
      _experienceController.text = _originalExperience;
      _qualificationsController.text = _originalQualifications;
      _skillsController.text = _originalSkills;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _modifiedFields.clear();
      _focusedFields.clear();
      _profileImage = _originalProfileImage;
      _isEditing = false;
      _updateNameDisplay();
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Split name into first and last name
      final nameParts = _nameController.text.trim().split(' ');
      final fName = nameParts.isNotEmpty ? nameParts.first : '';
      final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Prepare skills as a list
      final skillsList = _skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

      // Get caregiverId (implement AuthService.getCurrentCaregiverId if needed)
      final caregiverId = await AuthService.getCurrentCaregiverId();
      if (caregiverId == null) {
        // Handle the error (show a message or return)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Caregiver ID not found!')),
        );
        return;
      }

      final success = await CaregiverService.updateProfile(
        caregiverId: caregiverId, // Now guaranteed to be non-null
        fName: fName,
        lName: lName,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        gender: _genderController.text,
        birthdate: _birthdayController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        profilePic: '',
        experience: _experienceController.text,
        qualifications: _qualificationsController.text,
        skills: skillsList,
      );

      if (success) {
        // Update original values and UI
        setState(() {
          _isLoading = false;
          _isEditing = false;
          _updateNameDisplay();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String originalValue,
    required String fieldName,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isPassword = false,
    bool? showPassword,
    VoidCallback? togglePasswordVisibility,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && _focusedFields.contains(fieldName)) {
            if (controller.text.isEmpty && !isPassword) {
              controller.text = originalValue;
              _modifiedFields.remove(fieldName);
            }
            _focusedFields.remove(fieldName);
            setState(() {});
          }
        },
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: _isEditing,
          readOnly: readOnly,
          obscureText: isPassword && !(showPassword ?? false),
          onTap:
              onTap ??
              () {
                if (_isEditing &&
                    controller.text == originalValue &&
                    !isPassword) {
                  controller.clear();
                  _focusedFields.add(fieldName);
                  setState(() {});
                }
              },
          onChanged: (value) {
            if (value.isNotEmpty) {
              _modifiedFields.add(fieldName);
            } else {
              _modifiedFields.remove(fieldName);
            }
            setState(() {});
          },
          style: TextStyle(
            color: _getTextColor(fieldName, controller.text, originalValue),
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: _isEditing && controller.text.isEmpty
                ? 'Enter $label'
                : null,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      showPassword ?? false
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: togglePasswordVisibility,
                  )
                : (readOnly
                      ? Icon(Icons.arrow_drop_down, color: Colors.grey[600])
                      : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            filled: true,
            fillColor: _isEditing ? Colors.grey[50] : Colors.grey[100],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    if (!_isEditing) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2001, 1, 14),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF2B3F99)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _modifiedFields.add('birthday');
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.caregiverDashboard,
      (route) => false,
    );
  }

  Future<bool> _onWillPop() async {
    if (_isEditing) {
      setState(() {
        _isEditing = false;
      });
      return false;
    } else {
      _navigateToHome();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (_isEditing) {
                setState(() {
                  _isEditing = false;
                });
              } else {
                _navigateToHome();
              }
            },
          ),
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
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
                    color: Color(0xFF2B3F99),
                  ),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[800],
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 35,
                                      )
                                    : null,
                              ),
                              // Removed green dot indicator here
                              if (_isEditing)
                                Positioned(
                                  bottom: -2,
                                  right: -2,
                                  child: GestureDetector(
                                    onTap: _showImagePickerDialog,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2B3F99),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                NameUtils.capitalizeName(_nameController.text),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Caregiver',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Profile Form
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 24),

                            _buildTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              icon: Icons.person,
                              originalValue: _originalName,
                              fieldName: 'name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),

                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email,
                              originalValue: _originalEmail,
                              fieldName: 'email',
                              keyboardType: TextInputType.emailAddress,
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

                            _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone,
                              originalValue: _originalPhone,
                              fieldName: 'phone',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _genderController,
                                    label: 'Gender',
                                    icon: Icons.person_outline,
                                    originalValue: _originalGender,
                                    fieldName: 'gender',
                                    readOnly: true,
                                    onTap: _isEditing
                                        ? _showGenderPicker
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _birthdayController,
                                    label: 'Birthday',
                                    icon: Icons.calendar_today,
                                    originalValue: _originalBirthday,
                                    fieldName: 'birthday',
                                    readOnly: true,
                                    onTap: _selectDate,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16),

                            _buildTextField(
                              controller: _streetController,
                              label: 'Street',
                              icon: Icons.location_on,
                              originalValue: _originalStreet,
                              fieldName: 'street',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your street address';
                                }
                                return null;
                              },
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _cityController,
                                    label: 'City',
                                    icon: Icons.location_city,
                                    originalValue: _originalCity,
                                    fieldName: 'city',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your city';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _stateController,
                                    label: 'State/Province',
                                    icon: Icons.map,
                                    originalValue: _originalState,
                                    fieldName: 'state',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your state/province';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'Professional Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 16),

                            _buildTextField(
                              controller: _experienceController,
                              label: 'Experience',
                              icon: Icons.work,
                              originalValue: _originalExperience,
                              fieldName: 'experience',
                              maxLines: 2,
                            ),

                            _buildTextField(
                              controller: _qualificationsController,
                              label: 'Qualifications',
                              icon: Icons.school,
                              originalValue: _originalQualifications,
                              fieldName: 'qualifications',
                              maxLines: 2,
                            ),

                            _buildTextField(
                              controller: _skillsController,
                              label: 'Skills',
                              icon: Icons.star,
                              originalValue: _originalSkills,
                              fieldName: 'skills',
                              maxLines: 2,
                            ),

                            if (_isEditing) ...[
                              SizedBox(height: 16),
                              Text(
                                'Change Password (Optional)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16),

                              _buildTextField(
                                controller: _currentPasswordController,
                                label: 'Current Password',
                                icon: Icons.lock,
                                originalValue: '',
                                fieldName: 'currentPassword',
                                isPassword: true,
                                showPassword: _showCurrentPassword,
                                togglePasswordVisibility: () {
                                  setState(() {
                                    _showCurrentPassword =
                                        !_showCurrentPassword;
                                  });
                                },
                              ),

                              _buildTextField(
                                controller: _newPasswordController,
                                label: 'New Password',
                                icon: Icons.lock_outline,
                                originalValue: '',
                                fieldName: 'newPassword',
                                isPassword: true,
                                showPassword: _showNewPassword,
                                togglePasswordVisibility: () {
                                  setState(() {
                                    _showNewPassword = !_showNewPassword;
                                  });
                                },
                                validator: (value) {
                                  if (_currentPasswordController
                                          .text
                                          .isNotEmpty &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter a new password';
                                  }
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirm New Password',
                                icon: Icons.lock_outline,
                                originalValue: '',
                                fieldName: 'confirmPassword',
                                isPassword: true,
                                showPassword: _showConfirmPassword,
                                togglePasswordVisibility: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                                validator: (value) {
                                  if (_newPasswordController.text.isNotEmpty &&
                                      value != _newPasswordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],

                            if (_isEditing) ...[
                              SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _cancelEdit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(
                                          0xFFA0C4FD,
                                        ).withOpacity(0.35),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2B3F99),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFA0C4FD),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF2B3F99)),
                                              ),
                                            )
                                          : Text(
                                              'Save Changes',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF2B3F99),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if (!_isEditing) ...[
                              SizedBox(height: 24),
                              // Removed Log Out button here
                            ],
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Reviews Section
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (_isLoadingReviews)
                            Center(child: CircularProgressIndicator())
                          else if (_reviews.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No reviews yet.', style: TextStyle(color: Colors.grey)),
                            )
                          else
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 12),
                                  ..._reviews.map((review) => Card(
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      title: Text(review['guardianName'] ?? 'Guardian'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: List.generate(5, (i) => Icon(
                                              Icons.star,
                                              color: i < (review['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                                              size: 18,
                                            )),
                                          ),
                                          SizedBox(height: 4),
                                          Text(review['reviewText'] ?? ''),
                                          SizedBox(height: 4),
                                          Text(
                                            review['createdAt'] != null
                                                ? DateTime.parse(review['createdAt']).toLocal().toString().split('.')[0]
                                                : '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
            } else if (index == 1) {
              Navigator.pushNamed(context, AppRoutes.caregiverPatients);
            } else if (index == 2) {
              Navigator.pushNamed(context, AppRoutes.viewArticleList);
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF2B3F99),
          unselectedItemColor: Color(0xFF2B3F99),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Community',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void _showGenderPicker() {
    if (!_isEditing) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Gender',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: ListView(
                  children: ['Male', 'Female', 'Other'].map((gender) {
                    return ListTile(
                      title: Text(gender),
                      onTap: () {
                        setState(() {
                          _genderController.text = gender;
                          _modifiedFields.add('gender');
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
