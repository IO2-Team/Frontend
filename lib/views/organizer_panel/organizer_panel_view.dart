import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/organizer_panel_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/organizer_panel_model.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:webfrontend_dionizos/views/home/home_page_details.dart';

class OrganizerPanelView extends StatefulWidget {
  const OrganizerPanelView();

  @override
  State<OrganizerPanelView> createState() => _OrganizerPanelState();
}

class _OrganizerPanelState extends State<OrganizerPanelView> {
  OrganizerPanelController? controller = null;
  @override
  Widget build(BuildContext context) {
    if (controller == null) controller = OrganizerPanelController(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Current Events:",
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Create new Event",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  style: flatButtonStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.black,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
