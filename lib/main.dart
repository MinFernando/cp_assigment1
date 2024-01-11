import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
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
        '/second': (context) => appHomeScreen(),
        '/third': (context) => cinemaListScreen(),
        '/fourth': (context) => tvListScreen(),
        '/fifth': (context) => myWatchlistScreen(),
        '/sixth': (context) => visitProfileScreen(),
        '/seventh': (context) => bestMoviesThisYear(),
        '/eighth': (context) => bestMoviesAllTime(),
        '/ninth': (context) => watchedListScreen(),
        '/tenth': (context) => editProfileScreen(),
        '/eleventh': (context) => changePassword(),
        '.twelveth': (context) => changeUsernameScreen(),
        'thirteth': (context) => changeEmailScreen(),
        'fouteenth': (context) => forgotPassword(),
      },
    );
  }
}

class changePassword extends StatelessWidget {
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
          title: json['title'],
          releaseDate: json['release_date'],
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
          title: json['title'],
          releaseDate: json['release_date'],
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
          title: json['title'],
          releaseDate: json['release_date'],
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
    return Movie(
      title: json['title'],
      releaseDate: json['release_date'],
      imagePath: json['image_path'],
      rating: json['vote_average'].toString(),
    );
  }
}
  
class cinemaListScreen extends StatelessWidget {
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
                     builder: (context) => appHomeScreen(),
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

class tvListScreen extends StatelessWidget {
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
                     builder: (context) => appHomeScreen(),
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
                               
class myWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                          const Text(
                            'MyWatchlist',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          ListTile(
                            title: const Text(
                              'series 1',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: const Text(
                              'Action, Adventure',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'series 2',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: const Text(
                              'Comedy, Drama',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => watchedListScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: Text(
                                  'Watched list',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 190.0),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => appHomeScreen(),
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
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class watchedListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Watched list'),
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
                          const Text(
                            'My Watched List',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          ListTile(
                            title: const Text(
                              'movie 1',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: const Text(
                              'Action, Adventure',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'movie 2',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: const Text(
                              'Comedy, Drama',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => myWatchlistScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: Text(
                                  'Watch List',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class visitProfileScreen extends StatelessWidget {
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
                                            editProfileScreen(),
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
                                        builder: (context) => changePassword(),
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
                                        builder: (context) => appHomeScreen(),
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

class editProfileScreen extends StatelessWidget {
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
                                            changeUsernameScreen(),
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
                                            changeEmailScreen(),
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
                                            visitProfileScreen(),
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

class changeEmailScreen extends StatelessWidget {
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

class changeUsernameScreen extends StatelessWidget {
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


class bestMoviesAllTime extends StatelessWidget {
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
                    // Navigate to best movies of all time screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => bestMoviesThisYear(),
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
                     builder: (context) => bestMoviesThisYear(),
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


class bestMoviesThisYear extends StatelessWidget {
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
                        builder: (context) => bestMoviesAllTime(),
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
                     builder: (context) => appHomeScreen(),
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
                  movie.imagePath,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text('Search Bar Content'),
      ),
    );
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
                      decoration: const InputDecoration(
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
                                  builder: (context) => forgotPassword(),
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

class appHomeScreen extends StatelessWidget {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Home Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('web/assets/cp2.jpg'), // background image path
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
                      color: Colors.white, // Set the background color to white
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // Existing username input
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: usernameController,
                            validator: (email) {
                              // validation logic for the existing username
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
                              formGlobalKey.currentState!.save();
                              // Perform search logic with the username
                              String username = usernameController.text;
                              // Add logic to handle the search with the username
                              print('Search username: $username');
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
                              builder: (context) => cinemaListScreen(),
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
                              builder: (context) => tvListScreen(),
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
                              builder: (context) => myWatchlistScreen(),
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
                              builder: (context) => visitProfileScreen(),
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
                              builder: (context) => bestMoviesThisYear(),
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

class forgotPassword extends StatelessWidget with ValidationMixin {
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
