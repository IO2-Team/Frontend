import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DionizosLogo extends StatelessWidget {
  final String path;

  const DionizosLogo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(path),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/dionizos_logo.png'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
