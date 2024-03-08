import 'package:cp_assignment/screens/ContentInitalizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cp_assignment/screens/CinemaDisplay.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Sort by Date with mock images', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Mock movie data
      List<Movie> mockMovies = [
        Movie(title: 'B Movie', releaseDate: '2022-02-01', imagePath: 'http://example.com/b.jpg', rating: '', overview: ''),
        Movie(title: 'A Movie', releaseDate: '2022-01-01', imagePath: 'http://example.com/a.jpg', rating: '', overview: ''),
        Movie(title: 'C Movie', releaseDate: '2022-03-01', imagePath: 'http://example.com/c.jpg', rating: '', overview: ''),
      ];
    
      // Build app and trigger a frame
      await tester.pumpWidget(MaterialApp(
        home: MovieListCinema(movies: mockMovies),
      ));

      // Wait for the movies to load
      await tester.pumpAndSettle();

      
      await tester.tap(find.text('Sort by Date'));
      await tester.pumpAndSettle(); // Rebuild the UI after the state change

      // Verify the order of movie titles based on sorted release dates
    final titleFinder = find.byType(Text);
    expect(titleFinder, findsWidgets);

    // Extract the displayed titles
    final titles = tester.widgetList<Text>(titleFinder).map((e) => e.data).toList();    
    bool correctOrder = titles.indexOf('A Movie') < titles.indexOf('B Movie') && titles.indexOf('B Movie') < titles.indexOf('C Movie');
    expect(correctOrder, isTrue);                   
    });
  });
}
