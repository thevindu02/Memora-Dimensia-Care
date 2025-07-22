import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'volunteer_registration_completed_screen.dart';
import '../../services/user_service.dart';
import '../../services/image_upload_service.dart';
import '../../services/volunteer_request_service.dart';

class VolunteerSignupScreen extends StatefulWidget {
  const VolunteerSignupScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerSignupScreen> createState() => _VolunteerSignupScreenState();
}

class _VolunteerSignupScreenState extends State<VolunteerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = '';
  bool genderError = false;
  bool imageError = false;
  bool _isSubmitting = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        imageError = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Name Field
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                      color: Color(0xFFA09CAB),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Last Name Field
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    hintStyle: TextStyle(
                      color: Color(0xFFA09CAB),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Add instruction above email field
                const Text(
                  'Please enter the email address given by your organization',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Email Address Field
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      color: Color(0xFFA09CAB),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Phone Number Field
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          '+94',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                            color: Color(0xFFA09CAB),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          final phone = value.replaceAll(RegExp(r'\D'), '');
                          if (!RegExp(r'^0[0-9]{9}$').hasMatch(phone)) {
                            return 'Enter a valid Sri Lankan phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Gender Field
                GestureDetector(
                  onTap: () {
                    _showGenderPicker();
                    setState(() {
                      genderError = false;
                    });
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      hintStyle: TextStyle(
                        color: Color(0xFFA09CAB),
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      errorText: genderError ? 'Gender is required' : null,
                      suffixIcon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFA09CAB)),
                    ),
                    child: Text(
                      selectedGender.isEmpty ? 'Gender' : selectedGender,
                      style: TextStyle(
                        color: selectedGender.isEmpty
                            ? Color(0xFFA09CAB)
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Volunteer ID Image Upload Section
                const Text(
                  'Volunteer ID Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                    border: imageError
                        ? Border.all(color: Colors.red, width: 2)
                        : _selectedImage != null
                        ? Border.all(color: Color(0xFF2B3F99), width: 2)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Color(0xFFA09CAB),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Upload Volunteer ID Image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFA09CAB),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      if (_selectedImage != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF2B3F99),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (imageError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Volunteer ID image is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Selected: \\${_selectedImage!.path.split('/').last}',
                      style: TextStyle(
                        color: Color(0xFF2B3F99),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Please upload a clear image of your volunteer id',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _showImageSourceDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA0C4FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _selectedImage != null ? 'Change Image' : 'Choose Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            setState(() {
                              genderError = selectedGender.isEmpty;
                              imageError = _selectedImage == null;
                            });
                            if (_formKey.currentState!.validate() &&
                                selectedGender.isNotEmpty &&
                                _selectedImage != null) {
                              setState(() {
                                _isSubmitting = true;
                              });

                              try {
                                // Upload image to server
                                final imageUploadResult =
                                    await ImageUploadService.uploadImage(
                                      _selectedImage!,
                                    );

                                String imageUrl;
                                if (imageUploadResult.success) {
                                  imageUrl = imageUploadResult.imageUrl!;
                                } else {
                                  // Try fallback method
                                  final fallbackResult =
                                      await ImageUploadService.uploadImageFallback(
                                        _selectedImage!,
                                      );
                                  if (!fallbackResult.success) {
                                    throw Exception('Failed to upload image');
                                  }
                                  imageUrl = fallbackResult.imageUrl!;
                                }

                                final result = await UserService.addUser(
                                  FName: firstNameController.text.trim(),
                                  LName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password:
                                      'password123', // TODO: collect real password
                                  role: 'VOLUNTEER',
                                  status: 'INACTIVE',
                                  phoneNumber: phoneController.text.trim(),
                                  gender: selectedGender,
                                );

                                if (result.success) {
                                  // Create volunteer request with the uploaded image
                                  final volunteerRequestResult =
                                      await VolunteerRequestService.createVolunteerRequest(
                                        userId: result.userId!,
                                        volunteerIdImage: imageUrl,
                                      );

                                  if (!volunteerRequestResult.success) {
                                    throw Exception(
                                      'Failed to create volunteer request: \\${volunteerRequestResult.message}',
                                    );
                                  }
                                }

                                setState(() {
                                  _isSubmitting = false;
                                });

                                if (result.success) {
                                  // Show success message with volunteer request info
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Registration successful! Your volunteer request is pending approval.',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VolunteerRegistrationCompletedScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result.message)),
                                  );
                                }
                              } catch (e) {
                                setState(() {
                                  _isSubmitting = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: \\${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA0C4FD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2B3F99),
                              ),
                            ),
                          )
                        : const Text(
                            'Submit Registration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2B3F99),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Other'),
                onTap: () {
                  setState(() {
                    selectedGender = 'Other';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
