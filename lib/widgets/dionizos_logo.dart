import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/widgets/gradient_text.dart';

class DionizosLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/organizerPanel'),
      child: GradientText(
        'Dionizos',
        style: TextStyle(fontSize: 35),
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade900],
        ),
      ),
    );
  }
}
