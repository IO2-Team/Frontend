import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/widgets/dionizos_logo.dart';
import 'dart:ui' as ui;

import 'package:webfrontend_dionizos/widgets/gradient_text.dart';

class PanelNavigationBar extends StatelessWidget {
  const PanelNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DionizosLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PopupMenuButton(
                offset: Offset(0, 50),
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 40,
                  color: Colors.green,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: TextButton(
                          onPressed: () => context.go('/'),
                          child: Text('Sign out')))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
