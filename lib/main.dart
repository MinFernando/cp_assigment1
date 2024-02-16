import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/HighestGrossingAllTime.dart';
import 'screens/AppHomeScreen.dart';
import 'screens/BestMovieThisYear.dart';
import 'screens/ChangeEmailScreen.dart';
import 'screens/ChangePasswordScreen.dart';
import 'screens/ChangeUsernameScreen.dart';
import 'screens/CinemaDisplay.dart';
import 'screens/ContentInitalizing.dart';
import 'screens/EditProfileScreen.dart';
import 'screens/ForgotPassword.dart';
import 'screens/HomePage.dart';
import 'screens/MyWatchlistScreen.dart';
import 'screens/SearchResultsScreen.dart';
import 'screens/SeriesDisplay.dart';
import 'screens/VisitProfileScreen.dart';
import 'screens/watchedListScreen.dart';

List<Movie> displayedMovies = [];

Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    Firebase.initializeApp(options: 
    FirebaseOptions(apiKey: "AIzaSyCz5J7_27Ig6hYbMekAUQlDxqZFlKa6uXM", 
    appId: "1:361652579453:web:9dcf1cbaef1f81f0045514", 
    messagingSenderId: "361652579453", 
    projectId: "cross-platform-assignmen-f09aa"));
  }

  await Firebase.initializeApp();
  
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
        '/seventh': (context) => MovieThisYear(movies: displayedMovies),
        '/eighth': (context) => BestMoviesAllTime(movies: displayedMovies),
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

