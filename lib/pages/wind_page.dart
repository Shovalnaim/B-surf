import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/func.dart';

class WindPage extends StatefulWidget {
  static const String id = 'wind_page';

  @override
  _WindPageState createState() => _WindPageState();
}

class _WindPageState extends State<WindPage> {
  String _selectedValue = '0:30';
  List<String> _windLines = []; // Declare _helloLines here
  Position? _userLocation; // Add this variable to store user's location
  String _windMessage = ''; // Add this variable to store the wind message

  /**
   * Check and request location permissions, and handle location access scenarios.
   *
   * This function checks the current location permissions using `Geolocator.checkPermission()`,
   * and then requests permissions using `Geolocator.requestPermission()` if needed.
   * It handles scenarios where the user has denied location permissions, permanently denied them,
   * or granted permissions, and takes appropriate actions such as showing dialogs and retrieving the user's location.
   *
   * @throws {Exception} If an error occurs during the permission check or location retrieval.
   */
  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.deniedForever) {
        // The user has permanently denied location permissions.
        showPermanentlyDeniedDialog(context);
      } else if (permission == LocationPermission.denied) {
        // The user denied location permissions.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Access Required'),
              content: Text(
                  'To use this feature, please reload the page and grant location access.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Permission granted. You can proceed to get the user's location.
        Position position = await Geolocator.getCurrentPosition();
        // Now you can send this location to your cloud app.
        setState(() {
          _userLocation = position;
        });
      }
    } else if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permissions.
      showPermanentlyDeniedDialog(context);
    } else {
      // Permission already granted. You can proceed to get the user's location.
      Position position = await Geolocator.getCurrentPosition();
      // Now you can send this location to your cloud app.
      setState(() {
        _userLocation = position;
      });
    }
  }

  /**
   * Fetch wind information from a given URL and update the wind lines.
   *
   * This function makes an HTTP GET request to the specified URL to retrieve wind information.
   * It handles the response status code and updates the `_windLines` state with the wind data if the response is successful (status code 200).
   * If there is an error during the request, it prints an error message.
   *
   * @param {String} url - The URL to fetch wind information from.
   * @throws {Exception} If an error occurs during the HTTP request or data processing.
   */
  Future<void> fetchSpotsWind(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // is ok
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<String> windLines = jsonResponse.cast<String>();

        print('Wind Lines:');
        print(windLines);

        setState(() {
          _windLines = windLines;
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/windy.jpg'),
                    radius: 120,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Please select Max Drive Time: ',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                  items: <String>[
                    '0:30',
                    '1:00',
                    '1:30',
                    '2:00',
                    '2:30',
                    '3:00',
                    '3:30',
                    '4:00',
                    '4:30',
                    '5:00',
                    '5:30',
                    '6:00',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                    Size(200, 60), // Set the minimum size of the button
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await checkAndRequestLocationPermission();
                    final latitude =
                       _userLocation?.latitude;
                    final longitude =
                        _userLocation?.longitude;

                    // Get the current user
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final uid =
                          user.uid; // Get the UID of the authenticated user
                      final url =
                          'https://us-central1-b-surf.cloudfunctions.net/findSpotsWind?value=$_selectedValue&latitude=$latitude&longitude=$longitude&uid=$uid';
                      print('URL: $url');

                      await fetchSpotsWind(url);
                      // Update the wind message based on whether wind data is available
                      setState(() {
                        if (_windLines.isNotEmpty) {
                          _windMessage =
                          ''; // Clear the message if there is wind data
                        } else {
                          _windMessage = 'No wind in the next 3 days :(';
                        }
                      });
                    } else {
                      print('error getting the user');
                    }
                    Navigator.pop(context); // Close the loading dialog
                  },
                  child: Text(
                    'Find The Wind',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Column(
                    children: [
                      if (_windMessage.isNotEmpty)
                        Text(
                          _windMessage,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      for (var line in _windLines)
                        Text(
                          line,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showPermanentlyDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Location Access Required'),
        content: Text(
            'You have permanently denied location access. To use this feature, please enable location access in your device settings.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}