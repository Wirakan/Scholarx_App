import 'package:flutter/material.dart';

/// Simple placeholder dashboard for staff.

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Dashboard')),
      body: const Center(child: Text('Welcome, staff member!')),
    );
  }
}
