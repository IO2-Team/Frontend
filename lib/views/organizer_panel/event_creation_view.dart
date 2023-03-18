import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/panel_navigation_bar.dart';
import 'package:webfrontend_dionizos/widgets/centered_view.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EventCreationView extends StatefulWidget {
  @override
  State<EventCreationView> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreationView> {
  final _formKey = GlobalKey<FormState>();

  final _titleTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _freePlacesNumberController = TextEditingController();
  final _startDateTextController = TextEditingController();
  final _endDateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            PanelNavigationBar(),
            SizedBox(
              height: 40,
            ),
            eventCreation(),
          ],
        ),
      ),
    );
  }

  Widget eventCreation() {
    return Form(
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
                          DateFormat('yyyy-MM-dd').format(pickedStartDate);
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
                      DateTime.parse(_startDateTextController.text).isAfter(
                          DateTime.parse(_endDateTextController.text))) {
                    return 'End date must be after start date';
                  }
                  return null;
                },
              ),
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
                      : Colors.green;
                }),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.go('/organizerPanel');
                }
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
