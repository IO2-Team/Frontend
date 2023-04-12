import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';

class EventsController extends ChangeNotifier {
  EventsController() {
    getEvents();
  }

  EventApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventApi();

  bool _loading = false;
  List<Event> _events = [];
  Event? _selectedEvent;
  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

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

  getEvents() async {
    setLoading(true);
    String token = await _sessionTokenController.get();
    final eventsResponse = await api.getMyEvents(sessionToken: token);
    setEventsList(eventsResponse.data!.asList());
    setLoading(false);
  }

  addEvent(
      {required String title,
      required String name,
      required int freePlace,
      required DateTime startTime,
      required DateTime endTime,
      required List<int> categories,
      required String latitude,
      required String longitude,
      String? placeSchema}) async {
    String token = await _sessionTokenController.get();
    EventFormBuilder builder = EventFormBuilder();
    builder.title = title;
    builder.name = name;
    builder.maxPlace = freePlace;
    builder.startTime = (startTime.millisecondsSinceEpoch / 1000).toInt();
    builder.endTime = (endTime.millisecondsSinceEpoch / 1000).toInt();
    builder.categoriesIds = ListBuilder<int>(categories);
    builder.latitude = latitude;
    builder.longitude = longitude;
    builder.placeSchema = placeSchema;
    api.addEvent(sessionToken: token, eventForm: builder.build());
  }

  setSelectedEvent(Event event) {
    _selectedEvent = event;
  }

  modifyEvent(Event event) async {
    String token = await _sessionTokenController.get();
    //api.patchEvent(sessionToken: token, id: event.id.toString(), event: event);
  }
}
