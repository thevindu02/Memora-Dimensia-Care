import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Image
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Name and ID
                  const Text(
                    'Sarah Johnson',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Patient ID: #P12345',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Member since 2023',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Personal Information
            _buildSection(
              title: 'Personal Information',
              children: [
                _buildInfoRow(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  value: 'March 15, 1985',
                  trailing: '38 years old',
                ),
                _buildInfoRow(
                  icon: Icons.person_outline,
                  label: 'Gender',
                  value: 'Female',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Contact Information
            _buildSection(
              title: 'Contact Information',
              children: [
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: '+1 (555) 123-4567',
                ),
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email Address',
                  value: 'sarah.johnson@email.com',
                ),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: '123 Oak Street, Apt 4B\nSpringfield, IL 62701',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Emergency Contact
            _buildSection(
              title: 'Emergency Contact',
              children: [
                _buildInfoRow(
                  icon: Icons.person_outline,
                  label: 'Contact Name',
                  value: 'Michael Johnson (Spouse)',
                ),
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: '+1 (555) 987-6543',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Medical Information
            _buildSection(
              title: 'Medical Information',
              children: [
                _buildInfoRow(
                  icon: Icons.warning_amber_outlined,
                  label: 'Allergies',
                  value: 'Penicillin, Shellfish',
                  iconColor: Colors.red,
                ),
                _buildInfoRow(
                  icon: Icons.medication_outlined,
                  label: 'Current Medications',
                  value: 'Lisinopril 10mg daily\nMetformin 500mg twice daily',
                  iconColor: Colors.blue,
                ),
                _buildInfoRow(
                  icon: Icons.favorite_outline,
                  label: 'Medical Conditions',
                  value: 'Type 2 Diabetes, Hypertension',
                  iconColor: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Insurance Information
            _buildSection(
              title: 'Insurance Information',
              children: [
                _buildInfoRow(
                  icon: Icons.shield_outlined,
                  label: 'Insurance Provider',
                  value: 'Blue Cross Blue Shield',
                ),
                _buildInfoRow(
                  icon: Icons.credit_card_outlined,
                  label: 'Policy Number',
                  value: 'BCBS123456789',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Download Medical Records',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Share Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    String? trailing,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}