import 'package:campus_pulse/screens/profile_screen.dart';
import 'package:campus_pulse/screens/student_homescreen.dart';
import 'package:campus_pulse/screens/student_loginpage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/issue_expansion_screen.dart';
import '../screens/landscreen.dart';
import '../screens/reportissue.dart';

class AppRouter {
  // 2. Define simple route constants
  static const String landingRoute = '/';
  static const String studentHomeRoute = '/studenthome';
  static const String addissueRoute = '/add_issue';
  static const String studentLoginRoute = '/studentlogin';
  static const String profileRoute = '/profile';
  // static const String issueDetailRoute = 'issueDetail';
  // static const String addissueRoute = '/add_issue';

  // 3. Create the simple router
  GoRouter router = GoRouter(
    // initialLocation: loginRoute, // Start the app at the login page
    routes: [
      GoRoute(
        name: 'issueDetail',
        // The :id part is a variable. GoRouter will capture whatever
        // comes after /issue/ and pass it as a path parameter.
        path: '/issue/:id',
        builder: (context, state) {
          // 1. Extract the 'id' string from the route
          final String idString = state.pathParameters['id'] ?? '0';

          // 2. Convert it to an integer
          final int issueId = int.tryParse(idString) ?? 0;

          // 3. Pass the integer ID to your new screen
          return IssueDetailScreen(issueId: issueId);
        },
      ),
      GoRoute(
          path: profileRoute,
          name: 'profile',
          pageBuilder: (context, state) {
            return MaterialPage(child: ProfileScreen());
          }),
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
