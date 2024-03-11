import 'package:cp_assignment/screens/AppHomeScreen.dart';
import 'package:cp_assignment/screens/VisitProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Back button test in VisitProfileScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: VisitProfileScreen(),
    ));

    // Simulate a tap on the back button
    final backButton = find.byIcon(Icons.arrow_back); 
    await tester.tap(backButton);

    // Wait for animations to settle
    await tester.pumpAndSettle();

    // Verify that the visitProfileScreen is no longer in the navigation stack
    expect(find.byType(VisitProfileScreen), findsNothing);
    // Check if it navigated to AppHomeScreen Successfully
    expect(find.byType(AppHomeScreen), findsOneWidget);

  });
}
