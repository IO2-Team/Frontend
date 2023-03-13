import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_provider.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/organizer_panel_model.dart';

class OrganizerPanelController {
  OrganizerPanelModel model = OrganizerPanelModel();
  late EventApi _eventApi;
  late CategoriesApi _categoriesApi;
  OrganizerPanelController(BuildContext context) {
    final api = context.read<APIProvider>().api;
    _eventApi = api.getEventApi();
    _categoriesApi = api.getCategoriesApi();
  }
  Future _onInit(context) async {
    final api = context.read<APIProvider>().api;
    _eventApi = api.getEventApi();
    _categoriesApi = api.getCategoriesApi();
  }
}
