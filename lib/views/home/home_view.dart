import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/views/home/home_page_details.dart';
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    signOut();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/welcome_theme.jpg"),
                fit: BoxFit.cover)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Column(
              children: <Widget>[
                HomeNavigationBar(),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      HomeViewDetails(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
