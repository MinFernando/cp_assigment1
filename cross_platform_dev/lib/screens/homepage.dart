import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/create_account.dart';
import 'package:cp_assignment/screens/firebase_auth.dart';
import 'package:cp_assignment/screens/forgot_password.dart';
import 'package:cp_assignment/screens/validation_mixin.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(); // Creating state for the widget.
}

// State class for MyHomePage, including input validation mixin.
class _MyHomePageState extends State<MyHomePage> with ValidationMixin {

   // TextEditingControllers for managing input fields.
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  // Instance of FirebaseAuthService for authentication.
  final FirebaseAuthService _auth = FirebaseAuthService();
  // Global key for form state management and validation.
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    // Initializing text controllers.
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Disposing controllers to prevent memory leaks.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Dismiss the keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();        
      },
      
      child: Scaffold(
      resizeToAvoidBottomInset: true, 
      body: SingleChildScrollView( // Allows the form to be scrollable when keyboard appears.
        child: Column(
          children: <Widget>[
            // Top image container.
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 2.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('web/assets/cp1.jpg'),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container for displaying the page title.
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formGlobalKey, // Associating global key with the form for validation.
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    // Username input field.
                    const Text(
                      'Username',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      validator: (email) {
                        if (isEmailValid(email!)) // checks if email is valid
                          return null; // if not returns null
                        else
                          return 'Email address invalid';
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (password) {
                        if (isPasswordValid(password!)) // checks if password is valid
                          return null; // if not returns null
                        else
                          return 'Invalid Password.';
                      },
                      maxLength: 6, //limits password to 6 characters
                      obscureText: true, // hides password
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // login button
                          ElevatedButton(
                            onPressed: () async {
                              if (formGlobalKey.currentState!.validate()) { // validates form
                                formGlobalKey.currentState!.save(); // save state

                                // retrieve username and password from input
                                String enteredUsername = _usernameController.text;
                                String enteredPassword = _passwordController.text;

                                try {
                                  // Sign in with Firebase
                                  final user = await _auth.signIn(enteredUsername, enteredPassword);
                                  if (user != null) {
                                    // if credentails exists navigate to home screen
                                     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppHomeScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Invalid username or password'), // if not show error message
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('Error: $e');
                                  print("Please Try again");
                                }
                              }
                            },
                            child: const Text('Login'),
                          ),
                          // forgot password button
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                          // create account button
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(),
                                ),
                              );
                            },
                            child: const Text('New User? Create account'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
