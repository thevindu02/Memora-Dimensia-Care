import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';

class GuardianCaregiverDetailsScreen extends StatelessWidget {
  const GuardianCaregiverDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caregiver = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    // Backend returns fName/lName (camelCase from CaregiverSummaryResponse)
    final firstName = (caregiver['fName'] ?? caregiver['FName'] ?? '').toString().trim();
    final lastName = (caregiver['lName'] ?? caregiver['LName'] ?? '').toString().trim();
    final name = '$firstName $lastName'.trim();
    final email = caregiver['email'] ?? 'N/A';
    final experience = caregiver['experience'] ?? 'N/A';
    final qualifications = caregiver['qualifications'] ?? 'N/A';
    final status = caregiver['status']?.toString().toLowerCase() ?? 'active';
    final isActive = status == 'active';
    final caregiverId = caregiver['caregiverId'] ?? caregiver['caregiver_id'] ?? caregiver['id'];

    // Only show Messages button if caregiver is active OR inactive (has worked before)
    final canShowMessages = isActive || status == 'inactive';

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Caregiver Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: isActive ? Colors.green.withOpacity(0.1) : Colors.red.shade50,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: isActive ? Colors.green : Colors.red.shade400,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    name.isNotEmpty ? name : 'Unknown',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green.withOpacity(0.12) : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? Colors.green.withOpacity(0.25) : Colors.red.shade200,
                      ),
                    ),
                    child: Text(
                      isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        color: isActive ? Colors.green.shade700 : Colors.red.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            
            // Details section
            _buildDetailRow(Icons.email, 'Email', email),
            SizedBox(height: 16),
            _buildDetailRow(Icons.work, 'Experience', experience),
            SizedBox(height: 16),
            _buildDetailRow(Icons.school, 'Qualifications', qualifications),
            SizedBox(height: 32),
            
            // Messages button (only if active or inactive - has chat history)
            if (canShowMessages)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (caregiverId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Caregiver ID not available')),
                      );
                      return;
                    }
                    Navigator.pushNamed(
                      context,
                      AppRoutes.chatConversation,
                      arguments: {
                        'id': caregiverId,
                        'name': name,
                        'currentUser': 'guardian',
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.info,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Messages',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.info, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}