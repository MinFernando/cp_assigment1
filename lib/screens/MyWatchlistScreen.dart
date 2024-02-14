import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppHomeScreen.dart';
import 'ContentInitalizing.dart';
import 'watchedListScreen.dart';

class MovieProvider with ChangeNotifier {
  List<Content> _watchlist = [];
  List<Content> _watchedlist = [];

  List<Content> get watchlist => _watchlist;
  List<Content> get watchedlist => _watchedlist;
  
  void addToWatchlist(Content content) {
    if (_watchlist.contains(content)) {
      _watchlist.remove(content);
    } else {
      _watchlist.add(content);
    }
    notifyListeners();
  }

  // checks if a movie is in the watchlist
  bool isInWatchlist(Content content) {
    return _watchlist.contains(content);
  }  

  void addToWatchedlist(Content content) {
    if (_watchedlist.contains(content)) {
      _watchedlist.remove(content);
    } else {
      _watchedlist.add(content);
    }
    notifyListeners();
  }

  // checks if a movie is in the watchedlist
  bool isInWatchedlist(Content content) {
    return _watchedlist.contains(content);
  }  
}

class MyWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Content> watchlist = movieProvider.watchlist;   

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Watchlist',
                    style: TextStyle(fontSize: 24.0, color: Colors.black),
                  ),
                  SizedBox(height: 20.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: watchlist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(watchlist[index].imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    watchlist[index].title,
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Rating: ${watchlist[index].rating}',
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    watchlist[index].overview,
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.0,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppHomeScreen(),
                        ),
                      );
                    },
                    child: Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      disabledBackgroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyWatchedlistScreen(),
                        ),
                      );
                    },
                    child: Text('Go to Watched list'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      disabledBackgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
