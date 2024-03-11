import 'package:cp_assignment/screens/AppHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ContentInitalizing.dart';
import 'MyWatchlistScreen.dart';

class MyWatchedlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<Content> watchedlist = movieProvider.watchedlist;

  if (watchedlist == null) {
      throw new Exception("watchedlist is empty");
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: watchedlist.isEmpty // Check if watchedlist is empty
                ? Center( 
                    child: Text(
                      'No movies added',
                      style: TextStyle(fontSize: 24.0, color: Colors.black),
                    ),
                  )
            : SingleChildScrollView(
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
                    itemCount: watchedlist.length,
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
                                  image: NetworkImage(watchedlist[index].imagePath),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    watchedlist[index].title,
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Rating: ${watchedlist[index].rating}',
                                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    watchedlist[index].overview,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}