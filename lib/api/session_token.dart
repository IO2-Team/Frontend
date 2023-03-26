import 'dart:html';

class SessionTokenContoller {
  final Storage _localStorage = window.localStorage;

  Future set(String sessionToken) async {
    _localStorage['sessionToken'] = sessionToken;
  }

  Future<String> get() async {
    String? token = _localStorage['sessionToken'];
    if (token == null) {
      throw Exception();
    }
    return token;
  }
}
