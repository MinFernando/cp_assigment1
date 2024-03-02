import 'package:cp_assignment/screens/MyWatchlistScreen.dart';
import 'package:cp_assignment/screens/watchedListScreen.dart';
import 'package:flutter/material.dart';
import 'AppHomeScreen.dart';
import 'EditProfileScreen.dart';
import 'HomePage.dart';

class VisitProfileScreen extends StatelessWidget {
  
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
                        filterQuality: FilterQuality.high,
                      ),                    
                    ),                      
                       child: Align(
                        alignment: Alignment.topLeft,                              
                        child: ElevatedButton.icon(
                          onPressed: () {                   
                            Navigator.push(
                              context,
                                MaterialPageRoute(
                                builder: (context) => AppHomeScreen(),
                              ),
                            );                                
                          },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Back'),
                          ),
                        ),      
                       ),   
                Container(
                    width: MediaQuery.of(context).size.width * 1.5,
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
                                        builder: (context) => EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Edit profile',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),                            
                            const SizedBox(height: 20.0),
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
                                        builder: (context) => MyWatchedlistScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'My Watchedlist',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),
                            const SizedBox(height: 20.0),
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
                                        builder: (context) => MyWatchlistScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'My Watchlist',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),
                            const SizedBox(height: 90.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 200,
                                height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                            title: 'Welcome to MovieMate!'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Log Out',
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