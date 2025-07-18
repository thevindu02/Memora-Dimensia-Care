import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class CaregiverProfileScreen extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<CaregiverProfileScreen> {
  int _currentIndex = 3; // default selected index for Profile tab

  bool receiveNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar and Name
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Profile Image Container
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/caregiver.png'),
                      ),
                      // Online status indicator
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'John Smith',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Primary Caregiver',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Profile Information
            _buildInfoSection('Email', 'john.smith@example.com'),
            _buildInfoSection('Phone Number', '+1 234 567 890'),
            
            // Gender and Birthday Row
            Row(
              children: [
                Expanded(
                  child: _buildInfoSection('Gender', 'Female'),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildInfoSection('Birthday', '2001-01-14'),
                ),
              ],
            ),
            
            _buildInfoSection('Address', 'No. 123, Galle Road\nWestern Province, Colombo'),
            _buildInfoSection('Experience', 'Assisted with daily living activities\nAssisted with homework, mealtime, and bed'),
            _buildInfoSection('Qualifications', 'Experience in hospital, home, or private care'),
            
            // Notifications Toggle
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receive Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Switch(
                    value: receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        receiveNotifications = value;
                      });
                    },
                    activeColor: Color(0xFF6B73FF),
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.caregiverProfileEdit);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9FC3FC),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);

                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) { // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          }else if(index==1){
            Navigator.pushNamed(context, AppRoutes.caregiverPatients);
          }
          else if(index==2){
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          }
          else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),


    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Icon(
        icon,
        color: isActive ? Color(0xFF6B73FF) : Colors.grey[400],
        size: 24,
      ),
    );
  }
}