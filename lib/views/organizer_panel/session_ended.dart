import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';

Widget sessionEnded(BuildContext context) {
  signOut();

  return Expanded(
    child: Center(
      child: AlertDialog(
        title: Text("Your session has expired, please log in"),
        actions: [
          TextButton(
              onPressed: () {
                context.go('/signIn');
              },
              child: const Text('Ok'))
        ],
      ),
    ),
  );
}
