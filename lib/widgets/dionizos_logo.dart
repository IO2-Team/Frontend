import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DionizosLogo extends StatelessWidget {
  final String path;

  const DionizosLogo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('DionizosLogoKey'),
      onPressed: () => context.go(path),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/dionizos_logo.png'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
