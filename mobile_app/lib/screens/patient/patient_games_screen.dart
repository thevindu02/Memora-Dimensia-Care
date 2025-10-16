import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import 'games/memory_match/memory_match_game.dart';

class PatientGamesScreen extends StatelessWidget {
  const PatientGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientColors.background,
      appBar: AppBar(
        backgroundColor: PatientColors.surface,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Play Games',
          style: TextStyle(
            color: PatientColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: PatientColors.onSurface),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fun and memory games for everyone',
              style: TextStyle(
                fontSize: 16,
                color: PatientColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildGameCard(
                    context: context,
                    icon: _buildBrainIcon(),
                    title: 'Memory Match',
                    description: 'Find matching pairs.\nGreat for memory exercise.',
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.patientMemoryMatch);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    context: context,
                    icon: _buildRainbowIcon(),
                    title: 'Color Match',
                    description: 'Find matching pairs.\nGreat for memory exercise.',
                    onTap: () {
                      // Placeholder for Color Match game navigation
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required Widget icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: PatientColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PatientColors.shadow,
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: PatientColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: PatientColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightAccent,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Playing',
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
  }

  Widget _buildBrainIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: PatientColors.activityMeditation,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(40, 40),
          painter: BrainIconPainter(),
        ),
      ),
    );
  }

  Widget _buildRainbowIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: PatientColors.activityCreativity,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(40, 40),
          painter: RainbowIconPainter(),
        ),
      ),
    );
  }
}

class BrainIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PatientColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();

    // Draw brain outline
    path.moveTo(size.width * 0.3, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.1, size.width * 0.2, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, size.width * 0.3, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width * 0.7, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.6, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.1, size.width * 0.7, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width * 0.3, size.height * 0.2);

    canvas.drawPath(path, paint);

    // Draw brain divisions
    final divisionPath = Path();
    divisionPath.moveTo(size.width * 0.5, size.height * 0.15);
    divisionPath.quadraticBezierTo(size.width * 0.45, size.height * 0.5, size.width * 0.5, size.height * 0.85);

    canvas.drawPath(divisionPath, paint);

    // Draw brain folds
    final foldPaint = Paint()
      ..color = PatientColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left side folds
    canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.35, size.height * 0.35), width: 10, height: 8),
        0, 3.14, false, foldPaint
    );
    canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.3, size.height * 0.55), width: 8, height: 6),
        0, 3.14, false, foldPaint
    );

    // Right side folds
    canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.65, size.height * 0.35), width: 10, height: 8),
        0, 3.14, false, foldPaint
    );
    canvas.drawArc(
        Rect.fromCenter(center: Offset(size.width * 0.7, size.height * 0.55), width: 8, height: 6),
        0, 3.14, false, foldPaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RainbowIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    final center = Offset(size.width / 2, size.height * 0.8);
    final baseRadius = size.width * 0.4;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      final radius = baseRadius - (i * 3);

      canvas.drawArc(
        Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
        3.14, // Start from left (180 degrees)
        3.14, // Draw semicircle (180 degrees)
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}