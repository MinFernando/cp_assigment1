import 'package:cp_assignment/main.dart';
import 'package:flutter/material.dart';

import 'BestMovieThisYear.dart';
import 'CinemaDisplay.dart';
import 'MyWatchlistScreen.dart';
import 'SearchResultsScreen.dart';
import 'SeriesDisplay.dart';
import 'VisitProfileScreen.dart';

class AppHomeScreen extends StatelessWidget {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp2.jpg'),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),                    
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,                    
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _searchController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a search term';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Actors, movies series...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (formGlobalKey.currentState!.validate()) {
                                  String searchTerm =
                                      _searchController.text.trim();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchResultsScreen(
                                        actorName: searchTerm,
                                        title: searchTerm,
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: Center(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60.0),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CinemaListScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Whats On Cinema?',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp3.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvListScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Whats on TV Tonight?',
                              style: TextStyle(fontSize: 16),
                            ),                                                        
                          ],
                        ),
                        imagePath: 'web/assets/cp4.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyWatchlistScreen(),
                            ),
                          );
                        },
                         label: const Row(
                          children: [
                            Text(
                              'My Watchlist',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp5.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisitProfileScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Visit Profile',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp6.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BestMoviesThisYear(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Best Rated Movies',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp7.jpg',                        
                      ),      
                      const SizedBox(height: 90.0),                                    
                    ],
                  ),
                ),
              ),              
            ),
          ],
        ),
      ),
    );
  }
   
  Widget buildStyledButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget label,
  }) {
    double containerWidth = MediaQuery.of(context).size.width * 0.3; // sets percentage for size so its responsive in different platforms
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 175, 47, 47), 
        padding: EdgeInsets.symmetric(horizontal: containerWidth * 0.2, vertical: containerWidth * 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white, // Set text color to white
        ),
      child: label,
      )
    );
  }

 Widget buildStyledButtonWithImage({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget label,
  required String imagePath,
}) {
  double containerWidth = MediaQuery.of(context).size.width * 0.8; // sets percentage for size so its responsive in different platforms
  double imageWidth = containerWidth * 0.2;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      width: containerWidth, 
      padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
        color: Color.fromARGB(255, 175, 47, 47),  
        borderRadius: BorderRadius.circular(10),
          ),
      child: Row(                      
        children: [
          Image.asset(imagePath, width: imageWidth),
          Flexible(
            child: buildStyledButton(
              context: context,
              onPressed: onPressed,
              label: label,
            ),
          ),
        ]          
      ),
    ),    
  );
}
}