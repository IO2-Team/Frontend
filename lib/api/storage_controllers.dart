import 'dart:html';

abstract class StorageController {
  final Storage _localStorage = window.localStorage;
  String get valueString;
  set(String value) {
    _localStorage[valueString] = value;
  }

  String get() {
    String? token = _localStorage[valueString];
    if (token == null) {
      throw Exception();
    }
    return token;
  }

  clear() {
    _localStorage.clear();
  }
}

class SessionTokenContoller extends StorageController {
  @override
  String get valueString => 'sessionToken';
}

class UserNameContoller extends StorageController {
  @override
  String get valueString => 'userName';
}

class PickedEventId extends StorageController {
  @override
  String get valueString => ' pickedId';
}
