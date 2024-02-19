import 'package:flutter/material.dart';
import 'BestMovieThisYear.dart';
import 'ContentDetailsScreen.dart';
import 'ContentInitalizing.dart';
import 'constructors.dart';

class BestMovieAllTime extends StatelessWidget {  
  final TmdbService tmdbService = TmdbService();  
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(      
      body: Stack(
        children: [         
          // Movie List
          Center(
            child: FutureBuilder(              
              future: tmdbService.getHighestGrossingOfAllTime(),
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
                  return BestMoviesAllTime(movies: movies);
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
  final List<Movie> movies;
  
  BestMoviesAllTime({required this.movies});

  @override
  _BestMovieAllTimeState createState() => _BestMovieAllTimeState();
}

class _BestMovieAllTimeState extends State<BestMoviesAllTime> {
  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {    
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
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title));
    }

    return Material(
      child: Stack(
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
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    displayedMovies[index].title,
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayedMovies[index].releaseDate,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        displayedMovies[index].overview,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  leading: Image.network(
                    displayedMovies[index].imagePath,
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
            );
          },
        ),
         Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            color: Color.fromARGB(255, 255, 255, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), 
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
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), 
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
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                              ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BestMoviesThisYear(),
                      ),
                    );
                  },                  
                  child: Text('Yearly'),
                ),                
              ],
            ),
          ),
        ),        
      ],
      ),
    );
  }
}
