import 'package:flutter/material.dart';

/// Placeholder staff login screen. In the original project the route exists
/// but no implementation was provided; this stub lets the app compile and
/// provides navigation to the staff dashboard.

class StaffLoginScreen extends StatelessWidget {
  const StaffLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/staff/dashboard');
          },
          child: const Text('Go to Dashboard'),
        ),
      ),
    );
  }
}
