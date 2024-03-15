
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';


// Display a list of movies, allowing sorting by year or alphabetically
class ActosMovies extends StatefulWidget { 
  final List<Movie> movies;
  
  ActosMovies({required this.movies});

  @override
  _ActosMoviesState createState() => _ActosMoviesState();
}

class _ActosMoviesState extends State<ActosMovies> {
  bool sortByYear = false; // Flag to toggle sorting method

  @override
  Widget build(BuildContext context) {
    List<Movie> sortedMovies = List.from(widget.movies);

    // Sorting logic
    if (!sortByYear) {
      sortedMovies.sort((a, b) => a.title.compareTo(b.title)); // alphabtical sorting
    } else {
      sortedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate)); // sorting by date
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text('Movies List'),
      ),
      body: Column(
        children: [
          // Row for sorting buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Button to sort by year
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sortByYear = true;
                  });
                },
                child: Text('Sort by Year'),
              ),
              SizedBox(width: 10),
               // Button to sort by date
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sortByYear = false;
                  });
                },
                child: Text('Sort Alphabetically'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedMovies.length,
              itemBuilder: (context, index) {
                return GestureDetector(   // detects taps on movie items
                  onTap: () {
                    Navigator.push(  //navigates to content list
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(content: sortedMovies[index]),
                      ),
                    );
                  },
                  // Styling the movie list item
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // Movie poster
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500' + sortedMovies[index].imagePath,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          width: 100.0,
                          height: 150.0,
                        ),
                        SizedBox(width: 12.0),
                         // Movie title, release date, and overview
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sortedMovies[index].title,
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                sortedMovies[index].releaseDate,
                                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                sortedMovies[index].overview,
                                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis, // Truncates long overviews
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
          ),
        ],
      ),
    );
  }
}