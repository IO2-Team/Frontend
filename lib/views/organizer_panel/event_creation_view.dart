import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/Locaction/get_current_location.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:webfrontend_dionizos/views/add_category.dart';

class EventCreationView extends StatefulWidget {
  @override
  State<EventCreationView> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreationView> {
  final _formKey = GlobalKey<FormState>();
  final _addCategoryForm = GlobalKey<FormState>();

  final _titleTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _freePlacesNumberController = TextEditingController();
  final _startDateTextController = TextEditingController();
  late DateTime _startDate;
  late TimeOfDay _startTime;
  final _endDateTextController = TextEditingController();
  late DateTime _endDate;
  late TimeOfDay _endTime;
  final _locationTextController = TextEditingController();
  final _categoriesTextController = TextEditingController();

  final _addCategoryTextController = TextEditingController();
  late double latitude = 52.14;
  late double longitude = 21.01;
  List<Category> categories = [];
  List<Category> chosenCategories = [];

  @override
  Widget build(BuildContext context) {
    CategoriesController categoriesController =
        context.watch<CategoriesController>();
    EventsController eventsController = context.watch<EventsController>();
    setCurrentPosition();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            eventCreation(eventsController, categoriesController),
          ],
        ),
      ),
    );
  }

  Widget eventCreation(EventsController eventsController,
      CategoriesController categoriesController) {
    return FutureBuilder<List<Category>>(
        future: categoriesController.getCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            ));
          } else {
            List<Category> categories = snapshot.data!;
            return Expanded(
              child: ListView(children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                            readOnly: true,
                            controller: _startDateTextController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today_rounded),
                                border: OutlineInputBorder(),
                                hintText: 'Enter start date'),
                            onTap: () async {
                              DateTime? pickedStartDate = await showDatePicker(
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

                                _startDate = DateTime(
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
                                          .format(_startDate);
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter start date';
                              } else if (_startDate.isBefore(DateTime.now())) {
                                return "Start time of event must be past now";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _endDateTextController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.calendar_today_rounded),
                                border: OutlineInputBorder(),
                                hintText: 'Enter end date'),
                            onTap: () async {
                              DateTime? pickedEndDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (pickedEndDate != null) {
                                TimeOfDay? pickedEndTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: 0, minute: 0));

                                _endDate = DateTime(
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
                                          .format(_endDate);
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter end date';
                              } else if (_startDateTextController.text !=
                                      null &&
                                  DateTime.parse(_startDateTextController.text)
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
                            readOnly: true,
                            controller: _locationTextController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.location_on_outlined),
                                border: OutlineInputBorder(),
                                hintText: 'Enter location'),
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Dialog(
                                      child: OpenStreetMapSearchAndPick(
                                          center: LatLong(latitude, longitude),
                                          onPicked: (pickedData) {
                                            _locationTextController.text =
                                                pickedData.address;
                                            longitude =
                                                pickedData.latLong.longitude;
                                            latitude =
                                                pickedData.latLong.latitude;
                                            Navigator.pop(context);
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
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                          ),
                                          chipDisplay: MultiSelectChipDisplay(
                                            items: categories
                                                .map((e) =>
                                                    MultiSelectItem(e, e.name))
                                                .toList(),
                                            chipColor: Colors.green,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                          buttonText: Text('Choose categories'),
                                          items: categories
                                              .map((e) =>
                                                  MultiSelectItem(e, e.name))
                                              .toList(),
                                          listType: MultiSelectListType.CHIP,
                                          onConfirm: (values) {
                                            chosenCategories = values;
                                            state.didChange(
                                                chosenCategories.length > 0
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
                                      if (value == null) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
                                      ? null
                                      : Colors.white;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
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
                                  final result =
                                      await eventsController.addEvent(
                                          title: _titleTextController.text,
                                          name: _nameTextController.text,
                                          maxPlace: int.parse(
                                              _freePlacesNumberController.text),
                                          startTime: _startDate.toUtc(),
                                          endTime: _endDate.toUtc(),
                                          latitude: latitude.toStringAsFixed(7),
                                          longitude:
                                              longitude.toStringAsFixed(7),
                                          categories: chosenCategories
                                              .map((e) => e.id)
                                              .toList());

                                  if (result == false) {
                                    context.pop();
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'Something went wrong. Your event cannot be added now'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ));
                                  }
                                  context.go('/organizerPanel');
                                }
                              },
                              child: const Text('Add event'),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
                                      ? null
                                      : Colors.white;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
                                      ? null
                                      : Colors.red;
                                }),
                              ),
                              onPressed: () {
                                context.go('/organizerPanel');
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ]),
            );
          }
        });
  }

  Future setCurrentPosition() async {
    final response = await determinePosition().catchError((e) {
      return LatLong(latitude, longitude);
    });
    latitude = response.latitude;
    longitude = response.longitude;
  }
}
