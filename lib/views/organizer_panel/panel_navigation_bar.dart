import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:webfrontend_dionizos/widgets/dionizos_logo.dart';
import 'dart:ui' as ui;

import 'package:webfrontend_dionizos/widgets/gradient_text.dart';

class PanelNavigationBar extends StatelessWidget {
  const PanelNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserNameContoller userNameContoller = UserNameContoller();
    late String userName;
    try {
      userName = userNameContoller.get();
    } catch (e) {
      userName = "";
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DionizosLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(fontSize: 20),
              ),
              PopupMenuButton(
                offset: Offset(0, 50),
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.green,
                ),
                iconSize: 40,
                itemBuilder: (context) => [
                  PopupMenuItem(
                      onTap: () => context.go('/'), child: Text('Sign out')),
                  PopupMenuItem(
                      onTap: () => SessionTokenContoller().set('asadasd'),
                      child: Text('Session ended test'))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
