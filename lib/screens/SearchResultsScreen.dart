import 'package:flutter/material.dart';
import 'AppHomeScreen.dart';
import 'ContentDetailsScreen.dart';
import 'ContentInitalizing.dart';
import 'constructors.dart';

class SearchResultsScreen extends StatefulWidget {
  final String actorName;
  final String title;

  const SearchResultsScreen({Key? key, required this.actorName, required this.title}) : super(key: key);
  
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();   
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TmdbService tmdbService = TmdbService();
  List<Content> _searchResults = []; 
  List<TVSeries> _tvSeriesList = []; 
  List<Movie> _moviesList= [];  

  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {
    // Apply sorting logic to the displayed movies list
    List<Content> displayedMovies = List.from(_searchResults.isNotEmpty ? _searchResults : _moviesList);

    // Sorting logic
    if (sortByDate) {
      displayedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else if (sortByTitle) {
      displayedMovies.sort((a, b) => a.title.compareTo(b.title));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
           Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8.0),
                ),
           ),
          Center(
            child: Column(
              children: [
                // Display Search Results
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayedMovies.length,
                      itemBuilder: (context, index) {
                        final content = displayedMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
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
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        style: TextStyle(fontSize: 20.0, color: Colors.grey),
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
              height: 50, 
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sortByDate = true;
                        sortByTitle = false;
                      });
                    },
                    child: Text('Sort by Date'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        sortByDate = false;
                        sortByTitle = true;
                      });
                    },
                    child: Text('Sort by Title'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppHomeScreen(),
                      ),
                    );
                    },
                    child: Text('back'),
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
  Future<void> _searchForData() async {
    try {
      final results = await tmdbService.searchMoviesAndSeries(widget.actorName);      
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle the error
      print("Error: $e");
    }
  }
}
