import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';
import 'package:webfrontend_dionizos/views/signIn/singIn_form.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

class SignInView extends StatelessWidget {
  const SignInView();

  @override
  Widget build(BuildContext context) {
    signOut();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CenteredView(
        child: Column(
          children: <Widget>[
            HomeNavigationBar(),
            SizedBox(
              height: 40,
            ),
            SignInForm(),
          ],
        ),
      ),
    );
  }
}
