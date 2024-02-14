import 'package:cp_assignment/main.dart';
import 'package:flutter/material.dart';

import 'VisitProfileScreen.dart';

class ChangePassword extends StatelessWidget {
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
                'Change Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (password) {
                  if (password != null && password.isNotEmpty) {
                    return null;
                  } else
                    return 'Please enter a valid password';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Password changed'),
                        content: const Text(
                            'Your password has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VisitProfileScreen(),
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
                        builder: (context) => VisitProfileScreen(),
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