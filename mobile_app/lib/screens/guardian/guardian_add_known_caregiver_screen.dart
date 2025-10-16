import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/guardian_service.dart';
import '../../constants/color_constants.dart';

class GuardianAddKnownCaregiverScreen extends StatefulWidget {
  @override
  _GuardianAddKnownCaregiverScreenState createState() =>
      _GuardianAddKnownCaregiverScreenState();
}

class _GuardianAddKnownCaregiverScreenState
    extends State<GuardianAddKnownCaregiverScreen> {
  Map<String, dynamic>? selectedPatient;
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool isLoading = false;
  bool isSubmitting = false;
  String? resultMessage;

  // Mock caregiver emails for demo
  final List<String> validEmails = [
    'sarah.johnson@email.com',
    'michael.chen@email.com',
    'emily.rodriguez@email.com',
    'david.thompson@email.com',
    'lisa.wang@email.com',
  ];

  @override
  void initState() {
    super.initState();
    // Get the selected patient from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          selectedPatient = args;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void _clearEmail() {
    emailController.clear();
    emailFocusNode.requestFocus();
  }

  void _showResultDialog({required bool isSuccess, String? caregiverName}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 50,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  isSuccess ? 'Connection Successful!' : 'Connection Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  isSuccess
                      ? 'Great! $caregiverName has been successfully connected as a caregiver for '
                            '${(selectedPatient?['name'] ?? selectedPatient?['fName'] ?? selectedPatient?['FName'] ?? selectedPatient?['fname'] ?? '').toString().trim().isEmpty ? 'N/A' : (selectedPatient?['name'] ?? selectedPatient?['fName'] ?? selectedPatient?['FName'] ?? selectedPatient?['fname'] ?? '')}. They will now be able to access and manage care information.'
                      : 'No caregiver found with this email address. Please check the email and try again. Make sure the caregiver is registered in our system.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (isSuccess) {
                        // Navigate to dashboard
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.guardianDashboard,
                          (route) => false,
                        );
                      } else {
                        // Clear the email and stay on the same screen
                        _clearEmail();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess
                          ? AppColors.success
                          : AppColors.info,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSuccess ? 'Go to Dashboard' : 'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _verifyEmail() async {
    final enteredEmail = emailController.text.trim();

    if (enteredEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the caregiver\'s email address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(enteredEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    // Check if the entered email is valid
    if (validEmails.contains(enteredEmail)) {
      // Mock caregiver name based on email
      String caregiverName = 'Sarah Johnson';
      switch (enteredEmail) {
        case 'sarah.johnson@email.com':
          caregiverName = 'Sarah Johnson';
          break;
        case 'michael.chen@email.com':
          caregiverName = 'Michael Chen';
          break;
        case 'emily.rodriguez@email.com':
          caregiverName = 'Emily Rodriguez';
          break;
        case 'david.thompson@email.com':
          caregiverName = 'David Thompson';
          break;
        case 'lisa.wang@email.com':
          caregiverName = 'Lisa Wang';
          break;
      }

      _showResultDialog(isSuccess: true, caregiverName: caregiverName);
    } else {
      _showResultDialog(isSuccess: false);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _submitKnownCaregiver() async {
    if (selectedPatient == null || emailController.text.trim().isEmpty) {
      setState(() {
        resultMessage = 'Please select a patient and enter caregiver email.';
      });
      return;
    }
    setState(() {
      isSubmitting = true;
      resultMessage = null;
    });
    final guardianId =
        selectedPatient?['guardianId'] ?? selectedPatient?['guardian_id'];
    final patientId =
        selectedPatient?['patientId'] ?? selectedPatient?['patient_id'];
    final caregiverEmail = emailController.text.trim();
    if (guardianId == null || patientId == null) {
      setState(() {
        isSubmitting = false;
        resultMessage = 'Missing guardian or patient ID.';
      });
      return;
    }
    final response = await GuardianService.addKnownCaregiver(
      guardianId: guardianId,
      patientId: patientId,
      caregiverEmail: caregiverEmail,
    );
    setState(() {
      isSubmitting = false;
      resultMessage = response;
    });
    if (response.contains('successfully')) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context, true);
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
        title: Text(
          'Add Known Caregiver',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected patient info
            if (selectedPatient != null)
              Container(
                margin: EdgeInsets.only(bottom: 32),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryLight.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Adding caregiver for: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      (selectedPatient?['name'] ??
                                  selectedPatient?['fName'] ??
                                  selectedPatient?['FName'] ??
                                  selectedPatient?['fname'] ??
                                  '')
                              .toString()
                              .trim()
                              .isEmpty
                          ? 'N/A'
                          : (selectedPatient?['name'] ??
                                selectedPatient?['fName'] ??
                                selectedPatient?['FName'] ??
                                selectedPatient?['fname'] ??
                                ''),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),

            // Instruction section
            Text(
              'Enter Caregiver Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Please enter the email address of the caregiver you want to add. This will search for the caregiver in our system and connect them to your patient.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32),

            // Email input section
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: emailController.text.isNotEmpty
                      ? AppColors.info
                      : AppColors.outline,
                  width: emailController.text.isNotEmpty ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16, color: AppColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'Enter caregiver email address',
                  hintStyle: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild to update border color
                },
              ),
            ),
            SizedBox(height: 24),

            // Clear button
            Center(
              child: TextButton(
                onPressed: _clearEmail,
                child: Text(
                  'Clear Email',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),

            // Result message
            if (resultMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  resultMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: resultMessage!.contains('successfully')
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: isLoading || emailController.text.trim().isEmpty
              ? null
              : _verifyEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.info,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.info,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Search & Connect',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
