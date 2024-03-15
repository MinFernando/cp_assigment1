
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';
import 'constructors.dart';

class TvListScreen extends StatelessWidget {
  // Service for interacting with the TMDb API.
  final TmdbService tmdbService = TmdbService();
  // Default country code used for fetching TV shows.
  String userCountryCode = 'US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [                    
          // Movie List
          Center(
            child: FutureBuilder( // FutureBuilder to handle asynchronous data fetching
              future: tmdbService.getTVShowsAiringTonight('US'), // fetches series
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // shows loading indicator
                } else if (snapshot.hasError) {
                  return Center( // shows error message if error occurs
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<TVSeries> series = snapshot.data as List<TVSeries>; // Extracting list of movies from snapshot
                  return ListSeries(series: series); // Displaying movies
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
      displayedSeries.sort((a, b) => a.releaseDate.compareTo(b.releaseDate)); // sort by date
    } else if (sortByTitle) {
      displayedSeries.sort((a, b) => a.title.compareTo(b.title)); // sort by title
    }

    return Stack(
      children: [
        // ListView to display the series
        ListView.builder( 
          itemCount: displayedSeries.length, // list length
          itemBuilder: (context, index) {
            return GestureDetector(  // GestureDetector for tapping on a movie to view details
              onTap: () {
                // Navigate to the content detail screen when a movie is tapped
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
                  color: Color.fromARGB(255, 36, 36, 37),  
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      // shows shadow
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
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
                          image: NetworkImage(displayedSeries[index].imagePath), // network image
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
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
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
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
                            overflow: TextOverflow.ellipsis, // trucncates if overview overflowed
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
        // bottom container for sorting and back icons
          Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08, 
          color: Color.fromARGB(255, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              // sort by date icon
              IconButton(
                icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 172, 172, 172)), 
                onPressed: () {
                  setState(() {
                    sortByDate = !sortByDate;
                    sortByTitle = false;
                  });
                },
              ),
              // sort by title icon
              IconButton(
                icon: Icon(Icons.sort_by_alpha, color: const Color.fromARGB(255, 172, 172, 172)), 
                onPressed: () {
                  setState(() {
                    sortByTitle = !sortByTitle;
                    sortByDate = false;
                  });
                },
              ),
              // back icon
              IconButton(
                icon: Icon(Icons.home, color: const Color.fromARGB(255, 172, 172, 172)), 
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppHomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ],
    );
  }
}
