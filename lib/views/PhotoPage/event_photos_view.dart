import 'package:flutter/material.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:webfrontend_dionizos/views/PhotoPage/photos_display.dart';

class EventPhotosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late int eventId;
    try {
      eventId = int.parse(PickedEventId().get());
    } catch (e) {
      return Text('Picked id not exist');
    }
    return PhotosDisplay(
      eventId: eventId,
    );
  }
}
