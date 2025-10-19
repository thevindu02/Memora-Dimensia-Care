import 'package:flutter/material.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/image_upload_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VolunteerProfileScreen extends StatefulWidget {
  final int volunteerId;
  const VolunteerProfileScreen({Key? key, required this.volunteerId}) : super(key: key);

  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isLoadingData = true;
  File? _profileImage; // Mobile only
  File? _originalProfileImage;
  final ImagePicker _picker = ImagePicker();

  int? _userId;

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Store original values to compare
  String _originalName = '';
  String _originalEmail = '';
  String _originalPhone = '';
  String _originalGender = '';
  String _originalBirthday = '';
  String _originalStreet = '';
  String _originalCity = '';
  String _originalState = '';
  String? _originalProfilePicUrl; // URL from backend
  String? _profilePicUrl; // Current URL (for saving to backend)

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Track which fields have been modified
  Set<String> _modifiedFields = {};
  Set<String> _focusedFields = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      // Get current user ID from AuthService
      final userId = await AuthService.getCurrentUserId();

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        return;
      }

      _userId = userId;

      // Fetch user data from backend
      final userData = await UserService.getUserById(userId);

      if (userData != null) {
        setState(() {
          // Populate controllers with real data
          final fName = userData['fname'] ?? userData['fName'] ?? '';
          final lName = userData['lname'] ?? userData['lName'] ?? '';
          final fullName = '$fName $lName'.trim();

          _fullNameController.text = fullName;
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _genderController.text = userData['gender'] ?? '';
          _birthdayController.text = userData['birthdate'] ?? '';
          _streetController.text = userData['street'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _stateController.text = userData['state'] ?? '';

          // Load profile picture URL from backend
          _profilePicUrl = userData['profilePic'];
          _originalProfilePicUrl = userData['profilePic'];

          // Store original values
          _originalName = fullName;
          _originalEmail = userData['email'] ?? '';
          _originalPhone = userData['phoneNumber'] ?? '';
          _originalGender = userData['gender'] ?? '';
          _originalBirthday = userData['birthdate'] ?? '';
          _originalStreet = userData['street'] ?? '';
          _originalCity = userData['city'] ?? '';
          _originalState = userData['state'] ?? '';

          _isLoadingData = false;
        });
      } else {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingData = false;
      });
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

  Future<void> _loadVolunteerProfile() async {
    setState(() => _isLoading = true);
    final data = await VolunteerService.getVolunteerProfile(widget.volunteerId);
    if (data != null) {
      setState(() {
        _firstNameController.text = data['FName'] ?? data['f_name'] ?? data['fname'] ?? '';
        _lastNameController.text = data['LName'] ?? data['l_name'] ?? data['lname'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? data['phone_number'] ?? '';
        _genderController.text = data['gender'] ?? '';
        _originalName = '${data['FName']} ${data['LName']}';
        _originalEmail = _emailController.text;
        _originalPhone = _phoneController.text;
        _originalGender = _genderController.text;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
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
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Update UI immediately to show selected image
        setState(() {
          _profileImage = File(pickedFile.path); // Convert XFile to File
        });

        // Upload image to backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Uploading image...'),
              ],
            ),
            duration: Duration(seconds: 10),
          ),
        );

        // Pass XFile directly - works on both web and mobile
        final uploadResult = await ImageUploadService.uploadImage(
          pickedFile,
          type: 'profile',
        );

        // Hide loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (uploadResult.success && uploadResult.imageUrl != null) {
          setState(() {
            _profilePicUrl = uploadResult.imageUrl;
            _modifiedFields.add('profilePic');
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Upload failed, remove the local image
          setState(() {
            _profileImage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: ${uploadResult.message}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
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
      _profilePicUrl = null; // Clear the URL so it will be saved as null
      _modifiedFields.add('profilePic');
    });
  }

  // Helper method to get ImageProvider (mobile only)
  ImageProvider? _getImageProvider(File? imageFile, String? networkUrl) {
    if (imageFile != null) {
      return FileImage(imageFile);
    } else if (networkUrl != null) {
      return NetworkImage(networkUrl);
    }
    return null;
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
      _firstNameController.text = _originalName.split(' ').first;
      _lastNameController.text = _originalName.split(' ').length > 1 ? _originalName.split(' ').sublist(1).join(' ') : '';
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
      _profilePicUrl = _originalProfilePicUrl; // Restore original URL
      // Keep _isEditing = true - stay in editing mode
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Split full name into first and last name
        final nameParts = _fullNameController.text.trim().split(' ');
        final fName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lName = nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : '';

        // Call backend to update user (including profile picture URL)
        final result = await UserService.updateUser(
          userId: _userId!,
          FName: fName,
          LName: lName,
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          gender: _genderController.text.trim(),
          birthdate: _birthdayController.text.trim(),
          street: _streetController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          profilePic: _profilePicUrl, // Include uploaded image URL
        );

        // Handle password change separately if provided
        bool passwordChanged = false;
        if (_currentPasswordController.text.isNotEmpty &&
            _newPasswordController.text.isNotEmpty) {
          final passwordResult = await UserService.changePassword(
            userId: _userId!,
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );

          if (!passwordResult.success) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(passwordResult.message),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
            return; // Stop if password change failed
          }
          passwordChanged = true;
        }

        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          // Update original values
          _originalName = _fullNameController.text;
          _originalEmail = _emailController.text;
          _originalPhone = _phoneController.text;
          _originalGender = _genderController.text;
          _originalBirthday = _birthdayController.text;
          _originalStreet = _streetController.text;
          _originalCity = _cityController.text;
          _originalState = _stateController.text;
          _originalProfileImage = _profileImage;
          _originalProfilePicUrl = _profilePicUrl; // Save the URL as original

          setState(() {
            _isEditing = false;
          });

          String successMessage = 'Profile updated successfully!';
          if (passwordChanged) {
            successMessage = 'Profile and password updated successfully!';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Clear password fields
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          // Reload user data to sync with backend
          await _loadUserData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        print('Error saving profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile. Please try again.'),
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

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while fetching data
    if (_isLoadingData) {
      return Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.volunteerDashboard);
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
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryLight),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () {
            if (_isEditing) {
              setState(() {
                _isEditing = false;
              });
            } else {
              Navigator.pushNamed(context, AppRoutes.volunteerDashboard);
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
            // Profile Header (only show when not editing)
            if (!_isEditing)
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
                          backgroundImage: _getImageProvider(
                            _profileImage,
                            _profilePicUrl,
                          ),
                          child: _profileImage == null && _profilePicUrl == null
                              ? Icon(
                                  Icons.person,
                                  color: AppColors.onPrimary,
                                  size: 35,
                                )
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullNameController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Volunteer',
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

                    // Profile Picture Section (show when editing)
                    if (_isEditing) ...[
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.onSurfaceVariant,
                                  backgroundImage: _getImageProvider(
                                    _profileImage,
                                    _profilePicUrl,
                                  ),
                                  child:
                                      _profileImage == null &&
                                          _profilePicUrl == null
                                      ? Icon(
                                          Icons.person,
                                          color: AppColors.onPrimary,
                                          size: 50,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showImagePickerDialog,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppColors.primaryLight,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _showImagePickerDialog,
                              icon: Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.info,
                              ),
                              label: Text(
                                'Change Profile Picture',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],

                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    originalValue: _originalName,
                    fieldName: 'name',
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
      bottomNavigationBar: VolunteerBottomNavigation(
        currentPage: 'profile',
        volunteerId: widget.volunteerId, // <-- Pass volunteerId here
      ),
    );
  }
}
