import 'package:cp_assignment/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ContentInitalizing.dart';
import 'MyWatchlistScreen.dart';

class ContentDetailScreen extends StatelessWidget {
  final Content content;

  ContentDetailScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

            return Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width, 
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${content.imagePath}',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,                        
                      ),
                    ),                                
          Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Text(
                    content.title,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  // Release Date
                  Text(
                    'Release Date: ${content.releaseDate}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),               
                  // Rating
                  Text(
                    'Rating: ${content.rating}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                   // Overview
                  Text(
                    'Overview: ${content.overview}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                    SizedBox(height: 20.0),
                  // Add to Watchlist Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Add to Watchlist Button
                            ElevatedButton(                              
                              onPressed: () {
                                if (!movieProvider.isInWatchlist(content)) {
                                  movieProvider.addToWatchlist(content);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${content.title} added to watchlist.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${content.title} is already in watchlist.'),
                                    ),
                                  );
                                }
                              },
                              child: Text('Add to Watchlist'),
                            ),
                            SizedBox(width: 10.0),
                            // Add to MyWatchedlist Button
                            ElevatedButton(                              
                              onPressed: () {
                                if (!movieProvider.isInWatchedlist(content)) {
                                  movieProvider.addToWatchedlist(content);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${content.title} added to watchedlist.'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${content.title} is already in watchedlist.'),
                                    ),
                                  );
                                }
                              },
                              child: Text('Add to MyWatchedlist'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),                  
                  // Back Button
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(                    
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Back'),
                    ),
                  ),
                ],
              ),
            )          
              
            ]
          ),        
      ),     
    );
  }
}