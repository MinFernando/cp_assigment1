import 'package:cp_assignment/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:cp_assignment/screens/firebase_auth.dart';
import 'ValidationMixin.dart'; 

class CreateAccountScreen extends StatefulWidget {
  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> with ValidationMixin {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                controller: emailController,
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
                'Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                controller: passwordController,
                validator: (password) {
                  if (isPasswordValid(password!)) 
                    return null;
                  else
                    return 'Invalid Password.';
                },
                maxLength: 6,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    String email = emailController.text;
                    String password = passwordController.text;

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

  Future<void> signUp(String email, String password) async {
    try {
      final user = await _auth.signUp(email, password);
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
