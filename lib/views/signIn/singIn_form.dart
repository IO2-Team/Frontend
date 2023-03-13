import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignInForm extends StatefulWidget {
  const SignInForm();

  @override
  State<SignInForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: _formProgress),
            Text('Sign In', style: Theme.of(context).textTheme.headlineMedium),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _usernameTextController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: 'Enter username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  } else if (value.length < 4) {
                    return 'Username must be at least 4 characters long';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _passwordTextController,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    hintText: 'Enter password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return "Password have to be at least 8 characters long";
                  }
                  return null;
                },
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white;
                }),
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.green;
                }),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  log("Correct");
                }
              },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
