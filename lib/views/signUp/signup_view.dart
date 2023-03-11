import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/widgets/singUp_form.dart';

class SignUpView extends StatelessWidget {
  const SignUpView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 600,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}
