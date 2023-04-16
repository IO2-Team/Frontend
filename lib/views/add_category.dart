import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';

Future addCategory(
    {required context,
    required GlobalKey<FormState> key,
    required TextEditingController controller,
    required CategoriesController categoriesController}) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add new category"),
          content: Form(
            key: key,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  hintText: 'category name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category name';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  if (key.currentState!.validate()) {
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
                    final result =
                        await categoriesController.addCategory(controller.text);
                    if (result == false) {
                      context.pop();
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title:
                                    const Text('Such category cannot be added'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    } else
                      context.pop();
                    context.pop();
                  }
                },
                child: const Text('Add')),
            TextButton(
                onPressed: () => context.pop(), child: const Text('Cancel'))
          ],
        );
      });
}
