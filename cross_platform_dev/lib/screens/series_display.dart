
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:flutter/material.dart';
import 'constructors.dart';

class TvListScreen extends StatelessWidget {
  final TmdbService tmdbService = TmdbService();
  String userCountryCode = 'US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Stack(
        children: [                    
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
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
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
                          image: NetworkImage(displayedSeries[index].imagePath),
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
          Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08, 
          color: Color.fromARGB(255, 235, 235, 235),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              IconButton(
                icon: Icon(Icons.date_range, color: Colors.black), // Icon for sorting by date
                onPressed: () {
                  setState(() {
                    sortByDate = !sortByDate;
                    sortByTitle = false;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.sort_by_alpha, color: Colors.black), // Icon for sorting by title
                onPressed: () {
                  setState(() {
                    sortByTitle = !sortByTitle;
                    sortByDate = false;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.home, color: Colors.black), 
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
