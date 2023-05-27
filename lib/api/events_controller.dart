import 'dart:convert';
import 'dart:math';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' as found;
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/api_connection_string.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';
import 'package:http/http.dart' as http;

enum ResponseCase { OK, FAILED, SESSION_ENDED }

class ResponseWithState {
  final dynamic data;
  final ResponseCase status;

  ResponseWithState(this.data, this.status);
}

class EventsController extends found.ChangeNotifier {
  EventsController() {}

  EventApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: BackendConnectionString.currentlySelectedBackend)),
          serializers: standardSerializers)
      .getEventApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

  changeBackend() {
    api = Openapi(
            dio: Dio(BaseOptions(
                baseUrl: BackendConnectionString.currentlySelectedBackend)),
            serializers: standardSerializers)
        .getEventApi();
  }

  Future<ResponseWithState> getEvent(int id) async {
    try {
      final eventResponse = await api.getEventById(id: id);
      EventWithPlaces event = eventResponse.data!;
      DateTime startTime =
          DateTime.fromMillisecondsSinceEpoch(event.startTime * 1000);
      DateTime endTime =
          DateTime.fromMillisecondsSinceEpoch(event.endTime * 1000);
      String addressName = await parseLocationName(
          double.parse(event.latitude), double.parse(event.longitude));
      return ResponseWithState(
          EventModel(
              event.id,
              event.title,
              event.name,
              event.maxPlace,
              event.freePlace,
              startTime,
              endTime,
              double.parse(event.latitude),
              double.parse(event.longitude),
              addressName,
              event.categories.toList(),
              event.placeSchema,
              event.places.toList(),
              event.status),
          ResponseCase.OK);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403)
        return ResponseWithState(null, ResponseCase.SESSION_ENDED);
      return ResponseWithState(null, ResponseCase.FAILED);
    }
  }

  Future<ResponseWithState> getEvents() async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseWithState([], ResponseCase.SESSION_ENDED);
    }
    try {
      final eventsResponse = await api.getMyEvents(sessionToken: token);
      List<EventListItem> eventsList = [];
      for (var event in eventsResponse.data!.asList()) {
        eventsList.add(EventListItem(
            event.id,
            event.title,
            event.name,
            event.categories.toList(),
            event.maxPlace,
            event.freePlace,
            event.status));
      }
      return ResponseWithState(eventsList, ResponseCase.OK);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403)
        return ResponseWithState(null, ResponseCase.SESSION_ENDED);
      return ResponseWithState(null, ResponseCase.FAILED);
    }
  }

  Future<ResponseCase> addEvent(
      {required String title,
      required String name,
      required int maxPlace,
      required DateTime startTime,
      required DateTime endTime,
      required List<int> categories,
      required String latitude,
      required String longitude,
      String? placeSchema}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    EventFormBuilder builder = EventFormBuilder();
    builder.title = title;
    builder.name = name;
    builder.maxPlace = maxPlace;
    builder.startTime = (startTime.millisecondsSinceEpoch / 1000).toInt();
    builder.endTime = (endTime.millisecondsSinceEpoch / 1000).toInt();
    builder.categoriesIds = ListBuilder<int>(categories);
    builder.latitude = latitude;
    builder.longitude = longitude;
    builder.placeSchema = placeSchema ?? "";
    try {
      await api.addEvent(sessionToken: token, eventForm: builder.build());
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseCase.SESSION_ENDED;
      }
      return ResponseCase.FAILED;
    }
  }

  Future<ResponseCase> patchEvent(
      {required int id,
      required String title,
      required String name,
      required int maxPlace,
      required DateTime startTime,
      required DateTime endTime,
      required String latitude,
      required String longitude,
      required List<int> categories,
      String? placeSchema}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    EventPatchBuilder builder = EventPatchBuilder();
    builder.title = title;
    builder.name = name;
    builder.maxPlace = maxPlace;
    builder.startTime = (startTime.millisecondsSinceEpoch / 1000).toInt();
    builder.endTime = (endTime.millisecondsSinceEpoch / 1000).toInt();
    builder.categoriesIds = ListBuilder<int>(categories);
    builder.latitude = latitude;
    builder.longitude = longitude;
    builder.placeSchema = placeSchema ?? "";
    try {
      await api.patchEvent(
          sessionToken: token, id: id.toString(), eventPatch: builder.build());
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseCase.SESSION_ENDED;
      }
      return ResponseCase.FAILED;
    }
  }

  Future<ResponseCase> cancelEvent({required int id}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    try {
      await api.cancelEvent(sessionToken: token, id: id.toString());
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseCase.SESSION_ENDED;
      }
      return ResponseCase.FAILED;
    }
  }

  Future<ResponseWithState> getImagesPaths({required int id}) async {
    try {
      final result = await api.getPhoto(id: id);
      List<String> imagesPaths = [];
      if (result.data != null) imagesPaths = result.data!.asList();
      return ResponseWithState(imagesPaths, ResponseCase.OK);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseWithState(null, ResponseCase.SESSION_ENDED);
      }
      return ResponseWithState(null, ResponseCase.FAILED);
    }
  }

  String getCustomUniqueId() {
    const String pushChars =
        '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
    int lastPushTime = 0;
    List lastRandChars = [];
    int now = DateTime.now().millisecondsSinceEpoch;
    bool duplicateTime = (now == lastPushTime);
    lastPushTime = now;
    List timeStampChars = List<String>.filled(8, '0');
    for (int i = 7; i >= 0; i--) {
      timeStampChars[i] = pushChars[now % 64];
      now = (now / 64).floor();
    }
    if (now != 0) {
      print("Id should be unique");
    }
    String uniqueId = timeStampChars.join('');
    if (!duplicateTime) {
      for (int i = 0; i < 12; i++) {
        lastRandChars.add((Random().nextDouble() * 64).floor());
      }
    } else {
      int i = 0;
      for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
        lastRandChars[i] = 0;
      }
      lastRandChars[i]++;
    }
    for (int i = 0; i < 12; i++) {
      uniqueId += pushChars[lastRandChars[i]];
    }
    return uniqueId;
  }

  Future<ResponseWithState> addPhotoPath({required int eventId}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseWithState(null, ResponseCase.SESSION_ENDED);
    }
    try {
      String path = eventId.toString() + '_' + getCustomUniqueId();
      await api.putPhoto(
          sessionToken: token, id: eventId.toString(), path: path);
      return ResponseWithState(path, ResponseCase.OK);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseWithState(null, ResponseCase.SESSION_ENDED);
      }
      return ResponseWithState(null, ResponseCase.FAILED);
    }
  }

  Future<ResponseCase> deletePhotoPath(
      {required int eventId, required String path}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    try {
      await api.deletePhoto(
          sessionToken: token, id: eventId.toString(), path: path);
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        return ResponseCase.SESSION_ENDED;
      }
      return ResponseCase.FAILED;
    }
  }
}

class EventListItem {
  final int id;
  final String title;
  final String name;
  final int maxPlace;
  final int freePlace;
  final List<Category> categories;
  final EventStatus status;

  EventListItem(this.id, this.title, this.name, this.categories, this.maxPlace,
      this.freePlace, this.status);
}

class EventModel {
  late int id;
  late String title;
  late String name;
  late int maxPlace;
  late int freePlace;
  late DateTime startTime;
  late DateTime endTime;
  late double latitude;
  late double longitude;
  late String addressName;
  late List<Category> categories;
  late String? placeSchema;
  late List<Place> places;
  late EventStatus status;

  EventModel(
      this.id,
      this.title,
      this.name,
      this.maxPlace,
      this.freePlace,
      this.startTime,
      this.endTime,
      this.latitude,
      this.longitude,
      this.addressName,
      this.categories,
      this.placeSchema,
      this.places,
      this.status);
  EventModel.empty() {
    id = -1;
    title = "";
    name = "";
    maxPlace = -1;
    freePlace = 0;
    startTime = DateTime.now();
    endTime = DateTime.now();
    latitude = 0;
    longitude = 0;
    addressName = "";
    categories = [];
    placeSchema = null;
    places = [];
    status = EventStatus.done;
  }
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
