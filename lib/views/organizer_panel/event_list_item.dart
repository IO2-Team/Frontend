import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:openapi/openapi.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';

class EventsListItem extends StatelessWidget {
  final EventListItem event;
  final VoidCallback onTap;
  EventsListItem({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: event.status == EventStatus.inFuture
              ? Color.fromARGB(100, 255, 255, 255)
              : event.status == EventStatus.pending
                  ? Color.fromARGB(100, 116, 116, 255)
                  : event.status == EventStatus.cancelled
                      ? Color.fromARGB(100, 255, 74, 74)
                      : Color.fromARGB(100, 158, 158, 158),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            event.title,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            event.name,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Free places: ' +
                event.freePlace.toString() +
                '/' +
                event.maxPlace.toString(),
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(height: 30, child: categoriesList(eventCategories(event)))
        ]),
      ),
    );
  }

  List<Category> eventCategories(EventListItem event) {
    if (event.categories == null) {
      return List<Category>.empty();
    }
    return event.categories.toList();
  }

  Widget categoriesList(List<Category> categories) {
    return MultiSelectChipDisplay(
      items: categories.map((e) => MultiSelectItem(e, e.name)).toList(),
      chipColor: Colors.green,
      textStyle: TextStyle(color: Colors.white),
    );
  }
}
