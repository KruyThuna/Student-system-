// Widget test for the App Ecommerce product list.

import 'package:flutter_test/flutter_test.dart';

import 'package:app_ecom/main.dart';

void main() {
  testWidgets('Product list shows items and can open tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Smart Watch'), findsOneWidget);
    expect(find.text('Wireless Earbuds'), findsOneWidget);
    expect(find.text('Travel Backpack'), findsOneWidget);
    expect(find.text('Running Shoes'), findsOneWidget);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About App Ecommerce'), findsOneWidget);
  });
}
