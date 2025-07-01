import 'package:flutter/material.dart';

class GuardianOrdersScreen extends StatelessWidget {
  const GuardianOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body: Center(child: Text('Guardian Orders Screen')),
    );
  }
}