import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_provider.dart';

class TestsView extends StatefulWidget {
  const TestsView();

  @override
  State<TestsView> createState() => _TestsViewState();
}

class _TestsViewState extends State<TestsView> {
  late Openapi api;
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    api = context.read<APIProvider>().api;
    return Scaffold(
      appBar: AppBar(
        title: Text("Tests"),
      ),
      // Sets the content to the
      // center of the application page
      body: Center(
          // Sets the content of the Application
          child: Column(
        children: [
          Text(('Number of events ' + categories.length.toString())),
          Expanded(
            child: ListView.builder(
                itemCount: categories.length,
                prototypeItem: ListTile(
                  title: Text("first event"),
                ),
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(categories[index].name!),
                  );
                })),
          ),
          TextButton(
              onPressed: () {
                _loadData().then((value) => setState(() {}));
              },
              child: Text("Generate"))
        ],
      )),
    );
  }

  Future _loadData() async {
    final response = await api.getCategoriesApi().getCategories();
    categories = response.data!.toList();
  }
}
