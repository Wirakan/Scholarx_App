import 'package:flutter/material.dart';

/// A simple placeholder screen that lets the user choose a role.
/// In the original project this file was referenced from the routes but
/// wasn't present, causing the app to fail to compile. Keeping the style
/// consistent with the rest of the code, this widget just displays two
/// buttons that navigate to the student or staff login screens.

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/student/login'),
              child: const Text('Student'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/staff/login'),
              child: const Text('Staff'),
            ),
          ],
        ),
      ),
    );
  }
}