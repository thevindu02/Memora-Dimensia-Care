import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import 'guardian_bottom_nav_bar.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart';
import '../../utils/name_utils.dart';

class GuardianProfileScreen extends StatefulWidget {
  @override
  _GuardianProfileScreenState createState() => _GuardianProfileScreenState();
}

class _GuardianProfileScreenState extends State<GuardianProfileScreen> {
  int _selectedIndex = 3; // Changed from 2 to 3 to match Profile tab
  bool _isEditing = false;
  bool _isLoading = false;
  File? _profileImage;
  File? _originalProfileImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');
  final _genderController = TextEditingController(text: 'Male');
  final _birthdayController = TextEditingController(text: '1990-01-01');
  final _streetController = TextEditingController(text: '123 Main St');
  final _cityController = TextEditingController(text: 'City');
  final _stateController = TextEditingController(text: 'State');
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Store original values to compare
  String _originalName = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalGender = '';
  String _originalBirthday = '';
  String _originalStreet = '';
  String _originalCity = '';
  String _originalState = '';

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3; // Updated to match Profile tab index
    _fetchGuardianProfile();
  }

  Future<void> _fetchGuardianProfile() async {
    setState(() {
      _isLoading = true;
    });

    final userId = await AuthService.getCurrentUserId();
    if (userId != null) {
      final guardianId = await GuardianService.getGuardianIdByUserId(userId);
      if (guardianId != null) {
        final profile = await GuardianService.getGuardianDetailsById(
          guardianId,
        );
        if (profile != null) {
          _nameController.text = NameUtils.capitalizeName(
            profile['name'] ?? '',
          );
          _emailController.text = profile['email'] ?? '';
          _phoneController.text = profile['phone'] ?? '';
          _genderController.text = profile['gender'] ?? '';
          _birthdayController.text = profile['birthday'] ?? '';

          // Set separate address fields
          _streetController.text = profile['street'] ?? '';
          _cityController.text = profile['city'] ?? '';
          _stateController.text = profile['state'] ?? '';

          // Store original values for edit/cancel logic
          _originalName = _nameController.text;
          _originalEmail = _emailController.text;
          _originalPhone = _phoneController.text;
          _originalGender = _genderController.text;
          _originalBirthday = _birthdayController.text;
          _originalStreet = _streetController.text;
          _originalCity = _cityController.text;
          _originalState = _stateController.text;
        }
      }
    }

    setState(() {
      _isLoading = false;
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Track which fields have been modified
  Set<String> _modifiedFields = {};
  Set<String> _focusedFields = {};

  // Check if any changes have been made
  bool _hasChanges() {
    return _nameController.text != _originalName ||
        _emailController.text != _originalEmail ||
        _phoneController.text != _originalPhone ||
        _genderController.text != _originalGender ||
        _birthdayController.text != _originalBirthday ||
        _streetController.text != _originalStreet ||
        _cityController.text != _originalCity ||
        _stateController.text != _originalState ||
        _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty ||
        _profileImage != _originalProfileImage;
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

    // If field has been modified, show black text
    if (_modifiedFields.contains(fieldName)) {
      return Colors.black87;
    }

    // If field contains original value, show grey text
    if (currentValue == originalValue) {
      return Colors.grey[500]!;
    }

    return Colors.black87;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    // Reset to original values but STAY in editing mode
    setState(() {
      _nameController.text = _originalName;
      _emailController.text = _originalEmail;
      _phoneController.text = _originalPhone;
      _genderController.text = _originalGender;
      _birthdayController.text = _originalBirthday;
      _streetController.text = _originalStreet;
      _cityController.text = _originalCity;
      _stateController.text = _originalState;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _modifiedFields.clear();
      _focusedFields.clear();
      _profileImage = _originalProfileImage;
      // Keep _isEditing = true - stay in editing mode
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Combine address fields for backend
      String combinedAddress = '';
      if (_streetController.text.isNotEmpty) {
        combinedAddress = _streetController.text;
      }
      if (_cityController.text.isNotEmpty) {
        if (combinedAddress.isNotEmpty) combinedAddress += ', ';
        combinedAddress += _cityController.text;
      }
      if (_stateController.text.isNotEmpty) {
        if (combinedAddress.isNotEmpty) combinedAddress += ', ';
        combinedAddress += _stateController.text;
      }

      final userId = await AuthService.getCurrentUserId();
      final guardianId = await GuardianService.getGuardianIdByUserId(userId!);

      final nameParts = _nameController.text.trim().split(' ');
      final fName = nameParts.isNotEmpty ? nameParts.first : '';
      final lName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final success = await GuardianService.updateProfile(
        guardianId: guardianId!,
        fName: fName,
        lName: lName,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        gender: _genderController.text,
        birthdate: _birthdayController.text,
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        profilePic: '', // or your image path
      );

      if (success) {
        // Show success message and update original values
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Update original values
      _originalName = _nameController.text;
      _originalEmail = _emailController.text;
      _originalPhone = _phoneController.text;
      _originalGender = _genderController.text;
      _originalBirthday = _birthdayController.text;
      _originalStreet = _streetController.text;
      _originalCity = _cityController.text;
      _originalState = _stateController.text;
      _originalProfileImage = _profileImage;

      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Here you would typically upload the image to your server
      // and save the image path or URL to your database
      if (_profileImage != null) {
        // TODO: Implement image upload to server
        print('Profile image path: ${_profileImage!.path}');
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
            // Field lost focus, check if it's empty and restore original value
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
                // Clear the field when tapped in edit mode if it contains original value
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

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Use the navigation helper from the custom bottom nav bar
    BottomNavHelper.handleNavigation(context, index);
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.guardianDashboard,
      (route) => false,
    );
  }

  Future<bool> _onWillPop() async {
    if (_isEditing) {
      print('Exiting edit mode, staying on profile (WillPopScope)');
      setState(() {
        _isEditing = false;
      });
      return false; // Stay on profile screen
    } else {
      print('Navigating to dashboard (WillPopScope)');
      _navigateToHome();
      return false; // Prevent default pop, handle navigation
    }
  }

  void _selectDate() async {
    if (!_isEditing) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () {
              if (_isEditing) {
                print('Exiting edit mode, staying on profile (AppBar)');
                setState(() {
                  _isEditing = false;
                });
              } else {
                print('Navigating to dashboard (AppBar)');
                _navigateToHome();
              }
            },
          ),
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
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
                    color: AppColors.info,
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
                color: AppColors.surface,
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.onSurfaceVariant,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(
                                  Icons.person,
                                  color: AppColors.onPrimary,
                                  size: 35,
                                )
                              : null,
                        ),
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
                                  color: AppColors.info,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.onPrimary,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.onPrimary,
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
                          _nameController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Guardian',
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
                              onTap: _isEditing ? _showGenderPicker : null,
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
                        'Address Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      _buildTextField(
                        controller: _streetController,
                        label: 'Street Address',
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
                                  return 'Please enter your state';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
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
                              _showCurrentPassword = !_showCurrentPassword;
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
                            if (_currentPasswordController.text.isNotEmpty &&
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
                              _showConfirmPassword = !_showConfirmPassword;
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
                                  backgroundColor: AppColors.primaryLight
                                      .withOpacity(0.35),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.info,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        'Save Changes',
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
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }
}
