import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' as found;
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:http/http.dart' as http;

class EventsController extends found.ChangeNotifier {
  EventsController() {}

  static EventApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

  Future<EventModel> getEvent(int id) async {
    String token = await _sessionTokenController.get();
    final eventResponse = await api.getEventById(id: id);
    Event event = eventResponse.data!;
    DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(event.startTime! * 1000);
    DateTime endTime =
        DateTime.fromMillisecondsSinceEpoch(event.endTime! * 1000);
    String addressName = await parseLocationName(
        double.parse(event.latitude!), double.parse(event.longitude!));
    return EventModel(
        event.id,
        event.title!,
        event.name!,
        event.freePlace!,
        startTime,
        endTime,
        double.parse(event.latitude!),
        double.parse(event.longitude!),
        addressName,
        event.categories!.toList(),
        event.placeSchema);
  }

  Future<List<EventListItem>> getEvents() async {
    String token = await _sessionTokenController.get();
    print(token);
    final eventsResponse = await api.getMyEvents(sessionToken: token);
    List<EventListItem> eventsList = [];
    for (var event in eventsResponse.data!.asList()) {
      DateTime startTime =
          DateTime.fromMillisecondsSinceEpoch(event.startTime! * 1000);
      DateTime endTime =
          DateTime.fromMillisecondsSinceEpoch(event.endTime! * 1000);
      String addressName = await parseLocationName(
          double.parse(event.latitude!), double.parse(event.longitude!));
      eventsList.add(EventListItem(
        event.id,
        event.title!,
        event.name!,
        event.categories!.toList(),
      ));
    }
    return eventsList;
  }

  Future<bool> addEvent(
      {required String title,
      required String name,
      required int freePlace,
      required DateTime startTime,
      required DateTime endTime,
      required double latitude,
      required double longitude,
      required List<Category> categories,
      String? schema}) async {
    String token = await _sessionTokenController.get();
    try {
      final response = await api.addEvent(
          sessionToken: token,
          title: title,
          name: name,
          freePlace: freePlace,
          startTime: (startTime.millisecondsSinceEpoch / 1000).toInt(),
          endTime: (endTime.millisecondsSinceEpoch / 1000).toInt(),
          longitude: longitude.toString(),
          latitude: latitude.toString(),
          categories:
              BuiltList<int>.from(categories.map((e) => e.id!).toList()));

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  patchEvent(
      {required int id,
      required String title,
      required String name,
      required int freePlace,
      required DateTime startTime,
      required DateTime endTime,
      required double latitude,
      required double longitude,
      required List<Category> categories,
      String? schema}) async {
    String token = await _sessionTokenController.get();

    //api.patchEvent(sessionToken: token, id: id.toString(), event: Event());
  }
}

class EventListItem {
  final int id;
  final String title;
  final String name;
  final List<Category> categories;

  EventListItem(this.id, this.title, this.name, this.categories);
}

class EventModel {
  final int id;
  final String title;
  final String name;
  final int freePlace;
  final DateTime startTime;
  final DateTime endTime;
  final double latitude;
  final double longitude;
  late String addressName;
  final List<Category> categories;
  final String? placeSchema;

  EventModel(
      this.id,
      this.title,
      this.name,
      this.freePlace,
      this.startTime,
      this.endTime,
      this.latitude,
      this.longitude,
      this.addressName,
      this.categories,
      this.placeSchema);
}

Future<String> parseLocationName(double lat, double lon) async {
  var client = http.Client();
  String url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1';

  var response = await client.post(Uri.parse(url));
  var decodedResponse =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
  String displayName = decodedResponse['display_name'];
  return displayName;
}
