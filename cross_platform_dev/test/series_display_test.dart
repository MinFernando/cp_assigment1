import 'package:cp_assignment/screens/content_initializing.dart';
import 'package:cp_assignment/screens/series_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    // Initialize Firebase once before all tests
    await Firebase.initializeApp();
  });

  testWidgets('Sort by Title in TV List Screen', (WidgetTester tester) async {
    // Mock TV series data
    List<TVSeries> mockSeries = [
      TVSeries(title: 'Series B', releaseDate: '2022-02-01', imagePath: 'http://example.com/b.jpg', rating: '', overview: ''),
      TVSeries(title: 'Series A', releaseDate: '2022-01-01', imagePath: 'http://example.com/a.jpg', rating: '', overview: ''),
      TVSeries(title: 'Series C', releaseDate: '2022-03-01', imagePath: 'http://example.com/c.jpg', rating: '', overview: ''),
    ];

    await tester.pumpWidget(MaterialApp(
      home: ListSeries(series: mockSeries),
    ));

    await tester.pumpAndSettle(); // Wait for the widget to settle

    // Tap the "Sort by Title" icon button
    await tester.tap(find.byIcon(Icons.sort_by_alpha));
    await tester.pumpAndSettle(); 

    // Verify the order of series titles alphabetically
    final titleFinder = find.byType(Text);
    expect(titleFinder, findsWidgets);

    // Extract the displayed titles
    final titles = tester.widgetList<Text>(titleFinder).map((e) => e.data).toList();    
    bool correctOrder = titles.indexOf('Series A') < titles.indexOf('Series B') && titles.indexOf('Series B') < titles.indexOf('Series C');
    expect(correctOrder, isTrue);                   
  });
}
