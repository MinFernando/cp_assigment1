import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/highest_grossing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Back button test in best movies button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BestMovieAllTime(),
    ));

    // Simulate a tap on the back button
    final backButton = find.byIcon(Icons.home); 
    await tester.tap(backButton);

    // Wait for animations to settle
    await tester.pumpAndSettle();

    // Verify that the visitProfileScreen is no longer in the navigation stack
    expect(find.byType(BestMovieAllTime), findsNothing);
    // Check if it navigated to AppHomeScreen Successfully
    expect(find.byType(AppHomeScreen), findsOneWidget);

  });
}
