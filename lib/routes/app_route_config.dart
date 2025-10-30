import 'package:campus_pulse/screens/student_homescreen.dart';
import 'package:campus_pulse/screens/student_loginpage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/landscreen.dart';
import '../screens/reportissue.dart';

class AppRouter {
  // 2. Define simple route constants
  static const String landingRoute = '/';
  static const String studentHomeRoute = '/studenthome';
  static const String addissueRoute = '/add_issue';
  static const String studentLoginRoute = '/studentlogin';
  // static const String addissueRoute = '/add_issue';

  // 3. Create the simple router
  GoRouter router = GoRouter(
    // initialLocation: loginRoute, // Start the app at the login page
    routes: [
      GoRoute(
        path: landingRoute,
        name: 'initial',
        pageBuilder: (context, state) {
          return MaterialPage(child: LandScreen());
        },
      ),
      GoRoute(
        path: studentLoginRoute,
        name: 'login',
        pageBuilder: (context, state) {
          return const MaterialPage(child: StudentLoginScreen());
        },
      ),
      GoRoute(
        path: studentHomeRoute,
        name: 'studenthome',
        pageBuilder: (context, state) {
          return const MaterialPage(child: StudentHomescreen());
        },
      ),
      GoRoute(
        path: addissueRoute,
        name: 'report',
        pageBuilder: (context, state) {
          return const MaterialPage(child: ReportIssueScreen());
        },
      ),
    ],
    // 4. Optional: Add a very simple error page
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: Center(
            child: Text('Error: ${state.error?.message}'),
          ),
        ),
      );
    },
  );
}
