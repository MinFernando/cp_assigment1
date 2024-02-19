import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';

class ChangeUsernameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Change Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (username) {
                  if (username != null && username.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid username';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Username Changed'),
                        content: const Text(
                            'Your username has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Enter'),
              ),
              const SizedBox(height: 550.0),
              Align(
                alignment: Alignment.topRight,                              
                child: ElevatedButton.icon(
                  onPressed: () {                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );                                
                  },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back'),
                  ),
                ), 
            ],
          ),
        ),
      ),
    );
  }
}