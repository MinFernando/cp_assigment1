import 'package:cp_assignment/screens/best_movies_this_year.dart';
import 'package:cp_assignment/screens/change_password.dart';
import 'package:cp_assignment/screens/cinema.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:cp_assignment/screens/highest_grossing.dart';
import 'package:cp_assignment/screens/homepage.dart';
import 'package:cp_assignment/screens/search_results.dart';
import 'package:cp_assignment/screens/series_display.dart';
import 'package:cp_assignment/screens/watchedlist.dart';
import 'package:cp_assignment/screens/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'constructors.dart'; 

// Define the main home screen widget
class AppHomeScreen extends StatelessWidget {
  // Global key for the form widget
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  // Controller for the search text field
  TextEditingController _searchController = TextEditingController();

  // Background color for the app
  Color backgroundColor = Color.fromARGB(255, 0, 0, 0);

  // Service for fetching movie and TV show data
  TmdbService tmdbService = TmdbService(); // Assuming TmdbService is defined

  // Method to display the profile bottom sheet
  void showProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 248, 248, 248),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: <Widget>[
                // Profile avatar
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage('web/assets/cp6.jpg'),
                ),
                // Change password option
                buildListTile(
                  title: 'Change Password',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                ),
                // My Watchlist option
                buildListTile(
                  title: 'My Watchlist',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyWatchlistScreen()),
                    );
                  },
                ),
                // My Watched List option
                buildListTile(
                  title: 'My Watched List',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyWatchedlistScreen()),
                    );
                  },
                ),
                // Log out option
                buildListTile(
                  title: 'Log Out',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Welcome to MovieMate!')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build a ListTile
  Widget buildListTile({required String title, required Function onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title),
        onTap: () {
          onTap();
        },
      ),
    );
  }

  // Build method for the home screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Search bar section
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Search text field
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Actors, movies, series...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                // Search button
                                IconButton(
                                  onPressed: () {
                                    if (formGlobalKey.currentState!.validate()) {
                                      String searchTerm = _searchController.text.trim();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchResultsScreen(
                                            actorName: searchTerm,
                                            title: searchTerm,
                                          ),
                                        ),
                                      ).then((_) => _searchController.text = '');
                                    }
                                  },
                                  icon: Icon(Icons.search, color: Colors.grey, size: 24),
                                ),
                                // Profile button
                                IconButton(
                                  onPressed: () => showProfileBottomSheet(context),
                                  icon: Icon(Icons.account_circle, color: Colors.grey, size: 24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Welcome message
                  Text(
                    'Welcome to MovieMate!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 216, 202, 135),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Content carousels
            Container(
              width: MediaQuery.of(context).size.width,
              color: backgroundColor,
              child: Center(
                child: Form(
                  key: formGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // TV series carousel
                      buildTVSeriesCarouselWidget(
                        context: context,
                        title: 'Whats on TV?',
                        futureFunction: tmdbService.getTVShowsAiringTonight,
                      ),
                      const SizedBox(height: 10),
                      // Movies carousel (In Cinemas Now)
                      buildMovieCarouselWidget(
                        context: context,
                        title: 'In Cinemas Now',
                        futureFunction: tmdbService.getNowPlayingMovies,
                      ),
                      const SizedBox(height: 10),
                      // Movies carousel (Popular this Year)
                      buildMovieCarouselWidget(
                        context: context,
                        title: 'Popular this Year',
                        futureFunction: tmdbService.getNowPlayingMovies,
                      ),
                      const SizedBox(height: 10),
                      // Movies carousel (Highest Grossing)
                      buildMovieCarouselWidget(
                        context: context,
                        title: 'Highest Grossing',
                        futureFunction: tmdbService.getHighestGrossingOfAllTime,
                      ),
                      const SizedBox(height: 70.0),
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
}

// Widget to build a movie carousel
Widget buildMovieCarouselWidget({
  required BuildContext context,
  required String title,
  required Future<List<Movie>> Function() futureFunction,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Carousel title
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            // "See All" button
            TextButton(
              onPressed: () {
                // Navigate to different screens based on the title
                if (title == 'In Cinemas Now') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CinemaListScreen(),
                    ),
                  );
                } else if (title == 'Popular this Year') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BestMoviesThisYear(),
                    ),
                  );
                } else if (title == 'Highest Grossing') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BestMovieAllTime(),
                    ),
                  );
                }
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      // Future builder for fetching movie data
      FutureBuilder<List<Movie>>(
        future: futureFunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Extract image paths from movie data
            List<String> movieImages = snapshot.data!.map((movie) => movie.imagePath).toList();
            // Display carousel slider with movie images
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                aspectRatio: 20 / 8,
                viewportFraction: 0.3,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: movieImages.map((imageUrl) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.amber, width: 2.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}

// Widget to build a TV series carousel
Widget buildTVSeriesCarouselWidget({
  required BuildContext context,
  required String title,
  required Future<List<TVSeries>> Function(String) futureFunction,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Carousel title
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            // "See All" button
            TextButton(
              onPressed: () {
                if (title == 'Whats on TV?') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TvListScreen(),
                    ),
                  );
                }
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      // Future builder for fetching TV series data
      FutureBuilder<List<TVSeries>>(
        future: futureFunction("US"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Extract image paths from TV series data
            List<String> tvSeriesImages = snapshot.data!.map((tvSeries) => tvSeries.imagePath).toList();
            // Display carousel slider with TV series images
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                aspectRatio: 20 / 8,
                viewportFraction: 0.3,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: tvSeriesImages.map((imageUrl) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.amber, width: 2.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    ],
  );
}

// Main function to run the Flutter application
void main() {
  runApp(MaterialApp(
    home: AppHomeScreen(),
  ));
}
