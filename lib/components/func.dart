import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * Locate and open Google Maps for a specified location using its coordinates.
 *
 * @param {String} collectionName - The name of the collection containing the location data.
 * @param {String} documentId - The unique identifier for the document containing the location data.
 * @throws {Error} If an error occurs during the location retrieval or opening Google Maps.
 */
Future<void> locate(String collectionName, String documentId) async {
  GeoPoint? cords = await getCoordinates(collectionName, documentId);
  if (cords != null) {
    double latitude = cords.latitude;
    double longitude = cords.longitude;
    openGoogleMaps(latitude, longitude);
  } else {
    print("Coordinates not available for this location.");
  }
}

/**
 * Retrieve coordinates (GeoPoint) for a specified location document from a Firestore collection.
 *
 * @param {String} collectionName - The name of the Firestore collection containing the location data.
 * @param {String} documentId - The unique identifier for the document containing the location data.
 * @returns {Future<GeoPoint|null>} A Future that resolves to the GeoPoint coordinates if the document exists, or null if the document does not exist or if an error occurs.
 * @throws {Error} If an error occurs during the retrieval process.
 */
Future<GeoPoint?> getCoordinates(
    String collectionName, String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(collectionName)
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      GeoPoint? cords = snapshot.data()?['coords'] as GeoPoint?;
      return cords;
    }
    return null;
  } catch (error) {
    print("Error retrieving coordinates: $error");
    return null;
  }
}

/**
 * Open Google Maps with the specified latitude and longitude coordinates.
 *
 * This function constructs a Google Maps URL with the provided coordinates and attempts to open it.
 *
 * @param {double} latitude - The latitude coordinate of the location.
 * @param {double} longitude - The longitude coordinate of the location.
 * @throws {String} If Google Maps cannot be launched or if an error occurs during the launch process.
 */
void openGoogleMaps(double latitude, double longitude) async {
  String url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/**
 * Display an error message in an AlertDialog.
 *
 * This function creates and displays an AlertDialog containing the specified error message.
 *
 * @param {BuildContext} context - The BuildContext for displaying the error message.
 * @param {String} error - The error message to be displayed.
 */
void errorMessage(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(error),
        ),
      );
    },
  );
}

/**
 * A constant BoxDecoration with a gradient background.
 *
 * This BoxDecoration creates a gradient background with a transition from Colors.blue to Colors.white.
 * It can be used to apply a consistent gradient background to UI elements in your Flutter application.
 */
const BoxDecoration gradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.blue, Colors.white],
  ),
);