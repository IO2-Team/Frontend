import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/event_list_item.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/session_ended.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

class OrganizerPanelView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _OrganizerPanelViewState();
}

class _OrganizerPanelViewState extends State<OrganizerPanelView> {
  @override
  Widget build(BuildContext context) {
    EventsController eventsController = context.watch<EventsController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Your Events:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.go('/organizerPanel/addEvent');
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Create new Event",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: flatButtonStyle,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            eventsList(eventsController),
          ],
        ),
      ),
    );
  }

  Widget eventsList(EventsController eventsController) {
    return FutureBuilder<ResponseWithState>(
        future: eventsController.getEvents(),
        builder:
            (BuildContext context, AsyncSnapshot<ResponseWithState> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            ResponseWithState responseEvents = snapshot.data!;
            if (responseEvents.status == ResponseCase.SESSION_ENDED) {
              return sessionEnded(context);
            }
            List<EventListItem> eventsList =
                responseEvents.data ?? List<EventListItem>.empty();
            if (eventsList.isEmpty) {
              return Center(
                child: const Text(
                  "You have no events yet. Click Create new Event to create your first event",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return Expanded(
              child: ListView.separated(
                  itemCount: eventsList.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: ((context, index) {
                    EventListItem event = eventsList[index];
                    return EventsListItem(
                      event: event,
                      onTap: () {
                        PickedEventId().set(event.id.toString());
                        context.go('/organizerPanel/eventDetails');
                      },
                    );
                  })),
            );
          }
        });
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: mainColor,
  foregroundColor: Colors.white,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.all(16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
