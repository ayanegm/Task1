import 'package:auth/pages/about_page.dart';
import 'package:auth/pages/home_screen.dart';
import 'package:auth/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   initialRoute: 'home',
    //   routes: {"home": (context) => HomeScreen()},
    // );
    return MaterialApp.router(
      title: 'go_router_Task',
      routerConfig: AppRouter.router,
    );
  }
}
