import 'package:cp_assignment/screens/VisitProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'BestMovieThisYear.dart';
import 'CinemaDisplay.dart';
import 'ContentInitalizing.dart';
import 'HighestGrossingAllTime.dart';
import 'SearchResultsScreen.dart';
import 'SeriesDisplay.dart';
import 'constructors.dart';

  class AppHomeScreen extends StatelessWidget {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  TextEditingController _searchController = TextEditingController();

  Color backgroundColor = Color.fromARGB(255, 0, 0, 0);

  TmdbService tmdbService = TmdbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[            
            Container(              
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 2, 15),
              ),
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,               
                children: <Widget>[
                   Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 2, 2, 15),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                            builder: (context) => VisitProfileScreen(),
                          ),
                        );
                      },
                        icon: const Icon(Icons.account_circle, color: Colors.grey),
                    ),
                   ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
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
                              hintText: 'Actors, movies series...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),                        
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
                      const SizedBox(height: 10),
                      buildTVSeriesCarouselWidget(
                        context: context,
                        title: 'Whats on TV?',
                        futureFunction: tmdbService.getTVShowsAiringTonight,
                      ),
                      const SizedBox(height: 10),
                      buildMovieCarouselWidget(
                        context: context,
                        title: 'In Cinemas Now',
                        futureFunction: tmdbService.getNowPlayingMovies,
                      ),
                      const SizedBox(height: 10),
                      buildMovieCarouselWidget(
                        context: context,
                        title: 'Popular this Year',
                        futureFunction: tmdbService.getPopularMovies2024,
                      ),
                      const SizedBox(height: 10),
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
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 118, 29),
              ),
            ),
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
      FutureBuilder<List<Movie>>(
        future: futureFunction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> movieImages = snapshot.data!.map((movie) => movie.imagePath).toList();
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,
                aspectRatio: 20 / 8,
                viewportFraction: 0.3, //ensures all three images are seen
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),              
              ),
              items: movieImages.map((imageUrl) {
                return Container(                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.amber, width: 2.0), // Added a gold border
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 118, 29),
              ),
            ),
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
      FutureBuilder<List<TVSeries>>(
        future: futureFunction("US"), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> tvSeriesImages = snapshot.data!.map((tvSeries) => tvSeries.imagePath).toList();
            return CarouselSlider(
              options: CarouselOptions(
                height: 200,               
                aspectRatio: 20 / 8,
                viewportFraction: 0.3, //ensures all three images are seen
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: tvSeriesImages.map((imageUrl) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.amber, width: 2.0), // Added a gold border
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
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

void main() {
  runApp(MaterialApp(
    home: AppHomeScreen(),
  ));
}
