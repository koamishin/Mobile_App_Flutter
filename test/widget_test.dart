import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:school_app/main.dart';

void main() {
  testWidgets('Home cards open pages and floating navigation stays off home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-home')), findsNothing);

    await tester.ensureVisible(find.byKey(const ValueKey('home-view-grades')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-view-grades')));
    await tester.pumpAndSettle();
    expect(
      find.text('Track your scores and subject progress.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('nav-home')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-balance')));
    await tester.pumpAndSettle();
    expect(find.text('Tuition Balance'), findsOneWidget);
    expect(find.text('Payment History'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-attend')));
    await tester.pumpAndSettle();
    expect(
      find.text('Your weekly presence and class check-ins.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('nav-schedule')));
    await tester.pumpAndSettle();
    expect(
      find.text('Today\'s classes and important reminders.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-home')), findsNothing);
  });
}
