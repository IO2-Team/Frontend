import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';

class OrganizerController extends ChangeNotifier {
  EventOrganizerApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getEventOrganizerApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();
  UserNameContoller _userNameContoller = UserNameContoller();
  int? _userId;
  String get userId => _userId.toString();
  bool _isPending = true;
  bool get isPending => _isPending;

  Future<bool> logIn(String login, String password) async {
    try {
      final logInResponse =
          await api.loginOrganizer(email: login, password: password);
      await _sessionTokenController.set(logInResponse.data!.sessionToken!);
      _userNameContoller.set(login);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    try {
      final signUpResponse =
          await api.signUp(name: username, email: email, password: password);
      _userId = signUpResponse.data!.id;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmAccount(String code) async {
    try {
      final confirmResponse = await api.confirm(id: userId, code: code);
      _isPending = false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
