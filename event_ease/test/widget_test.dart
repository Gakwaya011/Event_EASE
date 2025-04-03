// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_ease/main.dart';

void main() {
  testWidgets('Check if Login button exists', (WidgetTester tester) async {
    // Load the app
    await tester.pumpWidget(const MyApp());

    // Check if the "Login" button appears
    expect(find.text('Login'), findsOneWidget);
  });
}
