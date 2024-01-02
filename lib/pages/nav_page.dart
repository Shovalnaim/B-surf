import 'package:bbsurf/pages/school_page.dart';
import 'package:bbsurf/pages/spots_page.dart';
import 'package:bbsurf/pages/wind_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/func.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'kite_page.dart';
import 'login_page.dart';

// Define the NavPage as a StatefulWidget
class NavPage extends StatefulWidget {
  static const String id =
      'nav_page'; // Define a unique identifier for this page

  @override
  _NavPageState createState() =>
      _NavPageState(); // Create the state for the NavPage
}

// Create the state class for NavPage
class _NavPageState extends State<NavPage> {
  int _currentIndex =
  2; // Initialize the current index for the bottom navigation bar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Define a list of pages to be displayed based on the selected index
  final List<Widget> _pages = [
    WindPage(),
    KitePage(),
    HomePage(),
    SpotsPage(),
    SchoolPage(),
  ];

  // Function to open the drawer
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('B - S u r f'), // Set the title of the AppBar
        leading: IconButton(
          icon: Icon(Icons.menu), // Add a menu icon to open the drawer
          onPressed: _openDrawer,
        ),
        backgroundColor:
        Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow from the AppBar
        flexibleSpace: Container(
          decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
        ),
      ),
      drawer: Drawer(
        // Add your drawer content here
        child: Container(
          color: Colors.white70,
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.surfing,
                    size: 100,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Info Page",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.pushNamed(context, InfoPage.id);
                },
              ),
              ListTile(
                title: Text(
                  "Sign out",
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(Icons.logout),
                onTap: () {
                  _signOut(); // Call the _signOut function to sign the user out
                  Navigator.pushNamed(
                      context, LoginPage.id); // Navigate to the LoginPage
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: _pages[_currentIndex], // Display the selected page
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CurvedNavigationBar(
                    color: Colors
                        .white38, // Set the background color for the bottom navigation bar
                    backgroundColor: Colors.transparent,
                    index: _currentIndex, // Set the current index
                    onTap: (index) {
                      setState(() {
                        _currentIndex =
                            index; // Update the current index on tap
                      });
                    },
                    items: [
                      Icon(Icons.wind_power, size: 30),
                      Icon(Icons.kitesurfing, size: 30),
                      Icon(Icons.home, size: 30),
                      Icon(Icons.beach_access, size: 30),
                      Icon(Icons.school, size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * Sign out the currently authenticated user.
 *
 * This function attempts to sign out the user using Firebase Authentication.
 * If the sign-out process is successful, the user is logged out.
 * If any errors occur during the sign-out process, they are caught and printed to the console.
 */
void _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print("Error signing out: $e");
  }
}