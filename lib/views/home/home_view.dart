import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:webfrontend_dionizos/views/home/home_page_details.dart';
import 'package:webfrontend_dionizos/views/home/home_navigation_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
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
    );
  }
}
