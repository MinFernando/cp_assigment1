
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';
import 'constructors.dart';

class SearchResultsScreen extends StatefulWidget {
  // The name of the actor to search for.
  final String actorName;
  // Title for the screen, possibly indicating the search query.
  final String title;

  const SearchResultsScreen({Key? key, required this.actorName, required this.title}) : super(key: key);
  
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();   
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // Instance of TmdbService to make API calls.
  final TmdbService tmdbService = TmdbService();
  List<Content> _searchResults = []; 
  List<TVSeries> _tvSeriesList = []; 
  List<Movie> _moviesList= [];  

  // Flags for sorting options.
  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {    
     // List to hold movies for display, prioritizing search results over movie list if not empty.
    List<Content> displayedMovies = List.from(_searchResults.isNotEmpty ? _searchResults : _moviesList);

    // Sorting logic
    if (sortByDate) {
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate)); // sort by date
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title)); // sort by released date
    }
    
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
           Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
           ),
          Center(
            child: Column(
              children: [
                // Display Search Results
                if (_searchResults.isNotEmpty)
                  Expanded(
                    // ListView to dynamically build a list of search result items.
                    child: ListView.builder(
                      itemCount: displayedMovies.length, // length of the list
                      itemBuilder: (context, index) {
                        final content = displayedMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                               // Navigate to ContentDetailScreen upon tapping a result.
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentDetailScreen(content: content),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 36, 36, 37),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Display movie or series image if available.
                              children: [                                
                                if (content is Movie && content.imagePath != null && content.imagePath.isNotEmpty)
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w500' + content.imagePath,
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 150.0,
                                  ),
                                if (content is TVSeries && content.imagePath != null && content.imagePath.isNotEmpty)
                                  Image.network(
                                    'https://image.tmdb.org/t/p/w500' + content.imagePath,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    width: 100.0,
                                    height: 150.0,
                                  ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.title,
                                        style: TextStyle(fontSize: 20.0, color: const Color.fromARGB(255, 255, 255, 255)),
                                      ),
                                      Text(
                                        content.releaseDate,
                                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                      ),
                                      Text(
                                        content.overview,
                                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                        maxLines: 2,
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

                  )
                else
                  // Display a message when no results are found.
                  Text('No results'),
              ],
            ),
          ),            
      // Sorting buttons
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08, 
          color: Color.fromARGB(255, 0, 0, 0), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              IconButton(
                icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by date
                onPressed: () {
                  setState(() {
                    sortByDate = !sortByDate;
                    sortByTitle = false;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.sort_by_alpha, color: const Color.fromARGB(255, 172, 172, 172)), // Icon for sorting by title
                onPressed: () {
                  setState(() {
                    sortByTitle = !sortByTitle;
                    sortByDate = false;
                  });
                },
              ),
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
      ),
    );
  }
             
  @override
  void initState() {
    super.initState();
    // Fetch movies and TV series when the screen is initialized
    _searchForActorData();
    _searchForData();
  }

  // Fetches actor-related movies and TV series using TmdbService.
  Future<void> _searchForActorData() async {
    try {
      final movies = await tmdbService.getActorMovies(widget.actorName);
      final tvSeries = await tmdbService.getActorTvSeries(widget.actorName);
      setState(() {
        _moviesList = movies;
        _tvSeriesList = tvSeries;
        // Concatenate both movie and TV series lists into search results
        _searchResults.addAll(movies);
        _searchResults.addAll(tvSeries);
      });
    } catch (e) {
      // Handle the error
      print("Error: $e");
    }
  }
  // Performs a general search for data related to the actor.
  Future<void> _searchForData() async {
    try {
      final results = await tmdbService.searchMoviesAndSeries(widget.actorName);      
      setState(() {
        _searchResults = results.cast<Content>();
      });
    } catch (e) {
      // Handle the error
      print("Error: $e");
    }
  }
}
