import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatPartners = [
    {'id': 1, 'name': 'Chamudi Fonseka', 'role': 'Caregiver'},
    {'id': 2, 'name': 'Kamal Perera', 'role': 'Caregiver'},
    // Add more caregivers/guardians as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: chatPartners.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final partner = chatPartners[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                child: Icon(Icons.person, color: AppColors.info),
              ),
              title: Text(
                partner['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
              subtitle: Text(partner['role']),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/chat/conversation',
                  arguments: partner,
                );
              },
            ),
          );
        },
      ),
    );
  }
}