import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign in and login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Welcome to MovieMate!'),
        '/second': (context) => AppHomeScreen(),
        '/third': (context) => CinemaListScreen(),
        '/fourth': (context) => TvListScreen(),
        '/fifth': (context) => MyWatchlistScreen(),
        '/sixth': (context) => VisitProfileScreen(),
        '/seventh': (context) => BestMoviesThisYear(),
        '/eighth': (context) => BestMoviesAllTime(),
        '/ninth': (context) => MyWatchedlistScreen(),
        '/tenth': (context) => EditProfileScreen(),
        '/eleventh': (context) => ChangePassword(),
        '.twelveth': (context) => ChangeUsernameScreen(),
        'thirteth': (context) => ChangeEmailScreen(),
        'fouteenth': (context) => ForgotPassword(),
        'fifteenth': (context) => SearchResultsScreen(actorName: '', title: '',)
      },
    );
  }
}

class TmdbService {
  static String apiKey = '99df30052fbbba30be71c4f7eb9064a1';
  static String url = 'https://api.themoviedb.org/3';
  final String imageUrl = 'https://image.tmdb.org/t/p/w500';


  Future<List<Movie>> getPopularMovies2023() async {
    final response = await http.get(Uri.parse('$url/discover/movie?api_key=$apiKey&primary_release_year=2023&sort_by=popularity.desc'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];      

      List<Movie> movies = data.map((json) {
        return Movie(          
          title: json['title'] ?? 'Unknown Title',
          releaseDate: json['release_date']?? 'Unknown Release Date',        
          imagePath: '$imageUrl${json['poster_path']}',          
           rating: json['vote_average'].toString(),
           overview: json['overview'] ?? 'Not Available',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load popular movies for this year');
    }
  }

  Future<List<Movie>> getPopularMoviesOfAllTime() async {
    final response = await http.get(Uri.parse('$url/movie/top_rated?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((json) {
        return Movie(          
          title: json['title'] ?? 'Unknown Title',
          releaseDate: json['release_date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
          overview: json['overview'] ?? 'Not Available',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load popular movies of all time');
    }
  }

   Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$url/movie/now_playing?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((json) {
        return Movie(          
         title: json['title'] ?? 'Unknown Title',
         releaseDate: json['release_date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
          overview: json['overview'] ?? 'Not Available',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load the current cinema listing');
    }
  }
  
  Future<List<TVSeries>> getTVShowsAiringTonight(String countryCode) async {
  final DateTime now = DateTime.now();
  final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.get(Uri.parse('$url/tv/airing_today?api_key=$apiKey&air_date=$formattedDate&region=$countryCode'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];

    List<TVSeries> series = data.map((json) {      
      String title = json['original_name'] ?? 'Unknown Title';      
      String releaseDate = json['first_air_date'] ?? 'Unknown Release Date';
      String imagePath = json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'No Image';
      String rating = json['vote_average']?.toString() ?? '0.0';
      String overview = json['overview'] ?? 'Not Available';

      return TVSeries(        
        title: title,        
        releaseDate: releaseDate,
        imagePath: imagePath,
        rating: rating,
        overview: overview,
      );
    }).toList();

    return series;
  } else {
    throw Exception('Failed to load TV shows airing tonight');
  }
}

Future<List<Movie>> getActorMovies(String actorName) async {
  try {
    // Step 1: Search for the actor
    var actorSearchRes = await http.get(Uri.parse(TmdbService.url + '/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}'));
 
    if (actorSearchRes.statusCode == 200) {
      var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
      if (actorData.isNotEmpty) {
        var actorId = actorData[0]['id'];

        if (actorId != null) {
          // Step 2: Get movies by actor ID
          var moviesRes = await http.get(Uri.parse(
              TmdbService.url + '/person/$actorId/movie_credits?api_key=${TmdbService.apiKey}'));

          if (moviesRes.statusCode == 200) {
            return (jsonDecode(moviesRes.body)['cast'] as List)
                .map((json) => Movie.fromJson(json))
                .toList();
          } else {
            throw Exception("Failed to get actor's movies");
          }
        } else {
          throw Exception("Actor ID is null");
        }
      } else {
        throw Exception("Movie not found");
      }
    } else {
      throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

Future<List<TVSeries>> getActorTvSeries(String actorName) async {
  try {
    // Step 1: Search for the actor
    var actorSearchRes = await http.get(Uri.parse(TmdbService.url + '/search/person?query=$actorName&page=1&api_key=${TmdbService.apiKey}'));

    if (actorSearchRes.statusCode == 200) {
      var actorData = jsonDecode(actorSearchRes.body)['results'] as List;
      if (actorData.isNotEmpty) {
        var actorId = actorData[0]['id'];

        if (actorId != null) {
          // Step 2: Get TV series by actor ID
          var tvSeriesRes = await http.get(Uri.parse(
              TmdbService.url + '/person/$actorId/tv_credits?api_key=${TmdbService.apiKey}'));

          if (tvSeriesRes.statusCode == 200) {
            var tvSeriesData = jsonDecode(tvSeriesRes.body)['cast'] as List;          

            return tvSeriesData.map((json) => TVSeries.fromJson(json)).toList();
          } else {
            throw Exception("Failed to get actor's TV series");
          }
        } else {
          throw Exception("Actor ID is null");
        }
      } else {
        throw Exception("Series not found");
      }
    } else {
      throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

Future<List<Content>> searchMoviesAndSeries(String searchTerm) async {
  try {
    // Search for both movies and TV series by name using the 'multi' endpoint
    var searchRes = await http.get(Uri.parse(
        '$url/search/multi?query=${Uri.encodeComponent(searchTerm)}&page=1&api_key=$apiKey'));

    if (searchRes.statusCode == 200) {
      var searchData = jsonDecode(searchRes.body)['results'] as List;

      return searchData
          .map((json) => Content.fromJson(json))
          .where((content) => content.title != null && content.title.isNotEmpty)
          .toList();
    } else {
      throw Exception("Failed to search for movies and TV series. Status code: ${searchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

}

class Content {
  final String title;
  final String releaseDate;
  final String imagePath;
  final String rating;
  final String overview;

  Content({
    required this.title,
    required this.releaseDate,
    required this.imagePath,
    required this.rating,
    required this.overview,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    // Check if the entry is a TV series
    if (json['original_name'] != null) {
      return TVSeries.fromJson(json);
    } else {
      // Assume it's a movie
      return Movie.fromJson(json);
    }
  }
}

class Movie extends Content {
  Movie({
    required String title,
    required String releaseDate,
    required String imagePath,
    required String rating,
    required String overview,
  }) : super(
          title: title,
          releaseDate: releaseDate,
          imagePath: imagePath,
          rating: rating,
          overview: overview,
        );

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'Unknown Title',
      releaseDate: json['release_date'] ?? 'Unknown Release Date',
      imagePath: json['poster_path'] ?? '',
      rating: json['vote_average']?.toString() ?? '0.0',
      overview: json['overview'] ?? 'Not Available',
    );
  }
}

class TVSeries extends Content {
  TVSeries({
    required String title,
    required String releaseDate,
    required String imagePath,
    required String rating,
    required String overview,
  }) : super
      (
        title: title,
        releaseDate: releaseDate,
        imagePath: imagePath,
        rating: rating,
        overview: overview,
      );

  factory TVSeries.fromJson(Map<String, dynamic> json) {
    return TVSeries(
      title: json['original_name'] ?? 'Unknown Title',
      releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
      imagePath: json['poster_path'] ?? 'No Image Available',
      rating: json['vote_average']?.toString() ?? '0.0',
      overview: json['overview'] ?? 'Not Available',
    );
  }
}
  
class CinemaListScreen extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [
          // Background Image
          Container(
            color: backgroundColor,
          ),
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getNowPlayingMovies(),
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
                  return MovieListCinema(movies: movies);
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}

class MovieListCinema extends StatefulWidget {
  final List<Movie> movies;

  MovieListCinema({required this.movies});

  @override
  _MovieListCinemaState createState() => _MovieListCinemaState();
}

class _MovieListCinemaState extends State<MovieListCinema> {
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            color: Color.fromARGB(255, 0, 0, 0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
      ],
    );
  }
}

class TvListScreen extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();
  String userCountryCode = 'US';

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [
          // Background Image
          Container(
            color: backgroundColor,
          ),
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getTVShowsAiringTonight('US'),
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
                  List<TVSeries> series = snapshot.data as List<TVSeries>;
                  return ListSeries(series: series);
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}

class ListSeries extends StatefulWidget {
  final List<TVSeries> series;

  ListSeries({required this.series});

  @override
  _ListSeriesState createState() => _ListSeriesState();
}

class _ListSeriesState extends State<ListSeries> {
  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {
    List<TVSeries> displayedSeries = List.from(widget.series);

    // Sorting logic
    if (sortByDate) {
      displayedSeries.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else if (sortByTitle) {
      displayedSeries.sort((a, b) => a.title.compareTo(b.title));
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: displayedSeries.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContentDetailScreen(content: displayedSeries[index]),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TV Series Image
                    Container(
                      width: 100.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(displayedSeries[index].imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    // TV Series Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            displayedSeries[index].title,
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          // Release Date
                          Text(
                            displayedSeries[index].releaseDate,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          SizedBox(height: 8.0),
                          // Overview
                          Text(
                            displayedSeries[index].overview,
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
        // Back Button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            color: Color.fromARGB(255, 0, 0, 0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
      ],
    );
  }
}

class MovieProvider with ChangeNotifier {
  List<Content> _watchlist = [];
  List<Content> _watchedlist = [];

  List<Content> get watchlist => _watchlist;
  List<Content> get watchedlist => _watchedlist;
  
    void addToWatchlist(Content content) {
      if (_watchlist.contains(content)) {
        _watchlist.remove(content);
      } else {
        _watchlist.add(content);
      }
      notifyListeners();
  }

  // checks if a movie is in the watchlist
  bool isInWatchlist(Content content) {
    return _watchlist.contains(content);
  }  

  void addToWatchedlist(Content content) {
      if (_watchedlist.contains(content)) {
        _watchedlist.remove(content);
      } else {
        _watchedlist.add(content);
      }
      notifyListeners();
  }

  // checks if a movie is in the watchedlist
  bool isInWatchedlist(Content content) {
    return _watchedlist.contains(content);
  }  
}

class MyWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Content> watchlist = movieProvider.watchlist;

    Color color1 = Color.fromARGB(255, 27, 188, 182);
    Color color2 = Colors.black;

    return Scaffold(      
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.5,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'MyWatchlist',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        // Display Watchlist Movies
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: watchlist.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  watchlist[index].title,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(
                                      'Rating: ${watchlist[index].rating}',
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Image.network(
                                      watchlist[index].imagePath,
                                      fit: BoxFit.cover,
                                      width: 100.0,
                                      height: 100.0,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigate to WatchedlistScreen Button
          Positioned(
            top: 650.0,
            right: 10.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyWatchedlistScreen(),
                  ),
                );
              },
              child: const Text('Go to Watched list'),              
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: ElevatedButton.icon(
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
          ),
        ],
      ),
    );
  }
}

class MyWatchedlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Content> watchedlist = movieProvider.watchedlist;

    Color color1 = Color.fromARGB(255, 27, 188, 182);
    Color color2 = Colors.black;

    return Scaffold(      
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1.5,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'MyWatchedlist',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        // Display Watchlist Movies
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: watchedlist.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  watchedlist[index].title,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                subtitle: Column(
                                  children: [
                                    Text(
                                      'Rating: ${watchedlist[index].rating}',
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Image.network(
                                      watchedlist[index].imagePath,
                                      fit: BoxFit.cover,
                                      width: 100.0,
                                      height: 100.0,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigate to WatchlistScreen Button
          Positioned(
            top: 700.0,
            right: 10.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyWatchlistScreen(),
                  ),
                );
              },
              child: const Text('Go to Watchlist'),
            ),
          ),                      
        ],
      ),
    );
  }
}

class VisitProfileScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    double buttonWidth = 300.0; 
    double buttonHeight = 50.0; 

    return Scaffold(        
        body: SingleChildScrollView(
          child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[             
                 Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp6.jpg'),
                        fit: BoxFit.cover,
                      ),                    
                    ),                      
                       child: Align(
                        alignment: Alignment.topLeft,                              
                        child: ElevatedButton.icon(
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
                        ),      
                       ),   
                Container(
                    width: MediaQuery.of(context).size.width * 1.5,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 100.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,                                
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Edit profile',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangePassword(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Change password',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),
                            const SizedBox(height: 90.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: 200,
                                height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                            title: 'Welcome to MovieMate!'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),                                                                              
                            ]
                          ),
                        )
                      )
                    ]
                  ),
                )
              )
            );
          }
        }

class EditProfileScreen extends StatelessWidget {

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 300.0; 
    double buttonHeight = 50.0; 

    return Scaffold(        
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                   height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp6.jpg'),
                        fit: BoxFit.cover,
                      ),                    
                    ), 
                    child: Align(
                        alignment: Alignment.topLeft,                              
                        child: ElevatedButton.icon(
                          onPressed: () {                   
                            Navigator.push(
                              context,
                                MaterialPageRoute(
                                builder: (context) => VisitProfileScreen(),
                              ),
                            );                                
                          },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Back'),
                          ),
                        ),    
              ),
                Container(
                    width: MediaQuery.of(context).size.width * 5.0,
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 100.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeUsernameScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Change username',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),
                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: buttonWidth,
                                height: buttonHeight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeEmailScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                                  child: Text(
                                    'Change Email',
                                    style: TextStyle(fontSize: 16),
                                  )),)
                            ),                                                   
                          ]
                        ),
                      )
                    )
                   ]
                  ),
                )
              )
             );
           }
          }

class ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Change email address',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (Email) {
                  if (Email != null && Email.isNotEmpty) {
                    return null;
                  } else
                    return 'Please enter a valid Email address';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new Email address',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Email address changed'),
                        content: const Text(
                            'Your Email address has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Enter'),
              ),
              const SizedBox(height: 550.0),
              Align(
                alignment: Alignment.topRight,                                                    
                child: ElevatedButton.icon(
                  onPressed: () {                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );                                
                  },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back'),
                  ),
                ),     
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeUsernameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Change Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (username) {
                  if (username != null && username.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please enter a valid username';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Username Changed'),
                        content: const Text(
                            'Your username has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                ),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Enter'),
              ),
              const SizedBox(height: 550.0),
              Align(
                alignment: Alignment.topRight,                              
                child: ElevatedButton.icon(
                  onPressed: () {                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );                                
                  },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back'),
                  ),
                ), 
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (password) {
                  if (password != null && password.isNotEmpty) {
                    return null;
                  } else
                    return 'Please enter a valid password';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Password changed'),
                        content: const Text(
                            'Your password has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VisitProfileScreen(),
                                ),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Enter'),
              ),                            
              const SizedBox(height: 550.0),
              Align(
                alignment: Alignment.topRight,                                                   
                child: ElevatedButton.icon(
                  onPressed: () {                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitProfileScreen(),
                      ),
                    );                                
                  },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back'),
                  ),
                ), 
            ],
          ),
        ),
      ),
    );
  }
}


class MovieListYear extends StatefulWidget {
  final List<Movie> movies;

  MovieListYear({required this.movies});

  @override
  _MovieListAllTimeState createState() => _MovieListAllTimeState();
}

class _MovieListAllTimeState extends State<MovieListYear> {
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
            height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            color: Color.fromARGB(255, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), 
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BestMoviesThisYear(),
                      ),
                    );
                  },
                  child: Text('This year'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BestMoviesThisYear extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [
          // Background Image
          Container(
            color: backgroundColor,
          ),
          // Movie List
          Center(
            child: FutureBuilder(
              future: tmdbService.getPopularMovies2023(),
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
                  return MovieList(movies: movies);
                }
              },
            ),
          ),
        ],
      ),      
    );
  }
}


class MovieList extends StatefulWidget {
  final List<Movie> movies;

  MovieList({required this.movies});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
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
            color: Color.fromARGB(255, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), 
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
                        builder: (context) => BestMoviesAllTime(),
                      ),
                    );
                  },
                  child: Text('of all time'),
                ),
        )
      ],
    );
  }
}

class BestMoviesAllTime extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [
          // Background Image
          Container(
           color: backgroundColor,
          ),
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
                  return MovieList(movies: movies);
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}


class ContentDetailScreen extends StatelessWidget {
  final Content content;

  ContentDetailScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          // Image
          Image.network(
            'https://image.tmdb.org/t/p/w500' + content.imagePath,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1.0, 
          ),        
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Text(
                    content.title,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  // Release Date
                  Text(
                    'Release Date: ${content.releaseDate}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),               
                  // Rating
                  Text(
                    'Rating: ${content.rating}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                   // Overview
                  Text(
                    'Overview: ${content.overview}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                    SizedBox(height: 20.0),
                  // Add to Watchlist Button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Add to Watchlist Button
                            ElevatedButton(                              
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
                              child: Text('Add to Watchlist'),
                            ),
                            SizedBox(width: 10.0),
                            // Add to MyWatchedlist Button
                            ElevatedButton(                              
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
                              child: Text('Add to MyWatchedlist'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Back Button
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(                    
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Back'),
                    ),
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

  Color color1 = Color.fromARGB(255, 48, 8, 8);
  Color color2 = Color.fromARGB(255, 0, 0, 0); 

  bool sortByDate = false;
  bool sortByTitle = false;

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                // Display Search Results
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final content = _searchResults[index];
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
                              color: Colors.white,
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
              color: Colors.black,
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

class AppHomeScreen extends StatelessWidget {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  Color backgroundColor = Color.fromARGB(255, 48, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp2.jpg'),
                        fit: BoxFit.cover,
                      ),                    
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,                    
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _searchController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a search term';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Actors, movies series...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (formGlobalKey.currentState!.validate()) {
                                  String searchTerm =
                                      _searchController.text.trim();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchResultsScreen(
                                        actorName: searchTerm,
                                        title: searchTerm,
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.search, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: Center(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60.0),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CinemaListScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Whats On Cinema?',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp3.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvListScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Whats on TV Tonight?',
                              style: TextStyle(fontSize: 16),
                            ),                                                        
                          ],
                        ),
                        imagePath: 'web/assets/cp4.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyWatchlistScreen(),
                            ),
                          );
                        },
                         label: const Row(
                          children: [
                            Text(
                              'My Watchlist',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp5.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisitProfileScreen(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Visit Profile',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp6.jpg',
                      ),
                      const SizedBox(height: 10),
                      buildStyledButtonWithImage(
                        context: context, 
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BestMoviesThisYear(),
                            ),
                          );
                        },
                        label: const Row(
                          children: [
                            Text(
                              'Best Rated Movies',
                              style: TextStyle(fontSize: 16),
                            ),                                                       
                          ],
                        ),
                        imagePath: 'web/assets/cp7.jpg',                        
                      ),      
                      const SizedBox(height: 90.0),                                    
                    ],
                  ),
                ),
              ),              
            ),
          ],
        ),
      ),
    );
  }
   
  Widget buildStyledButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget label,
  }) {
    double containerWidth = MediaQuery.of(context).size.width * 0.3; // sets percentage for size so its responsive in different platforms
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 175, 47, 47), 
        padding: EdgeInsets.symmetric(horizontal: containerWidth * 0.2, vertical: containerWidth * 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white, // Set text color to white
        ),
      child: label,
      )
    );
  }

 Widget buildStyledButtonWithImage({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget label,
  required String imagePath,
}) {
  double containerWidth = MediaQuery.of(context).size.width * 0.8; // sets percentage for size so its responsive in different platforms
  double imageWidth = containerWidth * 0.2;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      width: containerWidth, 
      padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
        color: Color.fromARGB(255, 175, 47, 47),  
        borderRadius: BorderRadius.circular(10),
          ),
      child: Row(                      
        children: [
          Image.asset(imagePath, width: imageWidth),
          Flexible(
            child: buildStyledButton(
              context: context,
              onPressed: onPressed,
              label: label,
            ),
          ),
        ]          
      ),
    ),    
  );
}
}

class MoviesActorList extends StatefulWidget {
  final List<Movie> movies;

  MoviesActorList({required this.movies});

  @override
  _MoviesActorListState createState() => _MoviesActorListState();
}

class _MoviesActorListState extends State<MoviesActorList> {
  bool sortByYear = false;

  @override
  Widget build(BuildContext context) {
    List<Movie> sortedMovies = List.from(widget.movies);

    // Sorting logic
    if (!sortByYear) {
      sortedMovies.sort((a, b) => a.title.compareTo(b.title));
    } else {
      sortedMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies List'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sortByYear = true;
                  });
                },
                child: Text('Sort by Year'),
              ),
              SizedBox(width: 10),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(content: sortedMovies[index]),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500' + sortedMovies[index].imagePath,
                          fit: BoxFit.cover,
                          width: 100.0,
                          height: 150.0,
                        ),
                        SizedBox(width: 12.0),
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
          ),
        ],
      ),
    );
  }
}



class MyHomePage extends StatelessWidget with ValidationMixin {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Dismiss the keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.height * 2.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('web/assets/cp1.jpg'), 
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: formGlobalKey,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      TextFormField(
                        validator: (email){
                          /*if (EmailValidator.validate(email!)) return null;
                          else
                            return 'Email address invalid';*/
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      TextFormField(
                        validator: (password){
                          /* if (isPasswordValid(password!)) return null;
                            else
                              return 'Invalid Password.';*/
                        },
                        maxLength: 6,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (formGlobalKey.currentState!.validate()) {
                                  formGlobalKey.currentState!.save();
                                  Navigator.pushNamed(context, '/second');
                                }
                              },
                              child: const Text('Login'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: const Text('Forgot Password?'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateAccountScreen(),
                                  ),
                                );
                              },
                              child: const Text('New User? Create account'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget with ValidationMixin {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              // Username
              const Text(
                'Username',
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
              TextFormField(
                validator: (email) {
                  if (EmailValidator.validate(email!))
                    return null;
                  else
                    return 'Email address invalid';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0),
              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 25.0, color: Colors.black),
              ),
              TextFormField(
                validator: (password) {
                  if (isPasswordValid(password!))
                    return null;
                  else
                    return 'Invalid Password.';
                },
                maxLength: 10,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    // Show a popup alert
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('New password created'),
                          content: const Text(
                              'Your password has been successfully updated!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(title: 'Welcome to MovieMate!'),
                              ),
                            );
                          },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// create account screen
class CreateAccountScreen extends StatelessWidget with ValidationMixin {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(      
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              // Username
              const Text(
                'Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (email) {
                  if (EmailValidator.validate(email!))
                    return null;
                  else
                    return 'Email address invalid';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0),
              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (password) {
                  if (isPasswordValid(password!))
                    return null;
                  else
                    return 'Invalid Password.';
                },
                maxLength: 6,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16.0),

              // Create Account Button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    // Show a popup alert
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Account Created'),
                          content: const Text(
                              'Your account has been successfully created!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(title: 'Welcome to MovieMate!'),
                              ),
                            );
                          },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin ValidationMixin {
  bool isPasswordValid(String inputpassword) => inputpassword.length == 10;
}