import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';

class GuardianAddKnownCaregiverScreen extends StatefulWidget {
  @override
  _GuardianAddKnownCaregiverScreenState createState() => _GuardianAddKnownCaregiverScreenState();
}

class _GuardianAddKnownCaregiverScreenState extends State<GuardianAddKnownCaregiverScreen> {
  Map<String, dynamic>? selectedPatient;
  List<TextEditingController> codeControllers = [];
  List<FocusNode> focusNodes = [];
  bool isLoading = false;

  // Mock valid codes (in real app, this would be checked against database)
  final List<String> validCodes = [
    'CRG001',
    'CRG002',
    'CRG003',
    'CRG004',
    'CRG005',
  ];

  // Mock caregiver data for valid codes
  final Map<String, Map<String, dynamic>> caregiverDatabase = {
    'CRG001': {
      'name': 'Sarah Johnson',
      'specialization': 'Elderly Care',
      'experience': '5 years',
      'location': 'Colombo',
    },
    'CRG002': {
      'name': 'Michael Fernando',
      'specialization': 'Disability Care',
      'experience': '3 years',
      'location': 'Kandy',
    },
    'CRG003': {
      'name': 'Priya Perera',
      'specialization': 'Medical Care',
      'experience': '7 years',
      'location': 'Galle',
    },
    'CRG004': {
      'name': 'David Silva',
      'specialization': 'Elderly Care',
      'experience': '4 years',
      'location': 'Colombo',
    },
    'CRG005': {
      'name': 'Nimali Rathnayake',
      'specialization': 'Rehabilitation',
      'experience': '6 years',
      'location': 'Kandy',
    },
  };

  @override
  void initState() {
    super.initState();
    // Initialize 6 controllers and focus nodes for 6-digit code
    for (int i = 0; i < 6; i++) {
      codeControllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }

    // Get the selected patient from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          selectedPatient = args;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getEnteredCode() {
    return codeControllers.map((controller) => controller.text).join();
  }

  void _clearCode() {
    for (var controller in codeControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
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
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 50,
                    color: isSuccess ? Colors.green : Colors.red,
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
                      ? 'Great! $caregiverName has been successfully connected as a caregiver for ${selectedPatient?['name']}. They will now be able to access and manage care information.'
                      : 'The caregiver code you entered is invalid. Please check the code and try again. Make sure you have entered the exact 6-character code provided by the caregiver.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
                        // Clear the code and stay on the same screen
                        _clearCode();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess ? Colors.green : Color(0xFF2B3F99),
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

  Future<void> _verifyCode() async {
    final enteredCode = _getEnteredCode();

    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Check if code is valid
    if (validCodes.contains(enteredCode)) {
      final caregiverInfo = caregiverDatabase[enteredCode];
      _showResultDialog(
        isSuccess: true,
        caregiverName: caregiverInfo?['name'],
      );
    } else {
      _showResultDialog(isSuccess: false);
    }
  }

  Widget _buildCodeInput(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: codeControllers[index].text.isNotEmpty
              ? Color(0xFF2B3F99)
              : Colors.grey.withOpacity(0.3),
          width: codeControllers[index].text.isNotEmpty ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: codeControllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        maxLength: 1,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next field
            if (index < 5) {
              focusNodes[index + 1].requestFocus();
            } else {
              // Last field, unfocus
              focusNodes[index].unfocus();
            }
          } else {
            // Move to previous field if backspace
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }
          setState(() {}); // Trigger rebuild to update border color
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Known Caregiver',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
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
                  color: Color(0xFFA0C4FD).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFA0C4FD).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF2B3F99),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Adding caregiver for: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      selectedPatient!['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3F99),
                      ),
                    ),
                  ],
                ),
              ),

            // Instruction section
            Text(
              'Enter Caregiver Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Please enter the 6-character code provided by your caregiver. This code is unique to each caregiver and was given to them during registration.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 32),

            // Code input section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 6; i++) _buildCodeInput(i),
              ],
            ),
            SizedBox(height: 24),

            // Clear button
            Center(
              child: TextButton(
                onPressed: _clearCode,
                child: Text(
                  'Clear Code',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),

            // Example codes (for demo purposes)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Demo Codes (for testing)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try: CRG001, CRG002, CRG003, CRG004, or CRG005',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: isLoading || _getEnteredCode().length != 6 ? null : _verifyCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2B3F99),
            foregroundColor: Colors.white,
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
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            'Connect Caregiver',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}