import 'package:cp_assignment/screens/ContentInitalizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cp_assignment/screens/SeriesDisplay.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Sort by Date with mock images', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Mock movie data
      List<TVSeries> mockMovies = [
        TVSeries(title: 'Series B', releaseDate: '2022-02-01', imagePath: 'http://example.com/b.jpg', rating: '', overview: ''),
        TVSeries(title: 'Series A', releaseDate: '2022-01-01', imagePath: 'http://example.com/a.jpg', rating: '', overview: ''),
        TVSeries(title: 'Series C', releaseDate: '2022-03-01', imagePath: 'http://example.com/c.jpg', rating: '', overview: ''),
      ];
    
      // Build app and trigger a frame
      await tester.pumpWidget(MaterialApp(
        home: ListSeries(series: mockMovies),
      ));

      // Wait for the movies to load
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sort by Title'));
      await tester.pumpAndSettle(); // Rebuild the UI after the state change

      // Verify the order of series titles alphabetically
    final titleFinder = find.byType(Text);
    expect(titleFinder, findsWidgets);

    // Extract the displayed titles
    final titles = tester.widgetList<Text>(titleFinder).map((e) => e.data).toList();    
    bool correctOrder = titles.indexOf('Series A') < titles.indexOf('Series B') && titles.indexOf('Series B') < titles.indexOf('Series C');
    expect(correctOrder, isTrue);                   
    });
  });
}
