import 'package:bbsurf/components/func.dart';
import 'package:bbsurf/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbsurf/components/text_box.dart';
import 'package:bbsurf/components/button.dart';

// Define the SignupPage as a StatefulWidget
class SignupPage extends StatefulWidget {
  static const String id = 'signup_page';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

// Create the state class for SignupPage
class _SignupPageState extends State<SignupPage> {
  // Create TextEditingController instances for email, password, and confirmation fields
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confController = TextEditingController();

  // Function to check if a password is strong (meets specific criteria)
  bool isPasswordStrong(String password) {
    return password.length >= 6 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  // Function to handle user sign-up
  void signUp() async {
    if (passController.text != confController.text) {
      // Show an error dialog if passwords don't match
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                title: Text('Password Mismatch'),
              ),
            );
          });
    } else if (!isPasswordStrong(passController.text)) {
      // Show an error dialog if the password is not strong enough
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              title: Text(
                  'The Password needs to be atleast 6 letters length with numbers capital letters and small letters'),
            ),
          );
        },
      );
    } else {
      // Show a loading indicator while signing up
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        // Create a new user with Firebase Authentication
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );

        // Create a user document in the "users" collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'favoriteSpot': 'none', // Initialize with null or empty
          'deviceToken': 'none', // Initialize the device token
        });

        // Navigate to the LoginPage after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        // Close the loading indicator and show an error message for authentication failures
        Navigator.pop(context);
        errorMessage(context, e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBoxDecoration, // Apply the gradientBoxDecoration
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome new Surfer! ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextBox(
                      controller: emailController,
                      hint: ' Email Address',
                      secret: false,
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      controller: passController,
                      hint: ' Password',
                      secret: true,
                    ),
                    const SizedBox(height: 10),
                    TextBox(
                      controller: confController,
                      hint: ' Confirm Password',
                      secret: true,
                    ),
                    const SizedBox(height: 10),
                    Button(
                      text: 'Sign-Up',
                      onTap: signUp,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}