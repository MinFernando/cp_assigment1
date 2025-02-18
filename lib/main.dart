import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/AppHomeScreen.dart';
import 'screens/BestMovieThisYear.dart';
import 'screens/ChangePasswordScreen.dart';
import 'screens/CinemaDisplay.dart';
import 'screens/ForgotPassword.dart';
import 'screens/HighestGrossingAllTime.dart';
import 'screens/HomePage.dart';
import 'screens/MyWatchlistScreen.dart';
import 'screens/SearchResultsScreen.dart';
import 'screens/SeriesDisplay.dart';
import 'screens/watchedListScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyB9eN4Da6L2I1j6711Mu7v6AQqIORC7nA8", appId: "1:848553104492:web:6ce5be0dadae21c7983449", messagingSenderId: "848553104492", projectId: "crossplatform-c4865"));
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

