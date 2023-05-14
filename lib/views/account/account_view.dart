import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

class AccountView extends StatefulWidget {
  const AccountView();

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _confirmationCodeTextController = TextEditingController();

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    OrganizerController organizerController =
        context.watch<OrganizerController>();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            accountView(organizerController),
          ],
        ),
      ),
    );
  }

  Widget accountView(OrganizerController organizerController) {
    return FutureBuilder<ResponseWithState>(
        future: organizerController.getOrganizer(),
        builder:
            (BuildContext context, AsyncSnapshot<ResponseWithState> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            Organizer organizerData = snapshot.data!.data;
            _usernameTextController.text = organizerData.name;
            _emailTextController.text = organizerData.email;
            return _editMode
                ? accountEditMode(organizerController, organizerData)
                : account();
          }
        });
  }

  Widget account() {
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
                        child: TextField(
                          readOnly: true,
                          controller: _emailTextController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          readOnly: _editMode ? false : true,
                          controller: _usernameTextController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: mainColor,
                            padding: EdgeInsets.all(15)),
                        onPressed: () async {
                          _editMode = true;
                          setState(() {});
                        },
                        child: Text(
                          'Edit',
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

  Widget accountEditMode(
      OrganizerController organizerController, Organizer organizerData) {
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
                          readOnly: true,
                          controller: _emailTextController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                              hintText: 'Enter email address',
                              fillColor: Colors.grey,
                              filled: true),
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
                          readOnly: _editMode ? false : true,
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
                          readOnly: _editMode ? false : true,
                          controller: _passwordTextController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                              hintText: 'Enter password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
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
                          readOnly: _editMode ? false : true,
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                              hintText: 'Confirm password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            } else if (value.length < 8) {
                              return "Password have to be at least 8 characters long";
                            } else if (value != _passwordTextController.text) {
                              return 'Password not matching';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.all(15)),
                              onPressed: () => deleteAccount(
                                  organizerController, organizerData),
                              child: Text('Delete account')),
                          TextButton(
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
                                final result =
                                    await organizerController.patchAccount(
                                        id: organizerData.id,
                                        userName: _usernameTextController.text,
                                        password: _passwordTextController.text);
                                if (result == ResponseCase.OK) {
                                  context.pop();
                                  _editMode = false;
                                  setState(() {});
                                } else {
                                  context.pop();
                                  _formKey.currentState!.validate();
                                }
                              }
                            },
                            child: Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      )
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

  deleteAccount(
      OrganizerController organizerController, Organizer organizerData) async {
    bool delete = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  'Are you sure you want to delete your account? This action cannot be undone.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    delete = true;
                    context.pop();
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ));
    if (!delete) return;
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
    final result =
        await organizerController.deleteAccount(id: organizerData.id);
    if (result == ResponseCase.FAILED) {
      context.pop();
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    'Your account cannot be deleted now. Make sure there is no active events.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }
    context.go('/');
  }
}
