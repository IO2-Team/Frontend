import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:openapi/openapi.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';

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
          color: Color.fromARGB(200, 222, 157, 237),
          //border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          statusBar(event.status),
          SizedBox(
            height: 10,
          ),
          Text(
            event.title,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
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

  Widget statusBar(EventStatus status) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: event.status == EventStatus.inFuture
              ? Colors.green
              : event.status == EventStatus.pending
                  ? Colors.blue
                  : event.status == EventStatus.cancelled
                      ? Colors.red
                      : Colors.grey,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            status.toString(),
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ));
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
      chipColor: categoriesColor,
      textStyle: TextStyle(color: Colors.white),
    );
  }
}
