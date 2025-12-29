import 'package:flutter_test/flutter_test.dart';

import 'package:rust_ui_designer/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RustUIDesignerApp());

    // Verify that the app title is displayed.
    expect(find.text('Rust UI Visual Designer'), findsOneWidget);

    // Verify that the toolbox is present.
    expect(find.text('Toolbox'), findsOneWidget);
  });
}
