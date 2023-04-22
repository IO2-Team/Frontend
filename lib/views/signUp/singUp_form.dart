import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_provider.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';

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

  final _confirmationCodeTextController = TextEditingController();

  bool _emailUsed = false;

  @override
  Widget build(BuildContext context) {
    OrganizerController organizerController =
        context.watch<OrganizerController>();
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
                          key: Key('signUp_username'),
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
                          key: Key('signUp_email'),
                          controller: _emailTextController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              hintText: 'Enter email address'),
                          validator: (value) {
                            if (_emailUsed) {
                              return "There already is account with this email address";
                            } else if (value == null || value.isEmpty) {
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
                          key: Key('signUp_password'),
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
                          key: Key('signUp_passwordConfirm'),
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
                        key: Key('signUp_button'),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(15)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                // The user CANNOT close this dialog  by pressing outsite it
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                    // The background color
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          // The loading indicator
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Some text
                                          Text('Loading...')
                                        ],
                                      ),
                                    ),
                                  );
                                });
                            if (await organizerController.signUp(
                                _usernameTextController.text,
                                _emailTextController.text,
                                _passwordTextController.text)) {
                              context.pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return _confirmationDialog(
                                        organizerController);
                                  });
                            } else {
                              context.pop();
                              _emailUsed = true;
                              _formKey.currentState!.validate();
                            }
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

  Widget _confirmationDialog(OrganizerController organizerController) {
    final _formKeyAlert = GlobalKey<FormState>();
    bool isWrongCode = false;
    return AlertDialog(
      title: Text('Confirm account'),
      content: Form(
        key: _formKeyAlert,
        child: TextFormField(
          controller: _confirmationCodeTextController,
          decoration:
              const InputDecoration(hintText: 'Enter confirmation code'),
          validator: (value) {
            if (isWrongCode) {
              return "Incorrect confirmation code";
            } else if (value == null || value.isEmpty) {
              return 'Please enter your confirmation code';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text('Cancel'),
          onPressed: () async {
            context.pop();
          },
        ),
        MaterialButton(
          color: Colors.green,
          textColor: Colors.white,
          child: Text('OK'),
          onPressed: () async {
            showDialog(
                // The user CANNOT close this dialog  by pressing outsite it
                barrierDismissible: false,
                context: context,
                builder: (_) {
                  return Dialog(
                    // The background color
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          // The loading indicator
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 15,
                          ),
                          // Some text
                          Text('Loading...')
                        ],
                      ),
                    ),
                  );
                });
            if (await organizerController
                .confirmAccount(_confirmationCodeTextController.text)) {
              if (await organizerController.logIn(
                  _emailTextController.text, _passwordTextController.text)) {
                context.go('/organizerPanel');
              } else {
                context.pop();
                _confirmationCodeTextController.text = "";
                isWrongCode = true;
                _formKeyAlert.currentState!.validate();
              }
            } else {
              context.pop();
              _confirmationCodeTextController.text = "";
              isWrongCode = true;
              _formKeyAlert.currentState!.validate();
            }
          },
        ),
      ],
    );
  }
}
