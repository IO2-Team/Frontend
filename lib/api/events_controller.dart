import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' as found;
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class EventsController extends found.ChangeNotifier {
  EventsController() {
    getEvents();
  }

  EventApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventApi();

  bool _loading = false;
  List<EventModel> _events = [];
  EventModel? _selectedEvent;
  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

  bool get loading => _loading;
  List<EventModel> get eventsList => _events;
  EventModel get selectedEvent => _selectedEvent!;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setEventsList(List<EventModel> events) {
    _events = events;
  }

  getEvents() async {
    setLoading(true);
    String token = await _sessionTokenController.get();
    final eventsResponse = await api.getMyEvents(sessionToken: token);
    List<EventModel> eventModels = [];
    for (var event in eventsResponse.data!.asList()) {
      DateTime startTime =
          DateTime.fromMillisecondsSinceEpoch(event.startTime! * 1000);
      DateTime endTime =
          DateTime.fromMillisecondsSinceEpoch(event.endTime! * 1000);
      String addressName = await parseLocationName(
          double.parse(event.latitude!), double.parse(event.longitude!));
      eventModels.add(EventModel(
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
          event.placeSchema));
    }
    setEventsList(eventModels);
    setLoading(false);
  }

  addEvent(EventModel event) async {
    String token = await _sessionTokenController.get();
    api.addEvent(
        sessionToken: token,
        title: event.title,
        name: event.name,
        freePlace: event.freePlace,
        startTime: (event.startTime.millisecondsSinceEpoch / 1000).toInt(),
        endTime: (event.endTime.millisecondsSinceEpoch / 1000).toInt(),
        longitude: event.longitude.toString(),
        latitude: event.latitude.toString(),
        categories: BuiltList<int>.from(event.categories));
  }

  setSelectedEvent(EventModel event) {
    _selectedEvent = event;
  }

  modifyEvent(Event event) async {
    String token = await _sessionTokenController.get();
    api.patchEvent(sessionToken: token, id: event.id.toString(), event: event);
  }
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
