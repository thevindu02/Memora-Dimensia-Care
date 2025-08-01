import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.info,
      unselectedItemColor: AppColors.onSurfaceVariant,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article),
          label: 'Articles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer_outlined),
          activeIcon: Icon(Icons.question_answer),
          label: 'Q&A Forums',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

// Navigation helper class to handle navigation logic
class BottomNavHelper {
  static void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Only navigate if not already on dashboard
        if (ModalRoute.of(context)?.settings.name !=
            AppRoutes.guardianDashboard) {
          Navigator.pushReplacementNamed(context, AppRoutes.guardianDashboard);
        }
        break;
      case 1:
        // Only navigate if not already on articles
        if (ModalRoute.of(context)?.settings.name !=
            AppRoutes.guardianArticles) {
          Navigator.pushReplacementNamed(context, AppRoutes.guardianArticles);
        }
        break;
      case 2:
        // Only navigate if not already on Q&A forums
        if (ModalRoute.of(context)?.settings.name !=
            AppRoutes.guardianQAForums) {
          Navigator.pushReplacementNamed(context, AppRoutes.guardianQAForums);
        }
        break;
      case 3:
        // Only navigate if not already on profile
        if (ModalRoute.of(context)?.settings.name !=
            AppRoutes.guardianProfile) {
          Navigator.pushReplacementNamed(context, AppRoutes.guardianProfile);
        }
        break;
    }
  }
}
