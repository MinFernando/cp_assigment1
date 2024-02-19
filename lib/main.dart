
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/AppHomeScreen.dart';
import 'screens/BestMovieThisYear.dart';
import 'screens/ChangeEmailScreen.dart';
import 'screens/ChangePasswordScreen.dart';
import 'screens/ChangeUsernameScreen.dart';
import 'screens/CinemaDisplay.dart';
import 'screens/EditProfileScreen.dart';
import 'screens/ForgotPassword.dart';
import 'screens/HighestGrossingAllTime.dart';
import 'screens/HomePage.dart';
import 'screens/MyWatchlistScreen.dart';
import 'screens/SearchResultsScreen.dart';
import 'screens/SeriesDisplay.dart';
import 'screens/VisitProfileScreen.dart';
import 'screens/watchedListScreen.dart';

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
        '/eighth': (context) => BestMovieAllTime(),
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

