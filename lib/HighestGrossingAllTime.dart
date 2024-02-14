import 'package:cp_assignment/main.dart';
import 'package:flutter/material.dart';

import 'screens/AppHomeScreen.dart';
import 'screens/BestMovieThisYear.dart';
import 'screens/ContentDetailsScreen.dart';
import 'screens/ContentInitalizing.dart';
import 'screens/constructors.dart';

class BestMoviesAllTime extends StatelessWidget {  
  final TmdbService tmdbService = TmdbService();  
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold(      
      body: Stack(
        children: [         
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getPopularMoviesOfAllTime(),
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
                  return BestMoviesAllTime();
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}

class BestMovieAllTime extends StatefulWidget {
  final List<Movie> movies;

  BestMovieAllTime({required this.movies});

  @override
  _BestMovieAllTimeState createState() => _BestMovieAllTimeState();
}

class _BestMovieAllTimeState extends State<BestMovieAllTime> {
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                              ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppHomeScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'),
                ),                
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child:
          ElevatedButton(            
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BestMoviesThisYear(),
                      ),
                    );
                  },
                  child: Text('The Year'),
                ),
        )
      ],
    );
  }
}
