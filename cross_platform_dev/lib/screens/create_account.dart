import 'package:cp_assignment/screens/firebase_auth.dart';
import 'package:cp_assignment/screens/homepage.dart';
import 'package:cp_assignment/screens/validation_mixin.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

// The state class for CreateAccountScreen, including validation mixin for input fields.
class CreateAccountScreenState extends State<CreateAccountScreen> with ValidationMixin {

  // Text editing controllers to manage the input text for email and password.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Instance of the Firebase authentication service to handle sign up.
  final FirebaseAuthService _auth = FirebaseAuthService();
  // A global key that allows validation of the form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey, // Associate the form key with the Form widget.
          child: Column(
            children: <Widget>[
              // label for email input
              const Text(
                'Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                controller: emailController,
                validator: (email) {
                  if (isEmailValid(email!)) // checks if email valid
                    return null;
                  else
                    return 'Email address invalid'; // return error if not 
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                controller: passwordController,
                validator: (password) {
                  if (isPasswordValid(password!)) // checks if password is valid
                    return null;          
                  else
                    return 'Invalid Password.';
                },
                maxLength: 6, // max length is 6
                obscureText: true, //password is hidden
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) { // check if form is valid
                    formKey.currentState!.save(); // save state of form

                  //retrieve email from input controllers
                    String email = emailController.text;
                    String password = passwordController.text;

                  // attmpt to sign up
                    await signUp(email, password);
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle the sign-up process with Firebase authentication.
  Future<void> signUp(String email, String password) async {
    try {
      // Attempt to create a user account with the provided email and password.
      final user = await _auth.signUp(email, password);
      // If the user account is successfully created, navigate to the login page called myhomepage
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Welcome to MovieMate!"),
          ),
        );
      } else {
        print("unable to sign up, please try again later");
      }
    } catch (e) {
      print("Unable to sign up, please check your internet connection");
    }
  }
}
