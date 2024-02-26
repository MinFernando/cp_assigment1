import 'package:flutter/material.dart';
import 'AppHomeScreen.dart';
import 'ContentDetailsScreen.dart';
import 'ContentInitalizing.dart';
import 'constructors.dart';

class BestMoviesThisYear extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [          
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getPopularMovies2024(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<Movie> movies = snapshot.data as List<Movie>;
                  return MovieThisYear(movies: movies);
                }
              },
            ),
          ),
        ],
      ),      
    );
  }
}

class MovieThisYear extends StatefulWidget {
  final List<Movie> movies;

  MovieThisYear({required this.movies});

  @override
  _MovieThisYearState createState() => _MovieThisYearState();
}

class _MovieThisYearState extends State<MovieThisYear> {
  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {
    List<Movie> displayedMovies = List.from(widget.movies);

    // Sorting logic
    if (sortByDate) {
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title));
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
                    builder: (context) => ContentDetailScreen(content: displayedMovies[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Updated background color
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
                          image: NetworkImage(displayedMovies[index].imagePath),
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
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                            overflow: TextOverflow.ellipsis,
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
        // Navigate to best movies of the year screen
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), 
                  ),
                  onPressed: () {
                    // Toggle sorting by date
                    setState(() {
                      sortByDate = !sortByDate;
                      sortByTitle = false;
                    });
                  },
                  child: Text('Sort by Date'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                    textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () {
                    // Toggle sorting by title
                    setState(() {
                      sortByTitle = !sortByTitle;
                      sortByDate = false;
                    });
                  },
                  child: Text('Sort by Title'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                    textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), 
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppHomeScreen(),
                      ),
                    );
                  },
                  child: Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
