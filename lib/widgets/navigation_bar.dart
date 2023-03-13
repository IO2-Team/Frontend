import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

import 'package:webfrontend_dionizos/widgets/gradient_text.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GradientText(
            'Dionizos',
            style: TextStyle(fontSize: 35),
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade900],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () => context.go('/tests'),
                child: _NavBarItem('Tests'),
              ),
              SizedBox(
                width: 60,
              ),
              TextButton(
                onPressed: () => context.go('/signUp'),
                child: _NavBarItem('Sign Up'),
              ),
              SizedBox(
                width: 60,
              ),
              TextButton(
                onPressed: () => context.go('/signIn'),
                child: _NavBarItem('Sign In'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  const _NavBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, color: Colors.green.shade500),
    );
  }
}
