import 'package:flutter/material.dart';

class CenteredView extends StatelessWidget {
  final Widget child;
  const CenteredView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/back_pic.png"),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        alignment: Alignment.center,
        child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(180, 250, 254, 255),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: child,
                ))),
      ),
    );
  }
}
