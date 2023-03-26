import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/Locaction/get_current_location.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EventDetailsView extends StatefulWidget {
  @override
  State<EventDetailsView> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetailsView> {
  final _formKey = GlobalKey<FormState>();

  final _titleTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _freePlacesNumberController = TextEditingController();
  final _startDateTextController = TextEditingController();
  final _endDateTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _categoriesTextController = TextEditingController();
  late double latitude = 52.14;
  late double longitude = 21.01;
  List<Category> categories = [];
  List<Category> chosenCategories = [];

  @override
  Widget build(BuildContext context) {
    EventsController eventsController = context.watch<EventsController>();
    CategoriesController categoriesController =
        context.watch<CategoriesController>();
    setCurrentPosition();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            eventDetails(eventsController.selectedEvent,
                categoriesController.categoriesList),
          ],
        ),
      ),
    );
  }

  Widget eventDetails(Event event, List<Category> categories) {
    chosenCategories = eventCategories(event);
    _titleTextController.text = event.title!;
    _nameTextController.text = event.name!;
    _freePlacesNumberController.text = event.freePlace.toString();
    _startDateTextController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(event.startTime!));
    _endDateTextController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(event.endTime!));
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          setState(() {
                            _startDateTextController.text =
                                DateFormat('yyyy-MM-dd')
                                    .format(pickedStartDate);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter start date';
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
                          setState(() {
                            _endDateTextController.text =
                                DateFormat('yyyy-MM-dd').format(pickedEndDate);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter end date';
                        } else if (_startDateTextController.text != null &&
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
                                      longitude = pickedData.latLong.longitude;
                                      latitude = pickedData.latLong.latitude;
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
                    child: FormField(
                      builder: (FormFieldState state) => Column(children: [
                        MultiSelectDialogField(
                          chipDisplay: MultiSelectChipDisplay(
                            items: categories
                                .map((e) => MultiSelectItem(e, e.name!))
                                .toList(),
                            chipColor: Colors.green,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          buttonIcon: Icon(Icons.category),
                          buttonText: Text('Choose categories'),
                          initialValue: chosenCategories,
                          items: categories
                              .map((e) => MultiSelectItem(e, e.name!))
                              .toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            chosenCategories = values;
                            state.didChange(
                                chosenCategories.length > 0 ? "changed" : null);
                          },
                          onSelectionChanged: (values) {
                            chosenCategories = values;
                            state.didChange(
                                chosenCategories.length > 0 ? "changed" : null);
                          },
                        ),
                        state.hasError
                            ? Text(
                                state.errorText!,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              )
                            : Container()
                      ]),
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose at least one category';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? null
                                : Colors.white;
                          }),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? null
                                : Colors.green;
                          }),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.go('/organizerPanel');
                          }
                        },
                        child: const Text('Save changes'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (Set<MaterialState> states) {
                            return states.contains(MaterialState.disabled)
                                ? null
                                : Colors.white;
                          }),
                          backgroundColor: MaterialStateProperty.resolveWith(
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
        ],
      ),
    );
  }

  List<Category> eventCategories(Event event) {
    if (event.categories == null) {
      return List<Category>.empty();
    }
    return event.categories!.toList();
  }

  Future setCurrentPosition() async {
    final response = await determinePosition().catchError((e) {
      return LatLong(latitude, longitude);
    });
    latitude = response.latitude;
    longitude = response.longitude;
  }
}
