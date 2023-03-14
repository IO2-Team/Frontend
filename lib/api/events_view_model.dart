import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class EventsViewModel extends ChangeNotifier {
  EventsViewModel() {
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
    final eventsResponse = await api.getEvents();
    setEventsList(eventsResponse.data!.asList());
    setLoading(false);
  }

  setSelectedEvent(Event event) {
    _selectedEvent = event;
  }
}
