import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';

class SignInForm extends StatefulWidget {
  const SignInForm();

  @override
  State<SignInForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _isLogInFailed = false;

  @override
  Widget build(BuildContext context) {
    OrganizerController organizerController =
        context.watch<OrganizerController>();
    return Expanded(
        child: Center(
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
                  key: Key("signIn_email"),
                  controller: _usernameTextController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      hintText: 'Enter email address'),
                  validator: (value) {
                    if (_isLogInFailed) {
                      return 'Invalid email or password';
                    } else if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: Key('signIn_password'),
                  controller: _passwordTextController,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                      hintText: 'Enter password'),
                  validator: (value) {
                    if (_isLogInFailed) {
                      return 'Invalid email or password';
                    } else if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 8) {
                      return "Password have to be at least 8 characters long";
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                key: Key('signIn_button'),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: mainColor,
                    padding: EdgeInsets.all(15)),
                onPressed: () async {
                  _isLogInFailed = false;
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
                    if (await organizerController.logIn(
                        _usernameTextController.text,
                        _passwordTextController.text)) {
                      context.go('/organizerPanel');
                    } else {
                      context.pop();
                      _logInFailed();
                    }
                  }
                },
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  _logInFailed() {
    _isLogInFailed = true;
    _passwordTextController.text = "";
    _formKey.currentState!.validate();
  }
}
