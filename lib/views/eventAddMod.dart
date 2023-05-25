import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/Locaction/get_current_location.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/session_ended.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:intl/intl.dart';
import 'package:webfrontend_dionizos/views/add_category.dart';

class EventAddMod extends StatefulWidget {
  final int? eventId;

  const EventAddMod({super.key, this.eventId});
  @override
  State<EventAddMod> createState() => _EventAddModState();
}

class _EventAddModState extends State<EventAddMod> {
  bool isFirst = true;
  EventModel event = EventModel.empty();
  final _formKey = GlobalKey<FormState>();
  final _addCategoryForm = GlobalKey<FormState>();

  final _titleTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _freePlacesNumberController = TextEditingController();
  final _startDateTextController = TextEditingController();
  final _endDateTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _addCategoryTextController = TextEditingController();
  final _imagePicker = ImagePicker();
  Uint8List imageFile = Uint8List(0);

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
            eventDetails(eventsController, categoriesController),
          ],
        ),
      ),
    );
  }

  Widget eventDetails(EventsController eventsController,
      CategoriesController categoriesController) {
    setCurrentPosition();
    return FutureBuilder<List<dynamic>>(
        future: widget.eventId != null
            ? Future.wait([
                categoriesController.getCategories(),
                eventsController.getEvent(widget.eventId!),
              ])
            : Future.wait([categoriesController.getCategories()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            List<Category> categories = snapshot.data![0];
            if (isFirst && widget.eventId != null) {
              ResponseWithState eventResponse = snapshot.data![1];
              if (eventResponse.status == ResponseCase.SESSION_ENDED) {
                return sessionEnded(context);
              }
              event = eventResponse.data;
              isFirst = false;
              _titleTextController.text = event.title;
              _nameTextController.text = event.name;
              _freePlacesNumberController.text = event.freePlace.toString();
              _startDateTextController.text =
                  DateFormat('yyyy-MM-dd HH:mm').format(event.startTime);
              _endDateTextController.text =
                  DateFormat('yyyy-MM-dd HH:mm').format(event.endTime);
              _locationTextController.text = event.addressName;
              if (event.placeSchema != null && event.placeSchema != "")
                imageFile = base64.decode(event.placeSchema!);
            }
            return Expanded(
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventTitleKey'),
                              readOnly: event.status == EventStatus.inFuture ||
                                      widget.eventId == null
                                  ? false
                                  : true,
                              controller: _titleTextController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.title),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter event Title'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter event Title';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventDescriptionKey'),
                              readOnly: event.status == EventStatus.inFuture ||
                                      widget.eventId == null
                                  ? false
                                  : true,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _nameTextController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.description),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter event description'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter event description';
                                } else
                                  return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventNumberKey'),
                              readOnly: event.status == EventStatus.inFuture ||
                                      widget.eventId == null
                                  ? false
                                  : true,
                              controller: _freePlacesNumberController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.numbers),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter number of places'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number of places';
                                } else if (int.parse(value) <= 0) {
                                  return "Number of free places must be > 0";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventStartDateKey'),
                              readOnly: true,
                              controller: _startDateTextController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_today_rounded),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter start date'),
                              onTap: () async {
                                if (widget.eventId != null &&
                                    event.status != EventStatus.inFuture)
                                  return;
                                DateTime? pickedStartDate =
                                    await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100));

                                if (pickedStartDate != null) {
                                  TimeOfDay? pickedStartTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime:
                                              TimeOfDay(hour: 0, minute: 0));

                                  event.startTime = DateTime(
                                      pickedStartDate.year,
                                      pickedStartDate.month,
                                      pickedStartDate.day,
                                      (pickedStartTime ??
                                              TimeOfDay(hour: 0, minute: 0))
                                          .hour,
                                      (pickedStartTime ??
                                              TimeOfDay(hour: 0, minute: 0))
                                          .minute);
                                  setState(() {
                                    _startDateTextController.text =
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(event.startTime);
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter start date';
                                } else if (event.startTime
                                    .isBefore(DateTime.now())) {
                                  return "Start time of event must be past now";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventEndDateKey'),
                              readOnly: true,
                              controller: _endDateTextController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_today_rounded),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter end date'),
                              onTap: () async {
                                if (widget.eventId != null &&
                                    event.status != EventStatus.inFuture)
                                  return;
                                DateTime? pickedEndDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100));
                                if (pickedEndDate != null) {
                                  TimeOfDay? pickedEndTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime:
                                              TimeOfDay(hour: 0, minute: 0));

                                  event.endTime = DateTime(
                                      pickedEndDate.year,
                                      pickedEndDate.month,
                                      pickedEndDate.day,
                                      (pickedEndTime ??
                                              TimeOfDay(hour: 0, minute: 0))
                                          .hour,
                                      (pickedEndTime ??
                                              TimeOfDay(hour: 0, minute: 0))
                                          .minute);
                                  setState(() {
                                    _endDateTextController.text =
                                        DateFormat('yyyy-MM-dd HH:mm')
                                            .format(event.endTime);
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter end date';
                                } else if (DateTime.parse(
                                        _startDateTextController.text)
                                    .isAfter(DateTime.parse(
                                        _endDateTextController.text))) {
                                  return 'End date must be after start date';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              key: const Key('EventLocationKey'),
                              readOnly: true,
                              controller: _locationTextController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.location_on_outlined),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter location'),
                              onTap: () async {
                                if (widget.eventId != null &&
                                    event.status != EventStatus.inFuture)
                                  return;
                                await showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Dialog(
                                        child: OpenStreetMapSearchAndPick(
                                            center: LatLong(event.latitude,
                                                event.longitude),
                                            onPicked: (pickedData) {
                                              _locationTextController.text =
                                                  pickedData.address;
                                              event.longitude =
                                                  pickedData.latLong.longitude;
                                              event.latitude =
                                                  pickedData.latLong.latitude;
                                              context.pop();
                                            }),
                                      );
                                    }));
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: FormField(
                                      builder: (FormFieldState state) =>
                                          Column(children: [
                                        MultiSelectDialogField(
                                            key: GlobalKey(
                                                debugLabel:
                                                    'ChooseCategoriesKey'),
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                            ),
                                            chipDisplay: MultiSelectChipDisplay(
                                              items: categories
                                                  .map((e) => MultiSelectItem(
                                                      e, e.name))
                                                  .toList(),
                                              chipColor: categoriesColor,
                                              textStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            buttonText:
                                                Text('Choose categories'),
                                            initialValue: event.categories,
                                            items: categories
                                                .map((e) =>
                                                    MultiSelectItem(e, e.name))
                                                .toList(),
                                            listType: MultiSelectListType.CHIP,
                                            onConfirm: (values) {
                                              if (widget.eventId != null &&
                                                  event.status !=
                                                      EventStatus.inFuture)
                                                return;
                                              event.categories = values;
                                              state.didChange(
                                                  event.categories.length > 0
                                                      ? "changed"
                                                      : null);
                                            }),
                                        state.hasError
                                            ? Text(
                                                state.errorText!,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12),
                                              )
                                            : Container()
                                      ]),
                                      validator: (value) {
                                        if (event.categories.length == 0) {
                                          return 'Please choose at least one category';
                                        }
                                        return null;
                                      },
                                    )),
                                    TextButton(
                                      onPressed: () async {
                                        await addCategory(
                                            context: context,
                                            key: _addCategoryForm,
                                            controller:
                                                _addCategoryTextController,
                                            categoriesController:
                                                categoriesController);
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Add new category',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                            'Pick place schema (Optional)'),
                                        onPressed: () async {
                                          if (widget.eventId != null &&
                                              event.status !=
                                                  EventStatus.inFuture) return;
                                          XFile? f =
                                              await _imagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (f != null) {
                                            imageFile = await f.readAsBytes();
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      imageFile.length == 0
                                          ? Container()
                                          : SizedBox(
                                              //height: 400,
                                              child: Image.memory(
                                              imageFile,
                                              fit: BoxFit.fill,
                                            ))
                                    ])),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.eventId == null ||
                                      event.status != EventStatus.inFuture
                                  ? Container()
                                  : TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          return states.contains(
                                                  MaterialState.disabled)
                                              ? null
                                              : Colors.white;
                                        }),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          return states.contains(
                                                  MaterialState.disabled)
                                              ? null
                                              : Colors.red;
                                        }),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          showDialog(
                                              // The user CANNOT close this dialog  by pressing outsite it
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  // The background color
                                                  backgroundColor: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                          final result = await eventsController
                                              .cancelEvent(id: event.id);
                                          if (result == ResponseCase.FAILED) {
                                            context.pop();
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          'Something went wrong. Your event cannot be canceled now'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            context.pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ));
                                          }
                                          context.go('/organizerPanel');
                                        }
                                      },
                                      child: Text('Cancel event'),
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (event.status == EventStatus.inFuture ||
                                      widget.eventId == null)
                                    TextButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          return states.contains(
                                                  MaterialState.disabled)
                                              ? null
                                              : Colors.white;
                                        }),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (Set<MaterialState> states) {
                                          return states.contains(
                                                  MaterialState.disabled)
                                              ? null
                                              : Colors.green;
                                        }),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          showDialog(
                                              // The user CANNOT close this dialog  by pressing outsite it
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  // The background color
                                                  backgroundColor: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                          final result = widget.eventId != null
                                              ? await eventsController.patchEvent(
                                                  id: event.id,
                                                  title:
                                                      _titleTextController.text,
                                                  name:
                                                      _nameTextController.text,
                                                  maxPlace: int.parse(
                                                      _freePlacesNumberController
                                                          .text),
                                                  startTime:
                                                      event.startTime.toUtc(),
                                                  endTime:
                                                      event.endTime.toUtc(),
                                                  latitude: event.latitude
                                                      .toStringAsFixed(7),
                                                  longitude: event.longitude
                                                      .toStringAsFixed(7),
                                                  categories: event.categories
                                                      .map((e) => e.id)
                                                      .toList(),
                                                  placeSchema: imageFile.length == 0
                                                      ? ""
                                                      : base64
                                                          .encode(imageFile))
                                              : await eventsController.addEvent(
                                                  title:
                                                      _titleTextController.text,
                                                  name: _nameTextController.text,
                                                  maxPlace: int.parse(_freePlacesNumberController.text),
                                                  startTime: event.startTime.toUtc(),
                                                  endTime: event.endTime.toUtc(),
                                                  latitude: event.latitude.toStringAsFixed(7),
                                                  longitude: event.longitude.toStringAsFixed(7),
                                                  categories: event.categories.map((e) => e.id).toList(),
                                                  placeSchema: imageFile.length == 0 ? "" : base64.encode(imageFile));

                                          if (result == false) {
                                            context.pop();
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(widget
                                                                  .eventId !=
                                                              null
                                                          ? 'Something went wrong. Your event cannot be patched now'
                                                          : 'Something went wrong. Your event cannot be added now'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            context.pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    ));
                                          }
                                          context.go('/organizerPanel');
                                        }
                                      },
                                      child: Text(widget.eventId != null
                                          ? 'Save changes'
                                          : 'Add'),
                                    ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (Set<MaterialState> states) {
                                        return states.contains(
                                                MaterialState.disabled)
                                            ? null
                                            : Colors.white;
                                      }),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (Set<MaterialState> states) {
                                        return states.contains(
                                                MaterialState.disabled)
                                            ? null
                                            : Colors.red;
                                      }),
                                    ),
                                    onPressed: () =>
                                        context.go('/organizerPanel'),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }

  Future setCurrentPosition() async {
    final response = await determinePosition().catchError((e) {
      return LatLong(52, 21);
    });
    event.latitude = response.latitude;
    event.longitude = response.longitude;
  }
}
