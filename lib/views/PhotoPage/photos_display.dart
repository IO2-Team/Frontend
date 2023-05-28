import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/blob.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/session_ended.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';

class PhotosDisplay extends StatefulWidget {
  final int eventId;

  const PhotosDisplay({super.key, required this.eventId});
  @override
  State<PhotosDisplay> createState() => _PhotosDisplayState();
}

class _PhotosDisplayState extends State<PhotosDisplay> {
  Blob bloblController = Blob();
  final _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    EventsController eventsController = context.watch<EventsController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            Expanded(child: photoDisplay(eventsController)),
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
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            ResponseCase status = snapshot.data!.status;
            if (status == ResponseCase.SESSION_ENDED) {
              return sessionEnded(context);
            }
            if (status == ResponseCase.FAILED) {
              return Text('Get Images Failed');
            }
            List<ImageFile> images = snapshot.data!.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
              ),
              itemCount: images.length + 1,
              itemBuilder: (context, index) {
                return index != images.length
                    ? GestureDetector(
                        onTap: () async {
                          await deletePhoto(images[index].path, widget.eventId,
                              eventsController);
                          setState(() {});
                        },
                        child: Container(
                          child: Image.memory(
                            images[index].bytes,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : TextButton(
                        child: Text('Add new photo'),
                        onPressed: () async {
                          await addPhoto(widget.eventId, eventsController);
                          setState(() {});
                        },
                      );
              },
            );
          }
        });
  }

  Future<String> getImageFromBlob(String path, int numberOfTries) async {
    for (int i = 0; i < numberOfTries; i++) {
      try {
        return await bloblController.get(path);
      } catch (e) {
        print('Blob error begin');
        print(e.toString());
        print('blob error end');
      }
    }
    return "";
  }

  Future<ResponseWithState> getImages(
      int eventId, EventsController eventsController) async {
    ResponseWithState response =
        await eventsController.getImagesPaths(id: eventId);
    if (response.status != ResponseCase.OK) return response;
    List<ImageFile> images = [];
    for (String imagePath in response.data) {
      String imageString = "";
      try {
        imageString = await bloblController.get(imagePath);
        images.add(ImageFile(base64.decode(imageString), imagePath));
      } catch (e) {
        continue;
      }
    }
    return ResponseWithState(images, ResponseCase.OK);
  }

  Future addPhoto(int eventId, EventsController eventsController) async {
    late Uint8List imageFile;
    XFile? f = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      imageFile = await f.readAsBytes();
    }
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    ResponseWithState response =
        await eventsController.addPhotoPath(eventId: eventId);
    if (response.status == ResponseCase.FAILED) {
      context.pop();
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    'Something went wrong. Your photo cannot be added now (DB)'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    } else if (response.status == ResponseCase.SESSION_ENDED) {
      context.pop();
      await showDialog(
          context: context, builder: ((context) => sessionEnded(context)));
      return;
    }
    try {
      await bloblController.put(response.data, base64.encode(imageFile));
      context.pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    'Something went wrong. Your photo cannot be added now (BLOB)'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }
  }

  Future deletePhoto(
      String path, int eventId, EventsController eventsController) async {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    ResponseCase response =
        await eventsController.deletePhotoPath(eventId: eventId, path: path);
    if (response == ResponseCase.FAILED) {
      context.pop();
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    'Something went wrong. Your photo cannot be deleted now (DB)'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    } else if (response == ResponseCase.SESSION_ENDED) {
      context.pop();
      await showDialog(
          context: context, builder: ((context) => sessionEnded(context)));
      return;
    }
    try {
      await bloblController.delete(path);
      context.pop();
    } catch (e) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                    'Something went wrong. Your photo cannot be deleted now (BLOB)'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }
  }
}

class ImageFile {
  final Uint8List bytes;
  final String path;

  ImageFile(this.bytes, this.path);
}
