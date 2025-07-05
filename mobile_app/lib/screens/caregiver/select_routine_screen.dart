import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SelectType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Routine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: ScheduleRoutineScreen(),
    );
  }
}

class RoutineCard {
  final String title;
  final String buttonText;
  final Color backgroundColor;
  final Color buttonColor;
  final IconData icon;

  RoutineCard({
    required this.title,
    required this.buttonText,
    required this.backgroundColor,
    required this.buttonColor,
    required this.icon,
  });
}

class ScheduleRoutineScreen extends StatefulWidget {
  @override
  _ScheduleRoutineScreenState createState() => _ScheduleRoutineScreenState();
}

class _ScheduleRoutineScreenState extends State<ScheduleRoutineScreen> {
  int _currentIndex = 1; // Routines tab selected

  final List<RoutineCard> routineCards = [
    RoutineCard(
      title: 'Daily Activities',
      buttonText: 'Add Daily Activities',
      backgroundColor: Color(0xFFE3F2FD), // Light blue
      buttonColor: Color(0xFF2196F3), // Blue
      icon: Icons.calendar_today,
    ),
    RoutineCard(
      title: 'Task Management',
      buttonText: 'Add Task',
      backgroundColor: Color(0xFFFCE4EC), // Light pink
      buttonColor: Color(0xFFE91E63), // Pink
      icon: Icons.radio_button_unchecked,
    ),
    RoutineCard(
      title: 'Medication',
      buttonText: 'Add Medication Reminders',
      backgroundColor: Color(0xFFE8F5E8), // Light green
      buttonColor: Color(0xFF4CAF50), // Green
      icon: Icons.calendar_today,
    ),
    RoutineCard(
      title: 'Appointment',
      buttonText: 'Add Appointments',
      backgroundColor: Color(0xFFFFEBEE), // Light red
      buttonColor: Color(0xFFF44336), // Red
      icon: Icons.radio_button_unchecked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
        title: Text(
          'Schedule Routine',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Routine Cards
            Expanded(
              child: ListView.builder(
                itemCount: routineCards.length,
                itemBuilder: (context, index) {
                  return _buildRoutineCard(routineCards[index]);
                },
              ),
            ),
            
            SizedBox(height: 16),
            
            // Today Routine Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C9BD1), // Medium blue
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Today Routine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              activeIcon: Icon(Icons.book),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(RoutineCard card) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: card.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Title
            Text(
              card.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Action Button
            Container(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: card.buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      card.icon,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      card.buttonText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}