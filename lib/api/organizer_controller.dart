import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/session_token.dart';

class OganizerController extends ChangeNotifier {
  EventOrganizerApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventOrganizerApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

  Future<bool> logIn(String login, String password) async {
    try {
      final logInResponse =
          await api.loginOrganizer(email: login, password: password);
      await _sessionTokenController.set(logInResponse.data!.sessionToken!);
      return true;
    } catch (e) {
      return false;
    }
  }
}
