import 'package:flutter/material.dart';
import 'ChangeEmailScreen.dart';
import 'ChangeUsernameScreen.dart';
import 'VisitProfileScreen.dart';

class EditProfileScreen extends StatelessWidget {

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 300.0; 
    double buttonHeight = 50.0; 

    return Scaffold(        
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                   height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp6.jpg'),
                        fit: BoxFit.cover,
                      ),                    
                    ), 
                    child: Align(
                        alignment: Alignment.topLeft,                              
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
              ),
                Container(
                    width: MediaQuery.of(context).size.width * 5.0,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 100.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeUsernameScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Change username',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),
                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeEmailScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Change Email',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),                                                   
                          ]
                        ),
                      )
                    )
                   ]
                  ),
                )
              )
             );
           }
          }