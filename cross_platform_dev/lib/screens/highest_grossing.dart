
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';
import 'constructors.dart';

class BestMovieAllTime extends StatelessWidget {
  // Instance of TmdbService to handle API calls to TMDB for fetching movie data.
  final TmdbService tmdbService = TmdbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getHighestGrossingOfAllTime(), // fetches movies
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // show loading indicator
                } else if (snapshot.hasError) {
                  return Center(
                    // Show an error message if there's an error fetching the data.
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<Movie> movies = snapshot.data as List<Movie>;
                  return BestMoviesAllTime(movies: movies); // displays list
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BestMoviesAllTime extends StatefulWidget {
  // List of Movie objects to be displayed.
  final List<Movie> movies;

  BestMoviesAllTime({required this.movies});

  @override
  _BestMovieAllTimeState createState() => _BestMovieAllTimeState();
}

class _BestMovieAllTimeState extends State<BestMoviesAllTime> {
  // Flags for sorting the list of movies.
  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {
     // Create a copy of movies to sort for display.
    List<Movie> displayedMovies = List.from(widget.movies);

    // Check if displayedMovies is empty
    if (displayedMovies.isEmpty) {
      return const Center(
        child: Text(
          'No movies available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Sorting logic
    if (sortByDate) {
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate)); // sort by date
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title)); // sort by title alphabatically
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
           // ListView.builder to dynamically create a list of movie widgets.
          ListView.builder(
          itemCount: displayedMovies.length, // Number of movies in the list.
          itemBuilder: (context, index) {
            return GestureDetector( // GestureDetector to handle taps on each movie item.
              onTap: () {
                // Navigate to the content detail screen when a movie is tapped.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentDetailScreen(content: displayedMovies[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 36, 36, 37), 
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      // Shadow effect for each movie item.
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                // Row widget to layout movie image and details horizontally.
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(displayedMovies[index].imagePath), // Movie image from the network.
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                     // Expanded widget to fill the available space with movie details.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text(
                            displayedMovies[index].title,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(height: 8.0),
                          // release date
                          Text(
                            displayedMovies[index].releaseDate,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          SizedBox(height: 8.0),
                          //overview
                          Text(
                            displayedMovies[index].overview,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, // truncates overview if overflowed
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
        // Positioned widget for bottom navigation icons for sorting and home navigation.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08, 
            color: Color.fromARGB(255, 0, 0, 0),
            // Row for layout of the icons.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                // Icon button for sorting by date.
                IconButton(
                  icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by date
                  onPressed: () {
                    setState(() {
                      sortByDate = !sortByDate;
                      sortByTitle = false;
                    });
                  },
                ),
                // Icon button for sorting by title.
                IconButton(
                  icon: Icon(Icons.sort_by_alpha, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by title
                  onPressed: () {
                    setState(() {
                      sortByTitle = !sortByTitle;
                      sortByDate = false;
                    });
                  },
                ),
                // Icon button for navigating back home
                IconButton(
                  icon: Icon(Icons.home, color: const Color.fromARGB(255, 172, 172, 172)), 
                  onPressed: () {
                    Navigator.push(
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
      )
    );
  }
}
