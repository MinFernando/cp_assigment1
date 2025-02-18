import 'dart:ui';
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
      body: Stack(
        children: [
          // Background Image with Blur
          Positioned.fill(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${content.imagePath}',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
            Positioned(              
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  disabledBackgroundColor: Colors.white,
                ),
              ),
            ),
          SingleChildScrollView(
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                    Center(
                      child: ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 36), 
                        ),
                      ),
                    ),

                      SizedBox(height: 10.0), // Spacing between buttons

                      // Add to MyWatchedlist Button     
                      Center(                 
                      child: ElevatedButton(
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
                        child: Text('Add to Watchedlist'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 36),
                        ),
                      ),
                      ),
                    ]              
                    ),
                )        
                    ],
                  ),
                ),
              ],
            ),
          );
       
  }
}