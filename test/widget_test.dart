import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_aid/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame with required parameter
    await tester.pumpWidget(const MyApp(showOnboarding: true));
    
    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}