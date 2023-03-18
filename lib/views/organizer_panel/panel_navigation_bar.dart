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
              TextButton(
                //onPressed: () => context.go('/accSettings'),
                onPressed: null,
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
