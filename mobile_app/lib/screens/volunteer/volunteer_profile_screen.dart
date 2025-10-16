import 'package:flutter/material.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VolunteerProfileScreen extends StatefulWidget {
  const VolunteerProfileScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  bool isEditMode = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final TextEditingController _fullNameController = TextEditingController(
    text: 'John Smith',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'john.smith@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 (555) 123-4567',
  );
  final TextEditingController _genderController = TextEditingController(
    text: 'Male',
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.black),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.black),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.volunteerDashboard);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
            child: Text(
              isEditMode ? 'Save' : 'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.outline,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : NetworkImage(
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                                )
                                as ImageProvider,
                    ),
                    if (isEditMode)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 18,
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
                      'John Smith',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Volunteer',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),

            // Personal Information Section
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: 24),

            // Full Name
            _buildInfoItem(
              Icons.person_outline,
              'Full Name',
              _fullNameController,
            ),
            SizedBox(height: 16),

            // Email
            _buildInfoItem(Icons.email_outlined, 'Email', _emailController),
            SizedBox(height: 16),

            // Phone Number
            _buildInfoItem(
              Icons.phone_outlined,
              'Phone Number',
              _phoneController,
            ),
            SizedBox(height: 16),

            // Gender
            _buildInfoItem(
              Icons.person_2_outlined,
              'Gender',
              _genderController,
            ),
            SizedBox(height: 32),

            // Remove the line '// Settings Section' and any other stray comments related to settings
            SizedBox(height: 100), // Add some bottom padding
          ],
        ),
      ),
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'profile'),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditMode ? AppColors.info : AppColors.outline,
              width: isEditMode ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: isEditMode
                    ? TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        controller.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title, {
    bool hasToggle = false,
    bool hasDropdown = false,
    bool hasArrow = false,
    bool isEnabled = false,
    String? dropdownValue,
    Function(bool)? onToggle,
    Function(String?)? onDropdownChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: hasArrow ? onTap : null,
      child: Container(
        height: 56, // Fixed height for all settings items
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[500], size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (hasToggle)
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue.withOpacity(0.3),
                inactiveTrackColor: Colors.grey[300],
                inactiveThumbColor: Colors.white,
              ),
            if (hasDropdown)
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: onDropdownChanged,
                underline: SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                items:
                    [
                      'English',
                      'Spanish',
                      'French',
                      'German',
                      'Chinese',
                      'Arabic',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
              ),
            if (hasArrow)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
