import 'package:flutter/material.dart';
import 'AppHomeScreen.dart';
import 'ContentDetailsScreen.dart';
import 'ContentInitalizing.dart';
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
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8.0),
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
        // Back Button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            color: Color.fromARGB(255, 255, 255, 255), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                  ),
                  onPressed: () {
                    // Toggle sorting by date
                    setState(() {
                      sortByDate = !sortByDate;
                      sortByTitle = false;
                    });
                  },
                  child: Text('Sort by Date'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                  ),
                  onPressed: () {
                    // Toggle sorting by title
                    setState(() {
                      sortByTitle = !sortByTitle;
                      sortByDate = false;
                    });
                  },
                  child: Text('Sort by Title'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255), 
                  ),
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
