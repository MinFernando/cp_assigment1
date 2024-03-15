import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';
import 'package:cp_assignment/screens/app_home_screen.dart'; 
import 'constructors.dart'; 

// Widget to display the best movies of the year
class BestMoviesThisYear extends StatelessWidget {
  final TmdbService tmdbService = TmdbService(); // Instance of TmdbService

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Color.fromARGB(255, 0, 0, 0), // Background color
      body: Stack( // Stack to stack multiple widgets
        children: [
          // Displaying the movie list
          Center(
            child: FutureBuilder( // FutureBuilder to handle asynchronous data fetching
              future: tmdbService.getPopularMoviesThisYear(), // Fetching movies
              builder: (context, snapshot) { // Builder function for FutureBuilder
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // shows loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Center( // shows error message if error occurs
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<Movie> movies = snapshot.data as List<Movie>; // Extracting list of movies from snapshot
                  return MovieThisYear(movies: movies); // Displaying movies
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display the movies of the year
class MovieThisYear extends StatefulWidget {
  final List<Movie> movies; // List of movies

  MovieThisYear({required this.movies}); // Constructor

  @override
  _MovieThisYearState createState() => _MovieThisYearState(); // Creating state for the widget
}

class _MovieThisYearState extends State<MovieThisYear> {
  bool sortByDate = false; // Flag to track sorting by date
  bool sortByTitle = false; // Flag to track sorting by title

  @override
  Widget build(BuildContext context) {
    List<Movie> displayedMovies = List.from(widget.movies); // Copying list of movies for display

    // Sorting logic
    if (sortByDate) { // Sort by date if enabled
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else if (sortByTitle) { // Sort by title if enabled
      displayedMovies.sort((a, b) => a.title.compareTo(b.title));
    }

    return Stack( // Stack for stacking ListView and bottom navigation bar
      children: [
        // ListView to display the movies
        ListView.builder( 
          itemCount: displayedMovies.length,
          itemBuilder: (context, index) {
            return GestureDetector( // GestureDetector for tapping on a movie to view details
              onTap: () {
                // Navigate to the content detail screen when a movie is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentDetailScreen(content: displayedMovies[index]),
                  ),
                );
              },
              child: Container( // Container to display each movie
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
                padding: EdgeInsets.all(12.0), 
                decoration: BoxDecoration( 
                  color: Color.fromARGB(255, 36, 36, 37), // Background color
                  borderRadius: BorderRadius.circular(8.0), 
                  boxShadow: [ // Box shadow for elevation
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row( // Row to display movie details
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie poster
                    Container(
                      width: 100.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(displayedMovies[index].imagePath), // Displaying movie poster
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high, // Image quality
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie title
                          Text(
                            displayedMovies[index].title,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(height: 8.0),
                          // Release date
                          Text(
                            displayedMovies[index].releaseDate,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          SizedBox(height: 8.0),
                          // Overview
                          Text(
                            displayedMovies[index].overview,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // trucates if overview overflows
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Bottom navigation bar for sorting and home button
        Positioned( // Positioned widget for placing the container at the bottom
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08, // Height of the bottom navigation bar
            color: Color.fromARGB(255, 0, 0, 0), // Background color
            child: Row( // Row for arranging icons horizontally
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Sort by date button
                IconButton(
                  icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 172, 172, 172)),
                  onPressed: () {
                    setState(() { // Updating state to sort by date
                      sortByDate = !sortByDate; // Toggle sort by date
                      sortByTitle = false; // Disable sort by title
                    });
                  },
                ),
                // Sort by title button
                IconButton(
                  icon: Icon(Icons.sort_by_alpha, color: const Color.fromARGB(255, 172, 172, 172)),
                  onPressed: () {
                    setState(() { // Updating state to sort by title
                      sortByTitle = !sortByTitle; // Toggle sort by title
                      sortByDate = false; // Disable sort by date
                    });
                  },
                ),
                // Home button to navigate back to the home screen
                IconButton(
                  icon: Icon(Icons.home, color: const Color.fromARGB(255, 172, 172, 172)),
                  onPressed: () {
                    Navigator.push( // Navigating back to the home screen
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppHomeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
