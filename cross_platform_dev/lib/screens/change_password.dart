import 'package:flutter/material.dart';
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cp_assignment/screens/validation_mixin.dart'; 

// Widget for changing password
class ChangePassword extends StatelessWidget with ValidationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>(); 
    TextEditingController usernameController = TextEditingController(); // Controller for username text field
    TextEditingController passwordController = TextEditingController(); // Controller for password text field

    return Scaffold( 
      body: SingleChildScrollView( // SingleChildScrollView to enable scrolling
        child: Form( // Form widget for form validation
          key: formKey, // Assigning GlobalKey to the form
          child: Column(
            children: <Widget>[
              const Text( 
                'Username',
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
              TextFormField( // TextFormField for entering username
                controller: usernameController, // Assigning controller
                validator: (email) { // Validator function for email
                  if (isEmailValid(email!)) { 
                    return null; // Return null if email is valid
                  } else {
                    return 'Email address invalid'; // Return error message if email is invalid
                  }
                },
                decoration: const InputDecoration( 
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0), 
              const Text( 
                'New Password',
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
              TextFormField( // 
                controller: passwordController, // Assigning controller
                validator: (password) { 
                  if (isPasswordValid(password!)) { //checks if password is valid
                    return null; // Return null if password is valid
                  } else {
                    return 'Invalid Password.'; 
                  }
                },
                maxLength: 10, // Maximum length of password
                obscureText: true, // Hides entered text
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 16.0), 
              ElevatedButton( // updating password
                onPressed: () async {
                  if (formKey.currentState!.validate()) { // Validating form
                    formKey.currentState!.save(); // Saving form data
                    try {
                      // Get the current user
                      User? user = FirebaseAuth.instance.currentUser; // Retrieving current user
                      if (user != null) {
                        // Update password
                        await user.updatePassword(passwordController.text); 
                        // Show a popup alert
                        showDialog( 
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Password Updated'), // Dialog title
                              content: const Text(
                                  'Your password has been successfully updated!'), 
                              actions: [
                                TextButton( // Button to close dialog and navigate to home screen
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppHomeScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('OK'), 
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        throw Exception('No user signed in.'); // Throw error if no user is signed in
                      }
                    } catch (error) {
                      print('Error updating password: $error'); 
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update password.'), 
                          duration: Duration(seconds: 2), // Duration to display SnackBar
                        ),
                      );
                    }
                  }
                },
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
