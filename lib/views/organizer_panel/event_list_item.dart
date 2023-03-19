import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';

class EventsListItem extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  EventsListItem({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
