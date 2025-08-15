import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/guardian_service.dart';
import '../../constants/color_constants.dart';
import '../../utils/name_utils.dart';

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
  String? resultMessage;

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

  Future<void> _verifyEmail() async {
    final enteredEmail = emailController.text.trim();

    if (enteredEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the caregiver\'s email address',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(enteredEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid email address',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final guardianId =
          selectedPatient?['guardianId'] ?? selectedPatient?['guardian_id'];
      final patientId =
          selectedPatient?['patientId'] ?? selectedPatient?['patient_id'];

      if (guardianId == null || patientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Missing patient or guardian information',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await GuardianService.addKnownCaregiver(
        guardianId: guardianId,
        patientId: patientId,
        caregiverEmail: enteredEmail,
      );

      setState(() {
        isLoading = false;
      });

      // Check if response indicates success
      if (response.contains('successfully')) {
        // Extract caregiver name from response if possible
        String caregiverName = 'Caregiver';
        RegExp nameRegex = RegExp(r'connected to (.+)$');
        Match? match = nameRegex.firstMatch(response);
        if (match != null) {
          caregiverName = match.group(1) ?? 'Caregiver';
          // Capitalize first letter of each word
          caregiverName = caregiverName
              .split(' ')
              .map(
                (word) => word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                    : word,
              )
              .join(' ');
        }

        // Get patient name for the success message
        String patientName = NameUtils.formatPatientName(selectedPatient ?? {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$patientName has been successfully connected to $caregiverName!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.guardianAddCaregiver,
          );
        });
      } else {
        // Handle error cases
        String errorMessage = response;
        if (response.contains('No caregiver found')) {
          errorMessage =
              'No caregiver found with this email address. Please check the email and try again.';
        } else if (response.contains('pending request already exists')) {
          errorMessage =
              'A connection request is already pending with this caregiver.';
        } else if (response.contains('maximum patient capacity')) {
          errorMessage =
              'This caregiver has reached their maximum patient capacity and cannot take on additional patients.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Network error occurred. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
                      NameUtils.formatPatientName(selectedPatient ?? {}),
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
