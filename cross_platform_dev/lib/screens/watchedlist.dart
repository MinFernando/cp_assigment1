import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:cp_assignment/screens/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cp_assignment/screens/content_details.dart'; 


class MyWatchedlistScreen extends StatelessWidget {
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
        future: movieProvider.fetchWatchedlistFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return movieProvider.watchedlist.isEmpty
                ? const Center(
                    child: Text(
                      'No movies watched yet',
                      style: TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Watched List',
                          style: TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        const SizedBox(height: 20.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: movieProvider.watchedlist.length,
                          itemBuilder: (context, index) {
                            Content content = movieProvider.watchedlist[index];
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
