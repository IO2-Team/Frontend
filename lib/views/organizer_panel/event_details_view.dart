import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/events_view_model.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/event_list_item.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

class EventDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventsViewModel eventsViewModel = context.watch<EventsViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            eventDetails(eventsViewModel.selectedEvent),
          ],
        ),
      ),
    );
  }

  Widget eventDetails(Event event) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          event.title ?? "Null",
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          event.name ?? "Null",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 30,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: (event.categories?.length ?? 0),
              separatorBuilder: (context, index) => VerticalDivider(),
              itemBuilder: ((context, index) {
                Category category = event.categories?[index] ?? Category();
                return Text(
                  category.name ?? "Null",
                  textAlign: TextAlign.center,
                );
              })),
        )
      ]),
    );
  }
}
