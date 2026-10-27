import 'package:flutter_test/flutter_test.dart';
import 'package:taskmate/main.dart';

void main() {
  testWidgets('TaskMate app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskMateApp());

    expect(find.text('TaskMate'), findsOneWidget);
  });
}