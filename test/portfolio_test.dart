import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fager_flutter_portfolio/main.dart';
import 'package:fager_flutter_portfolio/data/portfolio_data.dart';
import 'package:fager_flutter_portfolio/widgets/phone_gallery.dart';
import 'package:fager_flutter_portfolio/theme/portfolio_theme.dart';

void main() {
  for (final size in [
    const Size(320, 740),
    const Size(390, 844),
    const Size(768, 1024),
    const Size(1440, 1000),
  ]) {
    testWidgets('All sections fit ${size.width.toInt()}px without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await tester.pumpWidget(const PortfolioApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final scroll = tester
          .widget<SingleChildScrollView>(
            find.byType(SingleChildScrollView).first,
          )
          .controller!;
      for (
        double y = 0;
        y <= scroll.position.maxScrollExtent;
        y += size.height * .8
      ) {
        scroll.jumpTo(y);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'Overflow at scroll $y');
      }
      expect(find.text('GPA 3.24 / 4.00'), findsOneWidget);
      expect(find.text('AI-Based Chatbot'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('Mobile navigation reaches contact; theme switches both ways', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();
    final initial = Theme.of(tester.element(find.byType(Scaffold))).brightness;
    await tester.tap(find.byKey(const ValueKey('theme-toggle')));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      isNot(initial),
    );
    await tester.tap(find.byKey(const ValueKey('theme-toggle')));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.byType(Scaffold))).brightness, initial);
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Let’s talk').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Gallery wraps, labels real screenshots and supports keyboard', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: portfolioTheme(Brightness.dark),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: PhoneGallery(project: featuredProject, phoneWidth: 160),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Home & discovery'), findsOneWidget);
    await tester.tap(find.byTooltip('Next Lost in Egypt screenshot'));
    await tester.pumpAndSettle();
    expect(find.text('AI camera'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Map exploration'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Next Lost in Egypt screenshot'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Home & discovery'), findsOneWidget);
    await tester.tap(find.byTooltip('Previous Lost in Egypt screenshot'));
    await tester.pumpAndSettle();
    expect(find.text('Tours'), findsOneWidget);
  });

  testWidgets('Two-times text scaling fits a mobile screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('Only supplied repository links and sourced screenshots are listed', () {
    expect(
      [featuredProject, ...mobileProjects].map((p) => p.repository).toSet(),
      {
        '$github/lost_in_egypt',
        '$github/islami',
        '$github/My_Shopping',
        '$github/petalview_nasa_spaceapp',
        '$github/movie_app',
      },
    );
    expect(otherProjects.every((p) => p.repository == null), isTrue);
    expect(featuredProject.screenshots.length, 6);
  });
}
