import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/api_provider.dart';
import 'package:webfrontend_dionizos/views/home/home_view.dart';
import 'package:webfrontend_dionizos/views/signIn/signIn_view.dart';
import 'package:webfrontend_dionizos/views/signUp/signup_view.dart';
import 'package:webfrontend_dionizos/views/tests/tests_view.dart';

void main() => runApp(
      ChangeNotifierProvider<APIProvider>(
        create: (_) => APIProvider(),
        child: MyApp(),
      ),
    );

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
      routes: [
        GoRoute(
          path: 'signUp',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpView();
          },
        ),
        GoRoute(
          path: 'signIn',
          builder: (BuildContext context, GoRouterState state) {
            return const SignInView();
          },
        ),
        GoRoute(
          path: 'tests',
          builder: (BuildContext context, GoRouterState state) {
            return const TestsView();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
      ),
      routerConfig: _router,
      // home: MyHomePage(
      //     title: 'Flutter Demo Home Page',
      //     api: Openapi(
      //         dio: Dio(BaseOptions(
      //             baseUrl: 'https://dionizos-backend-app.azurewebsites.net')),
      //         serializers: standardSerializers)),
    );
  }
}
