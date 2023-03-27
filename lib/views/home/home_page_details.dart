import 'dart:math';

import 'package:flutter/material.dart';

class HomeViewDetails extends StatelessWidget {
  const HomeViewDetails({Key? key}) : super(key: key);

  static String welcomeText = """
Welcome on world-fastest-growing event platform Dionizos!
Do you organize events?
If so, you are in best place to publish your event!
  """;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: min(MediaQuery.of(context).size.width, 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          SizedBox(
            height: 80,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                welcomeText,
                style: TextStyle(
                  fontSize: 21,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
