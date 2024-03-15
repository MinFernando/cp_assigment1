import 'package:flutter/material.dart';
import 'package:cp_assignment/screens/app_home_screen.dart'; 
import 'package:cp_assignment/screens/content_details.dart'; 
import 'package:cp_assignment/screens/content_initializing.dart'; 
import 'constructors.dart'; 

// Widget to display the list of movies in cinema
class CinemaListScreen extends StatelessWidget {
  final TmdbService tmdbService = TmdbService(); // Instance of TmdbService for fetching movie data

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Color.fromARGB(255, 0, 0, 0), 
      body: Stack(
        children: [
          // Movie List
          Center(
            child: FutureBuilder( // FutureBuilder to handle asynchronous data fetching
              future: tmdbService.getNowPlayingMovies(), // Fetching movies
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Displaying loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}', // Displaying error if data fetching fails
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<Movie> movies = snapshot.data as List<Movie>; // Extracting movie data from snapshot
                  return MovieListCinema(movies: movies); // Returning the widget to display movie list
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display the list of movies in cinema
class MovieListCinema extends StatefulWidget {
  final List<Movie> movies; // List of movies to display

  MovieListCinema({required this.movies});

  @override
  _MovieListCinemaState createState() => _MovieListCinemaState();
}

class _MovieListCinemaState extends State<MovieListCinema> {
  bool sortByDate = false; // Flag for sorting by date
  bool sortByTitle = false; // Flag for sorting by title

  @override
  Widget build(BuildContext context) {
    List<Movie> displayedMovies = List.from(widget.movies); // Copying movie list for sorting

    // Sorting logic
    if (sortByDate) {
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate)); // Sorting movies by release date
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title)); // Sorting movies by title
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: displayedMovies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentDetailScreen(content: displayedMovies[index]), // Navigating to content detail screen when a movie is tapped
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 37), // Background color for movie container
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Image
                    Container(
                      width: 100.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(displayedMovies[index].imagePath), // Displaying movie poster
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    // Movie Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            displayedMovies[index].title,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(height: 8.0),
                          // Release Date
                          Text(
                            displayedMovies[index].releaseDate,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          SizedBox(height: 8.0),
                          // Overview
                          Text(
                            displayedMovies[index].overview,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            maxLines: 2, // Limiting to 2 lines for overview
                            overflow: TextOverflow.ellipsis, // Truncate overflowed text
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08, // Setting height of bottom navigation bar
            color: Color.fromARGB(255, 0, 0, 0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributing buttons evenly
              children: [
                IconButton(
                  icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by date
                  onPressed: () {
                    setState(() {
                      sortByDate = !sortByDate; // Toggle sorting by date
                      sortByTitle = false; // Reset sorting by title
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.sort_by_alpha, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by title
                  onPressed: () {
                    setState(() {
                      sortByTitle = !sortByTitle; // Toggle sorting by title
                      sortByDate = false; // Reset sorting by date
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.home, color: Color.fromARGB(255, 172, 172, 172)), // Icon for home button
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppHomeScreen(), // Navigating to home screen
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
