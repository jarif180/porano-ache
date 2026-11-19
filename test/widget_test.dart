import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porano_ache/app.dart';

void main() {
  testWidgets('App renders login screen with Porano Ache branding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PoranoAcheApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify app title in Bangla is displayed
    expect(find.text('পড়ানো আছে'), findsOneWidget);
  });
}
