
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/best_movies_this_year.dart';
import 'package:cp_assignment/screens/change_password.dart';
import 'package:cp_assignment/screens/cinema.dart';
import 'package:cp_assignment/screens/forgot_password.dart';
import 'package:cp_assignment/screens/highest_grossing.dart';
import 'package:cp_assignment/screens/homepage.dart';
import 'package:cp_assignment/screens/search_results.dart';
import 'package:cp_assignment/screens/series_display.dart';
import 'package:cp_assignment/screens/watchedlist.dart';
import 'package:cp_assignment/screens/watchlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized
  if(kIsWeb){
    await Firebase.initializeApp(options: 
    const FirebaseOptions(
      apiKey: "AIzaSyB9eN4Da6L2I1j6711Mu7v6AQqIORC7nA8", 
      appId: "1:848553104492:web:6ce5be0dadae21c7983449", 
      messagingSenderId: "848553104492", 
      projectId: "crossplatform-c4865"));
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
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign in and login',
      debugShowCheckedModeBanner: false,
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
        '/seventh': (context) => BestMoviesThisYear(),
        '/eighth': (context) => BestMovieAllTime(),
        '/ninth': (context) => MyWatchedlistScreen(),        
        '/eleventh': (context) => ChangePassword(),        
        '/twelveth': (context) => ForgotPassword(),
        '/thirteenth': (context) => SearchResultsScreen(actorName: '', title: '',)
      },
    );
  }
}

