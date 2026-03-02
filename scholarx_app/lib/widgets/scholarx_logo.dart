import 'package:flutter/material.dart';

class ScholarXLogo extends StatelessWidget {
  final double size;
  final bool withLabel;
  final bool darkLabel;

  const ScholarXLogo({
    super.key,
    this.size = 60,
    this.withLabel = false,
    this.darkLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        if (withLabel) ...[
          const SizedBox(height: 4),
          Text(
            'ScholarX',
            style: TextStyle(
              color: darkLabel ? Colors.black87 : Colors.white,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'FOR EN STUDENT',
            style: TextStyle(
              color: darkLabel ? Colors.black54 : Colors.white60,
              fontSize: size * 0.13,
              letterSpacing: 2,
            ),
          ),
        ],
      ],
    );
  }
}