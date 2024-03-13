import 'package:cp_assignment/screens/app_home_screen.dart';
import 'package:cp_assignment/screens/best_movies_this_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  setUpAll(() async {
    // Initialize Firebase app
    await Firebase.initializeApp();
  });

  testWidgets('Navigates back to the previous screen on back icon button tap', (WidgetTester tester) async {
    // Mock FirebaseAuth instance
    final mockFirebaseAuth = MockFirebaseAuth();
    when(mockFirebaseAuth.currentUser).thenAnswer((_) => null); // Set up mock behavior

    // Create a MaterialApp with the BestMoviesThisYear screen
    await tester.pumpWidget(MaterialApp(
      home: BestMoviesThisYear(),
    ));

    // Verify that the BestMoviesThisYear screen is displayed
    expect(find.byType(BestMoviesThisYear), findsOneWidget);

    // Tap the back icon button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(); 

    // Verify that the AppHomeScreen is displayed after navigating back
    expect(find.byType(AppHomeScreen), findsOneWidget);
  });
}
