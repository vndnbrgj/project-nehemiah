import 'package:flutter_test/flutter_test.dart';
import 'package:project_nehemiah/main.dart';

void main() {
  testWidgets('launches the Scripture feed', (tester) async {
    await tester.pumpWidget(const NehemiahApp());

    expect(find.text('Be still.'), findsOneWidget);
    expect(find.text('PROJECT NEHEMIAH'), findsOneWidget);
  });
}
