import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class TokenProvider extends ChangeNotifier {
  TokenProvider() {
    getSessionToken();
  }

  EventOrganizerApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventOrganizerApi();

  String _sessionToken = "";

  String get sessionToken => _sessionToken;

  Future getSessionToken() async {
    _sessionToken = "Placeholder";
  }
}
