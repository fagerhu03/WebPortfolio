import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'platform/browser.dart' as browser;
import 'theme/portfolio_theme.dart';
import 'pages/portfolio_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});
  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp>
    with WidgetsBindingObserver {
  ThemeMode _mode = ThemeMode.system;
  late final void Function() _stopWatching;
  late final SemanticsHandle _semantics;
  @override
  void initState() {
    super.initState();
    final saved = browser.readTheme();
    _mode = saved == 'dark'
        ? ThemeMode.dark
        : saved == 'light'
        ? ThemeMode.light
        : ThemeMode.system;
    _semantics = SemanticsBinding.instance.ensureSemantics();
    _stopWatching = browser.watchPreferences(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() => setState(() {});
  @override
  void didChangeAccessibilityFeatures() => setState(() {});
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopWatching();
    _semantics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark =
        _mode == ThemeMode.dark ||
        (_mode == ThemeMode.system &&
            (browser.prefersDark() ||
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark));
    final reduced =
        browser.prefersReducedMotion() ||
        WidgetsBinding
            .instance
            .platformDispatcher
            .accessibilityFeatures
            .disableAnimations;
    browser.setPageTheme(dark);
    return MaterialApp(
      title: 'Fager Hussein Ahmed | Flutter Developer & Software Engineer',
      debugShowCheckedModeBanner: false,
      theme: portfolioTheme(Brightness.light),
      darkTheme: portfolioTheme(Brightness.dark),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: reduced
          ? Duration.zero
          : const Duration(milliseconds: 180),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
        child: child!,
      ),
      home: PortfolioPage(
        dark: dark,
        onThemeChanged: () {
          setState(() {
            _mode = dark ? ThemeMode.light : ThemeMode.dark;
          });
          browser.saveTheme(dark ? 'light' : 'dark');
        },
      ),
    );
  }
}
