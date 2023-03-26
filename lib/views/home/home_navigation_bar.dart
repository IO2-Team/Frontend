import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

import 'package:webfrontend_dionizos/widgets/gradient_text.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () => context.go('/'),
            child: GradientText(
              'Dionizos',
              style: TextStyle(fontSize: 35),
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade900],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 60,
              ),
              HighlightButton(
                'Sign Up'
                ,() => context.go('/signUp')
              ),
              SizedBox(
                width: 60,
              ),
              HighlightButton(
                  'Sign In'
                  ,() => context.go('/signIn')
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HighlightButton extends StatelessWidget {
  HighlightButton(this.title,this.action);
  final String title;
  var action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //TODO: moze gradient?
        backgroundColor: Colors.green.shade300,
      ),
      onPressed: action,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          title,
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
