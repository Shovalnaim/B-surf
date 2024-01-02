import 'package:flutter/material.dart';
import 'package:bbsurf/components/func.dart';
import 'package:bbsurf/pages/reset_page.dart';
import 'package:bbsurf/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bbsurf/components/text_box.dart';
import 'package:bbsurf/components/button.dart';
import 'nav_page.dart';

// Define the LoginPage as a StatefulWidget
class LoginPage extends StatefulWidget {
  static const String id =
      'login_page'; // Define a unique identifier for this page

  @override
  State<LoginPage> createState() =>
      _LoginPageState(); // Create the state for the LoginPage
}

// Create the state class for LoginPage
class _LoginPageState extends State<LoginPage> {
  // Create TextEditingController instances for email and password fields
  final emailController = TextEditingController();
  final passController = TextEditingController();

  // Function to handle user sign-in
  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      // Sign in with Firebase using email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      Navigator.pop(context);
      Navigator.pushNamed(
          context, NavPage.id); // Navigate to the NavPage on successful sign-in
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the CircularProgressIndicator dialog
      errorMessage(context, e.code);
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      height: 150,
                      child: Image.asset('lib/images/BB.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Image.asset('lib/images/BBB.png'),
                    ),
                    const SizedBox(height: 10),
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
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ResetPage.id);
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Button(
                      text: 'Sign-In',
                      onTap: signIn,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignupPage.id);
                      },
                      child: Text(
                        'New to B-surf? ',
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