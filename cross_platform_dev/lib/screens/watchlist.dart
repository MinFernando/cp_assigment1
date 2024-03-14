import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/content_details.dart';
import 'package:cp_assignment/screens/content_initializing.dart';

class MovieProvider with ChangeNotifier {
  List<Content> _watchlist = [];
  List<Content> _watchedlist = [];

  List<Content> get watchlist => _watchlist; 

  List<Content> get watchedlist => _watchedlist; 

  void addToWatchlist(Content content) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference watchlistCollection = firestore.collection('watchlist');
    if (!_watchlist.contains(content)) {
      _watchlist.add(content);
      watchlistCollection.doc(content.title.toString()).set({        
        'title': content.title,
        'imagePath': content.imagePath,     
        'released_date': content.releaseDate,
        'rating': content.rating,
        'overview': content.overview,   
      });
    } else {
      _watchlist.remove(content);
      watchlistCollection.doc(content.title.toString()).delete();
    }
    notifyListeners();
  }

  Future<void> fetchWatchlistFromFirestore() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot watchlistSnapshot = await firestore.collection('watchlist').get();

  List<Content> newWatchlist = [];
  for (var doc in watchlistSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    // Created a JSON-like map that matches the expected format of TMDB JSON
    var json = {
      'title': data['title'],      
      'poster_path': data['imagePath'], 
      'released_date': data['released_date'],
      'rating': data['rating'],
      'overview': data['overview'],
      
    };

    try {
      Content content = Content.fromJson(json); 
      newWatchlist.add(content);
    } catch (e) {
      print("Error converting Firestore document to Content object: $e");      
    }
  }

  _watchlist = newWatchlist;
  notifyListeners();
}

void addToWatchedlist(Content content) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference watchedlistCollection = firestore.collection('watchedlist');
    if (!_watchedlist.contains(content)) {
      _watchedlist.add(content);
      watchedlistCollection.doc(content.title.toString()).set({        
        'title': content.title,
        'imagePath': content.imagePath,     
        'released_date': content.releaseDate,
        'rating': content.rating,
        'overview': content.overview,   
      });
    } else {
      _watchedlist.remove(content);
      watchedlistCollection.doc(content.title.toString()).delete();
    }
    notifyListeners();
  }

  Future<void> fetchWatchedlistFromFirestore() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final QuerySnapshot watchedlistSnapshot = await firestore.collection('watchedlist').get();

  List<Content> newWatchedlist = [];
  for (var doc in watchedlistSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    // Created a JSON-like map that matches the expected format of TMDB JSON
    var json = {
      'title': data['title'],      
      'poster_path': data['imagePath'], 
      'released_date': data['released_date'],
      'rating': data['rating'],
      'overview': data['overview'],
      
    };

    try {
      Content content = Content.fromJson(json); 
      newWatchedlist.add(content);
    } catch (e) {
      print("Error converting Firestore document to Content object: $e");      
    }
  }

  _watchedlist = newWatchedlist;
  notifyListeners();
}

  bool isInWatchlist(Content content) {
    return _watchlist.contains(content);
  }

   bool isInWatchedlist(Content content) {
    return _watchedlist.contains(content);
  }   
}

class MyWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

   return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(        
        backgroundColor: Color.fromARGB(255, 0, 0, 0), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () => Navigator.of(context).pop(), // Navigate back
        ),
      ),  
      body: FutureBuilder(
        future: movieProvider.fetchWatchlistFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the data is still loading, show a progress indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, display it
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Once data is fetched, build UI
            return movieProvider.watchlist.isEmpty
                ? const Center(
                    child: Text(
                      'No movies added',
                      style: TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Watchlist',
                          style: TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        const SizedBox(height: 20.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), 
                          itemCount: movieProvider.watchlist.length,
                          itemBuilder: (context, index) {
                            Content content = movieProvider.watchlist[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContentDetailScreen(content: content),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 36, 36, 37),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
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
                                          image: NetworkImage(content.imagePath),
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            content.title,
                                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            'Rating: ${content.rating}',
                                            style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            content.overview,
                                            style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                                            maxLines: 3,
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
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
