import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_connection_string.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/widgets/dionizos_logo.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventsController eventsController = context.watch<EventsController>();
    OrganizerController organizerController =
        context.watch<OrganizerController>();
    CategoriesController categoriesController =
        context.watch<CategoriesController>();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DionizosLogo(
            path: '/',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // BackendSelectionButton(
              //   backendUpdate: updateBackend(eventsController,
              //       organizerController, categoriesController),
              // ),
              HighlightButton(
                  Key('SignUpPageKey'), 'Sign Up', () => context.go('/signUp')),
              HighlightButton(
                  Key('SignInPageKey'), 'Sign In', () => context.go('/signIn')),
            ],
          )
        ],
      ),
    );
  }
}

class BackendSelectionButton extends StatefulWidget {
  var backendUpdate;
  BackendSelectionButton({super.key, required this.backendUpdate});

  @override
  State<BackendSelectionButton> createState() => _BackendSelectionButtonState();
}

class _BackendSelectionButtonState extends State<BackendSelectionButton> {
  String dropdownValue = 'Grupa 1';

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: mainColor),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(children: [
                  Text(
                    'Backend:',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    dropdownColor: mainColor,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: mainColor,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        if (value == 'Grupa 1')
                          BackendConnectionString.currentlySelectedBackend =
                              BackendConnectionString.grupa1;
                        else if (value == 'Grupa 2')
                          BackendConnectionString.currentlySelectedBackend =
                              BackendConnectionString.grupa2;
                        widget.backendUpdate;
                      });
                    },
                    items: ['Grupa 1', 'Grupa 2']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ]))));
  }
}

class HighlightButton extends StatelessWidget {
  HighlightButton(Key key, this.title, this.action);
  final String title;
  var action;

  @override
  Widget build(BuildContext context) {
    return Padding(
        key: key,
        padding: EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: action,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ));
  }
}
