import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/Locaction/get_current_location.dart';
import 'package:webfrontend_dionizos/api/blob.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/session_ended.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:intl/intl.dart';
import 'package:webfrontend_dionizos/views/add_category.dart';

class PhotosDisplay extends StatefulWidget {
  final int eventId;

  const PhotosDisplay({super.key, required this.eventId});
  @override
  State<PhotosDisplay> createState() => _PhotosDisplayState();
}

class _PhotosDisplayState extends State<PhotosDisplay> {
  Blob bloblController = Blob();
  @override
  Widget build(BuildContext context) {
    EventsController eventsController = context.watch<EventsController>();
    CategoriesController categoriesController =
        context.watch<CategoriesController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            photoDisplay(eventsController),
          ],
        ),
      ),
    );
  }

  Widget photoDisplay(EventsController eventsController) {
    return FutureBuilder<ResponseWithState>(
        future: getImages(widget.eventId, eventsController),
        builder:
            (BuildContext context, AsyncSnapshot<ResponseWithState> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            List<Uint8List> imagesBytes = snapshot.data!.data;
            ResponseCase status = snapshot.data!.status;
            if (status == ResponseCase.SESSION_ENDED) {
              return sessionEnded(context);
            }
            if (status == ResponseCase.FAILED) {
              return Text('Get Images Failed');
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
              ),
              itemCount: imagesBytes.length + 1,
              itemBuilder: (context, index) {
                return index != imagesBytes.length
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Image.memory(
                            imagesBytes[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Expanded(
                        child: TextButton(
                        child: Text('Add new photo'),
                        onPressed: () {},
                      ));
              },
            );
          }
        });
  }

  Future<ResponseWithState> getImages(
      int eventId, EventsController eventsController) async {
    ResponseWithState response =
        await eventsController.getImagesPaths(id: eventId);
    if (response.status != ResponseCase.OK) return response;
    List<Uint8List> imagesBytes = [];
    for (String imagePath in response.data) {
      String imageString = await bloblController.get(imagePath);
      imagesBytes.add(base64.decode(imageString));
    }
    return ResponseWithState(imagesBytes, ResponseCase.OK);
  }
}
