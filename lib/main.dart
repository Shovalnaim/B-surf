import 'package:bbsurf/pages/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bbsurf/pages/login_page.dart';
import 'package:bbsurf/pages/home_page.dart';
import 'package:bbsurf/pages/signup_page.dart';
import 'package:bbsurf/pages/reset_page.dart';
import 'package:bbsurf/pages/spots_page.dart';
import 'package:bbsurf/pages/kite_page.dart';
import 'package:bbsurf/pages/info_page.dart';
import 'package:bbsurf/pages/wind_page.dart';
import 'package:bbsurf/pages/school_page.dart';
import 'package:bbsurf/pages/nav_page.dart';

void main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with specified options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(MyApp());
}

// The main Flutter application class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id, // Set the initial route to the LoginPage
      routes: {
        // Define the named routes and their corresponding pages
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (context) => HomePage(),
        SignupPage.id: (context) => SignupPage(),
        ResetPage.id: (context) => ResetPage(),
        SpotsPage.id: (context) => SpotsPage(),
        KitePage.id: (context) => KitePage(),
        InfoPage.id: (context) => InfoPage(),
        WindPage.id: (context) => WindPage(),
        SchoolPage.id: (context) => SchoolPage(),
        NavPage.id: (context) => NavPage(),
      },
    );
  }
}