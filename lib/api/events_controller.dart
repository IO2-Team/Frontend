import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class EventsController extends ChangeNotifier {
  EventsController() {
    getEvents("placeholder");
  }

  EventApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventApi();

  bool _loading = false;
  List<Event> _events = [];
  Event? _selectedEvent;

  bool get loading => _loading;
  List<Event> get eventsList => _events;
  Event get selectedEvent => _selectedEvent!;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setEventsList(List<Event> events) {
    _events = events;
  }

  getEvents(String sessionToken) async {
    setLoading(true);
    //final eventsResponse = await api.getMyEvents(sessionToken: sessionToken);
    final eventsResponse = await api.getEvents();
    setEventsList(eventsResponse.data!.asList());
    setLoading(false);
  }

  addEvent(
      {required String sessionToken,
      required String title,
      required String name,
      required int freePlace,
      required DateTime startTime,
      required DateTime endTime,
      required List<int> categories,
      String? placeSchema}) async {
    api.addEvent(
        sessionToken: sessionToken,
        title: title,
        name: name,
        freePlace: freePlace,
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        longitude: "0",
        latitude: "0",
        categories: BuiltList<int>.from(categories));
  }

  setSelectedEvent(Event event) {
    _selectedEvent = event;
  }

  modifyEvent(Event event) async {
    api.patchEvent(
        sessionToken: "assdfsa", id: event.id.toString(), event: event);
  }
}
