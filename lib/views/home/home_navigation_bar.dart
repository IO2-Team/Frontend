import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/widgets/dionizos_logo.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DionizosLogo(
            path: '/',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              HighlightButton('Sign Up', () => context.go('/signUp')),
              SizedBox(
                width: 60,
              ),
              HighlightButton('Sign In', () => context.go('/signIn')),
            ],
          )
        ],
      ),
    );
  }
}

class HighlightButton extends StatelessWidget {
  HighlightButton(this.title, this.action);
  final String title;
  var action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.green,
      ),
      onPressed: action,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
