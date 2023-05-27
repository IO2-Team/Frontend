import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';

class BackendConnectionString {
  static final grupa1 = 'https://dionizos-backend-app.azurewebsites.net';
  static final grupa2 =
      'http://io2central-env.eba-vfjwqcev.eu-north-1.elasticbeanstalk.com';
  static final grupa3 = 'https://biletmajster.azurewebsites.net/';

  static String currentlySelectedBackend = grupa1;
}

updateBackend(
    EventsController eventsController,
    OrganizerController organizerController,
    CategoriesController categoriesController) {
  eventsController.changeBackend();
  organizerController.changeBackend();
  categoriesController.changeBackend();
}
