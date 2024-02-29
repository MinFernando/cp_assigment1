import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditProfileScreen.dart';
import 'ValidationMixin.dart';

class ChangeUsernameScreen extends StatelessWidget with ValidationMixin {
  
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
                'New Username',
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
                  hintText: 'Enter your new username',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Password',
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
                  hintText: 'Enter password',
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
                        // Update username
                        await user.verifyBeforeUpdateEmail(usernameController.text);
                        // Show a popup alert
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Username Updated'),
                              content: const Text(
                                  'Your username has been successfully updated!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen()
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
                      print('Error updating username: $error');
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update username.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Update username'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
