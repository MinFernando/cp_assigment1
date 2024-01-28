import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



//https://github.com/Ansh-Rathod/Flutter-Bloc-MovieDB-App/blob/master/lib/models/movie_model.dart


void main() {
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
        'fifteenth': (context) => SearchResultsScreen(actorName: '',)
      },
    );
  }
}

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
      ),
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
                        title: const Text('password changed'),
                        content: const Text(
                            'Your password has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
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
            ],
          ),
        ),
      ),
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
          title: json['title'] ?? json['original_name'] ?? 'Unknown Title',
          releaseDate: json['first_air_date'] ?? json['released date']?? 'Unknown Release Date',        
          imagePath: '$imageUrl${json['poster_path']}',          
           rating: json['vote_average'].toString(),
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
          title: json['title'] ?? json['original_name'] ?? 'Unknown Title',
          releaseDate: json['first_air_date'] ?? json['released date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
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
         title: json['title'] ?? json['original_name'] ?? 'Unknown Title',
         releaseDate: json['first_air_date'] ?? json['released date']?? 'Unknown Release Date',
          imagePath: '$imageUrl${json['poster_path']}',          
          rating: json['vote_average'].toString(),
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Failed to load the current cinema listing');
    }
  }
  
  Future<List<Movie>> getTVShowsAiringTonight(String countryCode) async {
  final DateTime now = DateTime.now();
  final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final response = await http.get(Uri.parse('$url/tv/airing_today?api_key=$apiKey&air_date=$formattedDate&region=$countryCode'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];

    List<Movie> movies = data.map((json) {      
      String title = json['name'] ?? 'Unknown Title';      
      String releaseDate = json['first_air_date'] ?? 'Unknown Release Date';
      String imagePath = json['poster_path'] != null ? '$imageUrl${json['poster_path']}' : 'No Image';
      String rating = json['vote_average']?.toString() ?? '0.0';

      return Movie(        
        title: title,        
        releaseDate: releaseDate,
        imagePath: imagePath,
        rating: rating,
      );
    }).toList();

    return movies;
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
        throw Exception("Actor not found");
      }
    } else {
      throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

Future<List<Movie>> getActorTvSeries(String actorName) async {
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

            return tvSeriesData.map((json) => Movie.fromJson(json)).toList();
          } else {
            throw Exception("Failed to get actor's TV series");
          }
        } else {
          throw Exception("Actor ID is null");
        }
      } else {
        throw Exception("Actor not found");
      }
    } else {
      throw Exception("Failed to search for actor. Status Code: ${actorSearchRes.statusCode}");
    }
  } catch (e) {
    throw Exception("Something went wrong! $e");
  }
}

Future<List<Movie>> searchMoviesAndSeries(String searchTerm) async {
    try {
      // Search for both movies and TV series by name
      var searchRes = await http.get(Uri.parse(
          '$url/search/multi?query=$searchTerm&page=1&api_key=$apiKey'));

      if (searchRes.statusCode == 200) {
        var searchData = jsonDecode(searchRes.body)['results'] as List;
        return searchData
            .map((json) => Movie.fromJson(json))
            .where((movie) => movie.title != null && movie.title.isNotEmpty) // Filter out entries without a title
            .toList();
      } else {
        throw Exception("Failed to search for movies and TV series");
      }
    } catch (e) {
      throw Exception("Something went wrong! $e");
    }
  }
}
 

class Movie {  
  final String title;  
  final String releaseDate;
  final String imagePath;  
  final String rating;

   Movie({    
    required this.title,    
    required this.releaseDate,    
    required this.imagePath,
    required this.rating,    
   });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Check if the entry is a TV series
    if (json['original_name'] != null) {
      return Movie(
        title: json['original_name'] ?? 'Unknown Title',
        releaseDate: json['first_air_date'] ?? 'Unknown Release Date',
        imagePath: json['poster_path'] ?? '',
        rating: json['vote_average']?.toString() ?? '0.0',
      );
    } else {
      // Assume it's a movie
      return Movie(
        title: json['title'] ?? 'Unknown Title',
        releaseDate: json['release_date'] ?? 'Unknown Release Date',
        imagePath: json['poster_path'] ?? '',
        rating: json['vote_average']?.toString() ?? '0.0',
      );
    }
  }
}
  
class CinemaListScreen extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema listing'),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
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

class MovieListCinema extends StatelessWidget {
  final List<Movie> movies;

  MovieListCinema({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movies[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  movies[index].title,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                subtitle: Text(
                  movies[index].releaseDate,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                leading: Image.network(
                  movies[index].imagePath,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [                
                SizedBox(width: 16.0), 
                ElevatedButton.icon(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema listing'),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
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
                  List<Movie> movies = snapshot.data as List<Movie>;
                  return MovieListSeries(movies: movies);
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}

class MovieListSeries extends StatelessWidget {
  final List<Movie> movies;

  MovieListSeries({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movies[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  movies[index].title,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                subtitle: Text(
                  movies[index].releaseDate,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                leading: Image.network(
                  movies[index].imagePath,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [                
                SizedBox(width: 16.0), 
                ElevatedButton.icon(
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
  List<Movie> _watchlist = [];
  List<Movie> _watchedlist = [];

  List<Movie> get watchlist => _watchlist;
  List<Movie> get watchedlist => _watchedlist;
  
    void addToWatchlist(Movie movie) {
      if (_watchlist.contains(movie)) {
        _watchlist.remove(movie);
      } else {
        _watchlist.add(movie);
      }
      notifyListeners();
  }

  // checks if a movie is in the watchlist
  bool isInWatchlist(Movie movie) {
    return _watchlist.contains(movie);
  }  

  void addToWatchedlist(Movie movie) {
      if (_watchedlist.contains(movie)) {
        _watchedlist.remove(movie);
      } else {
        _watchedlist.add(movie);
      }
      notifyListeners();
  }

  // checks if a movie is in the watchedlist
  bool isInWatchedlist(Movie movie) {
    return _watchedlist.contains(movie);
  }  
}

class MyWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Movie> watchlist = movieProvider.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('to watch and watched'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBar(),
                ),
              );
            },
          ),
        ],
      ),
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp2.jpg'),
                        fit: BoxFit.cover,
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
            top: 150.0,
            right: 8.0,
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
        ],
      ),
    );
  }
}

class MyWatchedlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Movie> watchedlist = movieProvider.watchedlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('watched'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBar(),
                ),
              );
            },
          ),
        ],
      ),
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('web/assets/cp2.jpg'),
                        fit: BoxFit.cover,
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
          // Navigate to WatchedlistScreen Button
          Positioned(
            top: 150.0,
            right: 8.0,
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('profile'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('web/assets/cp2.jpg'),
                      fit: BoxFit.cover,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    'Edit profile',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                  ),
                                  child: Text(
                                    'Change password',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            const SizedBox(height: 190.0),
                            Align(
                              alignment: Alignment.bottomCenter,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppHomeScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    'back',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                          ]),
                    ))
              ]),
        )));
  }
}

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('profile'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('web/assets/cp2.jpg'),
                      fit: BoxFit.cover,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    'Change username',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            const SizedBox(height: 50.0),
                            Align(
                              alignment: Alignment.center,
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                  ),
                                  child: Text(
                                    'Change Email',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            const SizedBox(height: 190.0),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VisitProfileScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    'back',
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                          ]),
                    ))
              ]),
        )));
  }
}

class ChangeEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change email'),
      ),
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
                              Navigator.of(context).pop();
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
      appBar: AppBar(
        title: const Text('Change username'),
      ),
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
                  } else
                    return 'Please enter a valid username';
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
                        title: const Text('username changed'),
                        content: const Text(
                            'Your username has been successfully changed!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
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
            ],
          ),
        ),
      ),
    );
  }
}

class BestMoviesAllTime extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Of All Time!'),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
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
                  return MovieListAllTime(movies: movies);
                }
              },
            ),
          ),
        ],
      ),
      
    );
  }
}

class MovieListAllTime extends StatelessWidget {
  final List<Movie> movies;

  MovieListAllTime({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movies[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  movies[index].title,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                subtitle: Text(
                  movies[index].releaseDate,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                leading: Image.network(
                  movies[index].imagePath,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to best movies of the year screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BestMoviesThisYear(),
                      ),
                    );
                  },
                  child: Text('This Year'),
                ),
                SizedBox(width: 16.0), 
                ElevatedButton.icon(
                  onPressed: () {                   
                   Navigator.push(
                   context,
                    MaterialPageRoute(
                     builder: (context) => BestMoviesThisYear(),
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


class BestMoviesThisYear extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Movies'),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
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

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movies[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  movies[index].title,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                subtitle: Text(
                  movies[index].releaseDate,
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                leading: Image.network(
                  movies[index].imagePath,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to best movies of all time screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BestMoviesAllTime(),
                      ),
                    );
                  },
                  child: Text('Of all time!'),
                ),
                SizedBox(width: 16.0), 
                ElevatedButton.icon(
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

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Movie Details          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(                  
                   'https://image.tmdb.org/t/p/w500' + movie.imagePath,                                
                  fit: BoxFit.cover,
                  width: 200.0,
                  height: 200.0,
                ),
                SizedBox(height: 20.0),                
                Text(
                  'Release Date: ${movie.releaseDate}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),                
                Text(
                  'title: ${movie.title}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Rating: ${movie.rating}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),

                // Add to Watchlist Button
                ElevatedButton(
                  onPressed: () {
                    if (!movieProvider.isInWatchlist(movie)) {
                      movieProvider.addToWatchlist(movie);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} added to watchlist.'),                          
                        ),                        
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} is already in watchlist.'),
                        ),
                      );
                    }
                  },
                  child: Text('Add to Watchlist'),
                ),                
                SizedBox(height: 20.0),
                
                ElevatedButton(
                  onPressed: () {
                    if (!movieProvider.isInWatchedlist(movie)) {
                      movieProvider.addToWatchedlist(movie);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} added to watchedlist.'),                          
                        ),                        
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${movie.title} is already in watchedlist.'),
                        ),
                      );
                    }
                  },
                  child: Text('Add to MyWatchedlist'),
                ),   
              ],
            ),            
          ),          
        ],
      ),
    );
  }
}              
      
class SearchResultsScreen extends StatefulWidget {
  final String actorName;

  const SearchResultsScreen({Key? key, required this.actorName}) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TmdbService tmdbService = TmdbService();
  List<Movie> _moviesList = [];
  List<Movie> _tvSeriesList = [];
  List<Movie> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('web/assets/cp2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                // Display Search Results
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: MoviesActorList(movies: _searchResults),
                  )
                else
                  Text('No results'),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                // Movies List
                if (_moviesList.isNotEmpty)
                  Expanded(
                    child: MoviesActorList(movies: _moviesList),
                  )
                else
                  Container(),

                // TV Series List
                if (_tvSeriesList.isNotEmpty)
                  Expanded(
                    child: MoviesActorList(movies: _tvSeriesList),
                  )
                else
                  Container(),
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Home Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('web/assets/cp2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: formGlobalKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a search term';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Actors, movies...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              String searchTerm = _searchController.text.trim();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultsScreen(actorName: searchTerm),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CinemaListScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                        ),
                        child: const Text(
                          'Cinema listing',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvListScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                        child: const Text(
                          'Whats On TV',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyWatchlistScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                        child: const Text(
                          'MyWatchlist',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisitProfileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                        ),
                        child: const Text(
                          'Visit Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BestMoviesThisYear(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        child: const Text(
                          'Best Rated movies',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MoviesActorList extends StatelessWidget {
  final List<Movie> movies;

  MoviesActorList({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    } else {
      return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              movies[index].title ?? '',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Release Date: ${movies[index].releaseDate}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Text(
                  'Rating: ${movies[index].rating}',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Image.network(
                  'https://image.tmdb.org/t/p/w500' + movies[index].imagePath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            onTap: () {
              // Navigate to a screen showing the actor's movie details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movies[index]),
                ),
              );
            },
          );
        },
      );
    }
  }
}

class MyHomePage extends StatelessWidget with ValidationMixin {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to MovieMate!'),                
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 2.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('web/assets/cp1.jpg'), fit: BoxFit.cover),
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
                      validator: (email) {
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
                      validator: (password) {
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
    );
  }
}


class ForgotPassword extends StatelessWidget with ValidationMixin {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
      ),
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
                                Navigator.of(context).pop();
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
      appBar: AppBar(
        title: const Text('Create New Account'),
      ),
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
                                Navigator.of(context).pop();
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
  bool isPasswordValid(String inputpassword) => inputpassword.length == 6;
}
