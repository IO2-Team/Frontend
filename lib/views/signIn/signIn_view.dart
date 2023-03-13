import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/widgets/singIn_form.dart';

class SignInView extends StatelessWidget {
  const SignInView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 600,
          child: Card(
            child: SignInForm(),
          ),
        ),
      ),
    );
  }
}
