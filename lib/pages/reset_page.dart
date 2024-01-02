import 'package:bbsurf/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbsurf/components/text_box.dart';
import 'package:bbsurf/components/button.dart';
import '../components/func.dart';

// Define the ResetPage as a StatefulWidget
class ResetPage extends StatefulWidget {
  static const String id =
      'reset_page'; // Define a unique identifier for this page

  @override
  State<ResetPage> createState() =>
      _ResetPageState(); // Create the state for the ResetPage
}

// Create the state class for ResetPage
class _ResetPageState extends State<ResetPage> {
  // Create a TextEditingController instance for email
  final emailController = TextEditingController();

  // Function to reset the password
  void resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (email.isEmpty) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Please enter your email address'),
          ));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'a reset password email have been sent to your mailbox'),
          ));
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
                    Text(
                      'Reset password page ',
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
                    Button(
                      text: 'Reset-Password',
                      onTap: () => resetPassword(context), // from func page
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Text(
                        'Back to Log-in Page ',
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