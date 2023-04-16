// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
// import 'package:openapi/openapi.dart';
// import 'package:provider/provider.dart';
// import 'package:webfrontend_dionizos/api/Locaction/get_current_location.dart';
// import 'package:webfrontend_dionizos/api/categories_controller.dart';
// import 'package:webfrontend_dionizos/api/events_controller.dart';
// import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
// import 'package:webfrontend_dionizos/widgets/centered_view.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// class EventDetailsView extends StatefulWidget {
//   final int eventId;
//   EventDetailsView(this.eventId);
//   @override
//   State<EventDetailsView> createState() => _EventDetailsState();
// }

// class _EventDetailsState extends State<EventDetailsView> {
//   bool isFirst = true;
//   late EventModel event;
//   final _formKey = GlobalKey<FormState>();

//   final _titleTextController = TextEditingController();
//   final _nameTextController = TextEditingController();
//   final _freePlacesNumberController = TextEditingController();
//   final _startDateTextController = TextEditingController();
//   final _endDateTextController = TextEditingController();
//   final _locationTextController = TextEditingController();
//   final _categoriesTextController = TextEditingController();
//   // List<Category> categories = [];
//   // List<Category> chosenCategories = [];

//   @override
//   Widget build(BuildContext context) {
//     EventsController eventsController = context.watch<EventsController>();
//     CategoriesController categoriesController =
//         context.watch<CategoriesController>();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CenteredView(
//         child: Column(
//           children: <Widget>[
//             PanelNavigationBar(),
//             SizedBox(
//               height: 40,
//             ),
//             eventDetails(eventsController, categoriesController),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget eventDetails(EventsController eventsController,
//       CategoriesController categoriesController) {
//     return FutureBuilder<List<dynamic>>(
//         future: Future.wait([
//           eventsController.getEvent(widget.eventId),
//           categoriesController.getCategories()
//         ]),
//         builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if (!snapshot.hasData) {
//             return Expanded(
//                 child: Center(
//               child: Container(
//                 padding: const EdgeInsets.all(20.0),
//                 child: CircularProgressIndicator(),
//               ),
//             ));
//           } else {
//             List<Category> categories = snapshot.data![1];
//             if (isFirst) {
//               event = snapshot.data![0];
//               isFirst = false;
//               _titleTextController.text = event.title;
//               _nameTextController.text = event.name;
//               _freePlacesNumberController.text = event.freePlace.toString();
//               _startDateTextController.text =
//                   DateFormat('yyyy-MM-dd HH:mm').format(event.startTime);
//               _endDateTextController.text =
//                   DateFormat('yyyy-MM-dd HH:mm').format(event.endTime);
//               _locationTextController.text = event.addressName;
//             }
//             return Expanded(
//               child: ListView(
//                 children: [
//                   Form(
//                     key: _formKey,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               controller: _titleTextController,
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.title),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter event Title'),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter event Title';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               keyboardType: TextInputType.multiline,
//                               maxLines: null,
//                               controller: _nameTextController,
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.description),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter event description'),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter event description';
//                                 } else
//                                   return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               controller: _freePlacesNumberController,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.numbers),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter number of places'),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter number of places';
//                                 } else if (int.parse(value) <= 0) {
//                                   return "Number of free places must be > 0";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _startDateTextController,
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.calendar_today_rounded),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter start date'),
//                               onTap: () async {
//                                 DateTime? pickedStartDate =
//                                     await showDatePicker(
//                                         context: context,
//                                         initialDate: DateTime.now(),
//                                         firstDate: DateTime.now(),
//                                         lastDate: DateTime(2100));

//                                 if (pickedStartDate != null) {
//                                   TimeOfDay? pickedStartTime =
//                                       await showTimePicker(
//                                           context: context,
//                                           initialTime:
//                                               TimeOfDay(hour: 0, minute: 0));

//                                   event.startTime = DateTime(
//                                       pickedStartDate.year,
//                                       pickedStartDate.month,
//                                       pickedStartDate.day,
//                                       (pickedStartTime ??
//                                               TimeOfDay(hour: 0, minute: 0))
//                                           .hour,
//                                       (pickedStartTime ??
//                                               TimeOfDay(hour: 0, minute: 0))
//                                           .minute);
//                                   setState(() {
//                                     _startDateTextController.text =
//                                         DateFormat('yyyy-MM-dd HH:mm')
//                                             .format(event.startTime);
//                                   });
//                                 }
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter start date';
//                                 } else if (event.startTime
//                                     .isBefore(DateTime.now())) {
//                                   return "Start time of event must be past now";
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _endDateTextController,
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.calendar_today_rounded),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter end date'),
//                               onTap: () async {
//                                 DateTime? pickedEndDate = await showDatePicker(
//                                     context: context,
//                                     initialDate: DateTime.now(),
//                                     firstDate: DateTime.now(),
//                                     lastDate: DateTime(2100));
//                                 if (pickedEndDate != null) {
//                                   TimeOfDay? pickedEndTime =
//                                       await showTimePicker(
//                                           context: context,
//                                           initialTime:
//                                               TimeOfDay(hour: 0, minute: 0));

//                                   event.endTime = DateTime(
//                                       pickedEndDate.year,
//                                       pickedEndDate.month,
//                                       pickedEndDate.day,
//                                       (pickedEndTime ??
//                                               TimeOfDay(hour: 0, minute: 0))
//                                           .hour,
//                                       (pickedEndTime ??
//                                               TimeOfDay(hour: 0, minute: 0))
//                                           .minute);
//                                   setState(() {
//                                     _endDateTextController.text =
//                                         DateFormat('yyyy-MM-dd HH:mm')
//                                             .format(event.endTime);
//                                   });
//                                 }
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter end date';
//                                 } else if (_startDateTextController.text !=
//                                         null &&
//                                     DateTime.parse(
//                                             _startDateTextController.text)
//                                         .isAfter(DateTime.parse(
//                                             _endDateTextController.text))) {
//                                   return 'End date must be after start date';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _locationTextController,
//                               decoration: const InputDecoration(
//                                   icon: Icon(Icons.location_on_outlined),
//                                   border: OutlineInputBorder(),
//                                   hintText: 'Enter location'),
//                               onTap: () async {
//                                 await showDialog(
//                                     context: context,
//                                     builder: ((context) {
//                                       return Dialog(
//                                         child: OpenStreetMapSearchAndPick(
//                                             center: LatLong(event.latitude,
//                                                 event.longitude),
//                                             onPicked: (pickedData) {
//                                               _locationTextController.text =
//                                                   pickedData.address;
//                                               event.longitude =
//                                                   pickedData.latLong.longitude;
//                                               event.latitude =
//                                                   pickedData.latLong.latitude;
//                                               context.pop();
//                                             }),
//                                       );
//                                     }));
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter location';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: FormField(
//                               builder: (FormFieldState state) =>
//                                   Column(children: [
//                                 MultiSelectDialogField(
//                                   chipDisplay: MultiSelectChipDisplay(
//                                     items: categories
//                                         .map((e) => MultiSelectItem(e, e.name))
//                                         .toList(),
//                                     chipColor: Colors.green,
//                                     textStyle: TextStyle(color: Colors.white),
//                                   ),
//                                   buttonIcon: Icon(Icons.category),
//                                   buttonText: Text('Choose categories'),
//                                   initialValue: event.categories,
//                                   items: categories
//                                       .map((e) => MultiSelectItem(e, e.name))
//                                       .toList(),
//                                   listType: MultiSelectListType.CHIP,
//                                   onConfirm: (values) {
//                                     event.categories = values;
//                                     state.didChange(event.categories.length > 0
//                                         ? "changed"
//                                         : null);
//                                   },
//                                 ),
//                                 state.hasError
//                                     ? Text(
//                                         state.errorText!,
//                                         style: TextStyle(
//                                             color: Colors.red, fontSize: 12),
//                                       )
//                                     : Container()
//                               ]),
//                               validator: (value) {
//                                 if (event.categories.length == 0) {
//                                   return 'Please choose at least one category';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               if (event.status == EventStatus.inFuture)
//                                 TextButton(
//                                   style: ButtonStyle(
//                                     foregroundColor:
//                                         MaterialStateProperty.resolveWith(
//                                             (Set<MaterialState> states) {
//                                       return states
//                                               .contains(MaterialState.disabled)
//                                           ? null
//                                           : Colors.white;
//                                     }),
//                                     backgroundColor:
//                                         MaterialStateProperty.resolveWith(
//                                             (Set<MaterialState> states) {
//                                       return states
//                                               .contains(MaterialState.disabled)
//                                           ? null
//                                           : Colors.green;
//                                     }),
//                                   ),
//                                   onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       showDialog(
//                                           // The user CANNOT close this dialog  by pressing outsite it
//                                           barrierDismissible: false,
//                                           context: context,
//                                           builder: (_) {
//                                             return Dialog(
//                                               // The background color
//                                               backgroundColor: Colors.white,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 20),
//                                                 child: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: const [
//                                                     // The loading indicator
//                                                     CircularProgressIndicator(),
//                                                     SizedBox(
//                                                       height: 15,
//                                                     ),
//                                                     // Some text
//                                                     Text('Loading...')
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                       final result =
//                                           await eventsController.patchEvent(
//                                               id: event.id,
//                                               title: _titleTextController.text,
//                                               name: _nameTextController.text,
//                                               maxPlace: int.parse(
//                                                   _freePlacesNumberController
//                                                       .text),
//                                               startTime:
//                                                   event.startTime.toUtc(),
//                                               endTime: event.endTime.toUtc(),
//                                               latitude: event.latitude
//                                                   .toStringAsFixed(7),
//                                               longitude: event.longitude
//                                                   .toStringAsFixed(7),
//                                               categories: event.categories
//                                                   .map((e) => e.id)
//                                                   .toList());

//                                       if (result == false) {
//                                         context.pop();
//                                         await showDialog(
//                                             context: context,
//                                             builder: (context) => AlertDialog(
//                                                   title: const Text(
//                                                       'Something went wrong. Your event cannot be patched now'),
//                                                   actions: <Widget>[
//                                                     TextButton(
//                                                       onPressed: () {
//                                                         context.pop();
//                                                       },
//                                                       child: const Text('OK'),
//                                                     ),
//                                                   ],
//                                                 ));
//                                       }
//                                       context.go('/organizerPanel');
//                                     }
//                                   },
//                                   child: const Text('Save changes'),
//                                 ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               TextButton(
//                                 style: ButtonStyle(
//                                   foregroundColor:
//                                       MaterialStateProperty.resolveWith(
//                                           (Set<MaterialState> states) {
//                                     return states
//                                             .contains(MaterialState.disabled)
//                                         ? null
//                                         : Colors.white;
//                                   }),
//                                   backgroundColor:
//                                       MaterialStateProperty.resolveWith(
//                                           (Set<MaterialState> states) {
//                                     return states
//                                             .contains(MaterialState.disabled)
//                                         ? null
//                                         : Colors.red;
//                                   }),
//                                 ),
//                                 onPressed: () => context.go('/organizerPanel'),
//                                 child: const Text('Cancel'),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//         });
//   }

//   List<Category> eventCategories(EventModel event) {
//     if (event.categories == null) {
//       return List<Category>.empty();
//     }
//     return event.categories.toList();
//   }
// }
