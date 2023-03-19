import 'package:flutter/foundation.dart' as foundation;
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class CategoriesController extends foundation.ChangeNotifier {
  CategoriesController() {
    getCategories();
  }

  CategoriesApi api = Openapi(
          dio: Dio(BaseOptions(
              baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
          serializers: standardSerializers)
      .getCategoriesApi();

  bool _loading = false;
  List<Category> _categories = [];
  Category? _selectedCategory;

  bool get loading => _loading;
  List<Category> get categoriesList => _categories;
  Category get selectedCategory => _selectedCategory!;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setEventsList(List<Category> categories) {
    _categories = categories;
  }

  getCategories() async {
    setLoading(true);
    final categoriesResponse = await api.getCategories();
    setEventsList(categoriesResponse.data!.asList());
    setLoading(false);
  }

  setSelectedEvent(Category category) {
    _selectedCategory = category;
  }
}
