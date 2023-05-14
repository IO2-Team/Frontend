import 'package:flutter/foundation.dart' as foundation;
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'package:webfrontend_dionizos/api/api_connection_string.dart';
import 'package:webfrontend_dionizos/api/storage_controllers.dart';

class CategoriesController extends foundation.ChangeNotifier {
  CategoriesController() {}

  CategoriesApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: BackendConnectionString.currentlySelectedBackend)),
          serializers: standardSerializers)
      .getCategoriesApi();

  SessionTokenContoller _sessionTokenController = SessionTokenContoller();

  changeBackend() {
    api = Openapi(
            dio: Dio(BaseOptions(
                baseUrl: BackendConnectionString.currentlySelectedBackend)),
            serializers: standardSerializers)
        .getCategoriesApi();
  }

  Future<List<Category>> getCategories() async {
    final categoriesResponse = await api.getCategories();
    return categoriesResponse.data!.toList();
  }

  Future<bool> addCategory(String name) async {
    try {
      await api.addCategories(
          sessionToken: _sessionTokenController.get(), categoryName: name);
      return true;
    } catch (e) {
      return false;
    }
  }
}
