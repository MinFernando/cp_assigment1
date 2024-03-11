import 'package:cp_assignment/screens/AppHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ValidationMixin.dart';

class ChangePassword extends StatelessWidget with ValidationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Username',
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
              TextFormField(
                controller: usernameController,
                validator: (email) {
                  if (isEmailValid(email!))
                    return null;
                  else
                    return 'Email address invalid';
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
              TextFormField(
                controller: passwordController,
                validator: (password) {
                  if (isPasswordValid(password!))
                    return null;
                  else
                    return 'Invalid Password.';
                },
                maxLength: 10,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      // Get the current user
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Update password
                        await user.updatePassword(passwordController.text);
                        // Show a popup alert
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Password Updated'),
                              content: const Text(
                                  'Your password has been successfully updated!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppHomeScreen()
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
                        throw Exception('No user signed in.');
                      }
                    } catch (error) {
                      print('Error updating password: $error');
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update password.'),
                          duration: Duration(seconds: 2),
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
