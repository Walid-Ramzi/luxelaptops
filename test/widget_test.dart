import 'package:flutter_test/flutter_test.dart';
import 'package:luxelaptops/main.dart';

void main() {
  testWidgets('App boots with web home', (tester) async {
    await tester.pumpWidget(const LuxeLaptopsApp());
    await tester.pump();
    expect(find.text('LuxeLaptops'), findsOneWidget);
  });
}
