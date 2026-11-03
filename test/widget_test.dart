import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:coffee_card/main.dart';
import 'package:coffee_card/providers/app_provider.dart';

void main() {
  testWidgets('CoffeeHubApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: const CoffeeHubApp(),
      ),
    );

    // Initial Splash Screen displays CoffeeHub
    expect(find.textContaining('Coffee'), findsWidgets);
  });
}
