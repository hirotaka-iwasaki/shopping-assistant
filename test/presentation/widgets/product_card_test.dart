import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_assistant/core/core.dart';
import 'package:shopping_assistant/data/data.dart';
import 'package:shopping_assistant/presentation/presentation.dart';

void main() {
  // Helper to wrap widgets in a sized container for testing
  Widget wrapInSizedBox(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 200,
          height: 400,
          child: child,
        ),
      ),
    );
  }

  group('ProductCard', () {
    testWidgets('displays product title', (tester) async {
      final product = Product(
        id: 'test-1',
        title: 'Test Product Title',
        price: 1000,
        imageUrl: '',
        productUrl: 'https://example.com',
        source: EcSource.amazon,
      );

      await tester.pumpWidget(wrapInSizedBox(
        SingleChildScrollView(child: ProductCard(product: product)),
      ));

      expect(find.text('Test Product Title'), findsOneWidget);
    });

    testWidgets('displays formatted price', (tester) async {
      final product = Product(
        id: 'test-2',
        title: 'Test Product',
        price: 12345,
        imageUrl: '',
        productUrl: 'https://example.com',
        source: EcSource.rakuten,
      );

      await tester.pumpWidget(wrapInSizedBox(
        SingleChildScrollView(child: ProductCard(product: product)),
      ));

      // Effective price and base price are both displayed
      expect(find.text('¥12,345'), findsWidgets);
    });

    testWidgets('displays source badge', (tester) async {
      final product = Product(
        id: 'test-4',
        title: 'Test Product',
        price: 1000,
        imageUrl: '',
        productUrl: 'https://example.com',
        source: EcSource.amazon,
      );

      await tester.pumpWidget(wrapInSizedBox(
        SingleChildScrollView(child: ProductCard(product: product)),
      ));

      expect(find.byType(SourceBadge), findsOneWidget);
      expect(find.text('Amazon'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      final product = Product(
        id: 'test-6',
        title: 'Test Product',
        price: 1000,
        imageUrl: '',
        productUrl: 'https://example.com',
        source: EcSource.yahoo,
      );

      await tester.pumpWidget(wrapInSizedBox(
        SingleChildScrollView(
          child: ProductCard(
            product: product,
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.byType(ProductCard));
      expect(tapped, true);
    });
  });

  group('SourceBadge', () {
    testWidgets('displays Amazon badge correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SourceBadge(source: EcSource.amazon),
          ),
        ),
      );

      expect(find.text('Amazon'), findsOneWidget);
    });

    testWidgets('displays Rakuten badge correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SourceBadge(source: EcSource.rakuten),
          ),
        ),
      );

      expect(find.text('楽天'), findsOneWidget);
    });

    testWidgets('displays Yahoo badge correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SourceBadge(source: EcSource.yahoo),
          ),
        ),
      );

      expect(find.text('Yahoo!'), findsOneWidget);
    });
  });

  group('LoadingIndicator', () {
    testWidgets('displays message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(message: 'Loading...'),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('ErrorDisplay', () {
    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(message: 'Something went wrong'),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (tester) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplay(
              message: 'Error',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('再試行'), findsOneWidget);

      await tester.tap(find.text('再試行'));
      expect(retried, true);
    });
  });

  group('EmptyDisplay', () {
    testWidgets('displays message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(message: 'No results found'),
          ),
        ),
      );

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('displays custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyDisplay(
              message: 'Empty',
              icon: Icons.inbox,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });
  });
}
