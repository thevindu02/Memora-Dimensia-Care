import 'package:flutter/material.dart';

class PatientBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PatientBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70, // Reduced height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.dashboard,
                label: 'Dashboard',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications,
                label: 'Notifications',
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.games,
                label: 'Games',
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6), // Reduced padding
              decoration: BoxDecoration(
                color: isActive ? Colors.blue[100] : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? Colors.blue : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 22, // Slightly smaller icon
                color: isActive ? Colors.blue[700] : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 2), // Reduced spacing
            Flexible( // Added Flexible to prevent overflow
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10, // Reduced font size
                  color: isActive ? Colors.blue[700] : Colors.grey[500],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
                maxLines: 1, // Ensure single line
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative implementation with stroke-only inactive items
class PatientBottomNavigationBarStroke extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PatientBottomNavigationBarStroke({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.dashboard,
                label: 'Dashboard',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.notifications,
                label: 'Notifications',
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.games,
                label: 'Games',
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue[700] : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? Colors.blue[700]! : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? Colors.blue[700] : Colors.grey[500],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple icon-only bottom navigation with stroke
class PatientBottomNavigationBarIconOnly extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PatientBottomNavigationBarIconOnly({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconOnlyNavItem(
                index: 0,
                icon: Icons.dashboard,
                isActive: currentIndex == 0,
              ),
              _buildIconOnlyNavItem(
                index: 1,
                icon: Icons.person,
                isActive: currentIndex == 1,
              ),
              _buildIconOnlyNavItem(
                index: 2,
                icon: Icons.notifications,
                isActive: currentIndex == 2,
              ),
              _buildIconOnlyNavItem(
                index: 3,
                icon: Icons.games,
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOnlyNavItem({
    required int index,
    required IconData icon,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.blue[700]! : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? Colors.white : Colors.grey[500],
        ),
      ),
    );
  }
}