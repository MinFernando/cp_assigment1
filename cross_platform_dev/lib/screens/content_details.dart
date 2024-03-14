import 'dart:ui';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:cp_assignment/screens/watchedlist.dart';
import 'package:cp_assignment/screens/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Title
                      Text(
                        content.title,
                        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      // Release Date
                      Text(
                        'Release Date: ${content.releaseDate}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 10.0),
                      // Rating
                      Text(
                        'Rating: ${content.rating}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20.0),
                      // Overview
                      Text(
                        'Overview: ${content.overview}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20.0),
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
                        child: const Text('Add to Watchlist'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 36), 
                        ),
                      ),
                    ),

                      const SizedBox(height: 10.0), // Spacing between buttons

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
                        child: const Text('Add to Watchedlist'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 36),
                        ),
                      ),                      
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 254, 255, 255), 
                            disabledBackgroundColor: const Color.fromARGB(255, 34, 38, 81), 
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