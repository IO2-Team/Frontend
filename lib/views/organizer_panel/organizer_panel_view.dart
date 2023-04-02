import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/event_list_item.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
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
    return FutureBuilder<List<EventListItem>>(
        future: eventsController.getEvents(),
        builder: (BuildContext context,
            AsyncSnapshot<List<EventListItem>> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            List<EventListItem> eventsList = snapshot.data!;
            if (eventsList.isEmpty) {
              return Center(
                child: Text(
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
                        //eventsController.setSelectedEvent(event);
                        context.go('/organizerPanel/eventDetails',
                            extra: event.id);
                      },
                    );
                  })),
            );
          }
        });
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.green,
  foregroundColor: Colors.black,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.all(16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
