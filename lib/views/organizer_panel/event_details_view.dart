import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:webfrontend_dionizos/views/eventAddMod.dart';

class EventDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late int? eventId;
    try {
      eventId = int.parse(PickedEventId().get());
    } catch (e) {
      eventId = null;
    }
    return EventAddMod(
      eventId: eventId,
    );
  }
}
