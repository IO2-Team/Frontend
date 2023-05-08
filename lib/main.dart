import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webfrontend_dionizos/api/categories_controller.dart';
import 'package:webfrontend_dionizos/api/events_controller.dart';
import 'package:webfrontend_dionizos/api/organizer_controller.dart';
import 'package:webfrontend_dionizos/views/account/account_view.dart';
import 'package:webfrontend_dionizos/views/home/home_view.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/event_creation_view.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/event_details_view.dart';
import 'package:webfrontend_dionizos/views/organizer_panel/organizer_panel_view.dart';
import 'package:webfrontend_dionizos/views/signIn/signIn_view.dart';
import 'package:webfrontend_dionizos/views/signUp/signup_view.dart';
import 'package:webfrontend_dionizos/utils/appColors.dart';

void main() => runApp(
    // ChangeNotifierProvider<APIProvider>(
    //   create: (_) => APIProvider(),
    //   child: MyApp(),
    // ),
    MyApp());

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
            path: 'organizerPanel',
            builder: (BuildContext context, GoRouterState state) {
              return OrganizerPanelView();
            },
            routes: [
              GoRoute(
                path: 'eventDetails',
                builder: (BuildContext context, GoRouterState state) {
                  return EventDetailsView();
                },
              ),
              GoRoute(
                path: 'addEvent',
                builder: (BuildContext context, GoRouterState state) {
                  return EventCreationView();
                },
              ),
              GoRoute(
                path: 'account',
                builder: (BuildContext context, GoRouterState state) {
                  return AccountView();
                },
              ),
            ]),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventsController()),
        ChangeNotifierProvider(create: (_) => CategoriesController()),
        ChangeNotifierProvider(create: (_) => OrganizerController())
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 250, 254, 255),
          primarySwatch: mainColor,
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
        ),
        routerConfig: _router,
      ),
    );
  }
}
