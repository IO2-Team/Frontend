import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _usernameTextController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: 'Choose a username'),
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
                          controller: _emailTextController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              hintText: 'Enter email address'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!EmailValidator.validate(value, true)) {
                              return 'Email is incorrect';
                            } else
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                              hintText: 'Confirm password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return "Password have to be at least 8 characters long";
                            } else if (value != _passwordTextController.text) {
                              return 'Password not matching';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(15)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.go('/organizerPanel');
                          }
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
