import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/api_connection_string.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';

class OrganizerController extends ChangeNotifier {
  EventOrganizerApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: BackendConnectionString.currentlySelectedBackend)),
          serializers: standardSerializers)
      .getEventOrganizerApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();
  UserNameContoller _userNameContoller = UserNameContoller();
  int? _userId;
  String get userId => _userId.toString();
  bool _isPending = true;
  bool get isPending => _isPending;

  changeBackend() {
    api = Openapi(
            dio: Dio(BaseOptions(
                baseUrl: BackendConnectionString.currentlySelectedBackend)),
            serializers: standardSerializers)
        .getEventOrganizerApi();
  }

  Future<bool> logIn(String login, String password) async {
    try {
      final logInResponse =
          await api.loginOrganizer(email: login, password: password);
      await _sessionTokenController.set(logInResponse.data!.sessionToken!);
      final userData = await api.getOrganizer(
          sessionToken: logInResponse.data!.sessionToken!);

      _userNameContoller.set(userData.data!.name);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ResponseWithState> getOrganizer() async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      print('Session ended during get Organizer');
      return ResponseWithState(null, ResponseCase.SESSION_ENDED);
    }
    print('token: ' + token);
    try {
      final userData = await api.getOrganizer(sessionToken: token);
      return ResponseWithState(userData.data!, ResponseCase.OK);
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) {
        print('403 during get organizer');
        return ResponseWithState(null, ResponseCase.SESSION_ENDED);
      }
      print('error during get organizer');
      return ResponseWithState(null, ResponseCase.FAILED);
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    try {
      OrganizerFormBuilder builder = OrganizerFormBuilder();
      builder.name = username;
      builder.email = email;
      builder.password = password;
      final signUpResponse = await api.signUp(organizerForm: builder.build());
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

  Future<ResponseCase> patchAccount(
      {required int id,
      required String userName,
      required String password}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    try {
      OrganizerPatchBuilder builder = OrganizerPatchBuilder();
      builder.name = userName;
      builder.password = password;
      final eventsResponse = await api.patchOrganizer(
          sessionToken: token,
          id: id.toString(),
          organizerPatch: builder.build());

      _userNameContoller.set(userName);
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) return ResponseCase.SESSION_ENDED;
      return ResponseCase.FAILED;
    }
  }

  Future<ResponseCase> deleteAccount({required int id}) async {
    String token = "";
    try {
      token = await _sessionTokenController.get();
    } catch (e) {
      return ResponseCase.SESSION_ENDED;
    }
    try {
      final eventsResponse =
          await api.deleteOrganizer(sessionToken: token, id: id.toString());
      return ResponseCase.OK;
    } on DioError catch (e) {
      if (e.response!.statusCode == 403) return ResponseCase.SESSION_ENDED;
      return ResponseCase.FAILED;
    }
  }
}

signOut() {
  SessionTokenContoller().clear();
  UserNameContoller().clear();
}
