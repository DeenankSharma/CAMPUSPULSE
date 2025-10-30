import 'package:campus_pulse/providers/student_details_provider.dart';
import 'package:campus_pulse/routes/app_route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final AppRouter appRouter = AppRouter();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set the navigation bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginDetailsProvider())
  ],child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusPulse',
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
