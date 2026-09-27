import 'package:flutter/material.dart';

@immutable
class PortfolioColors extends ThemeExtension<PortfolioColors> {
  const PortfolioColors({
    required this.background,
    required this.surface,
    required this.raised,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
    required this.indigo,
    required this.softAccent,
    required this.shadow,
  });
  final Color background,
      surface,
      raised,
      line,
      text,
      muted,
      accent,
      indigo,
      softAccent,
      shadow;
  static const dark = PortfolioColors(
    background: Color(0xFF0A1128),
    surface: Color(0xFF101F42),
    raised: Color(0xFF1C2D5A),
    line: Color(0xFF2E4374),
    text: Color(0xFFF4F7FC),
    muted: Color(0xFF94A3B8),
    accent: Color(0xFF60A5FA),
    indigo: Color(0xFF93C5FD),
    softAccent: Color(0xFF1E3A8A),
    shadow: Color(0x50000000),
  );
  static const light = PortfolioColors(
    background: Color(0xFFF4F7FA),
    surface: Color(0xFFFFFFFF),
    raised: Color(0xFFEBF1F9),
    line: Color(0xFFD0DCED),
    text: Color(0xFF0F172A),
    muted: Color(0xFF475569),
    accent: Color(0xFF2563EB),
    indigo: Color(0xFF1D4ED8),
    softAccent: Color(0xFFEFF6FF),
    shadow: Color(0x121A3450),
  );
  @override
  PortfolioColors copyWith({
    Color? background,
    Color? surface,
    Color? raised,
    Color? line,
    Color? text,
    Color? muted,
    Color? accent,
    Color? indigo,
    Color? softAccent,
    Color? shadow,
  }) => PortfolioColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    raised: raised ?? this.raised,
    line: line ?? this.line,
    text: text ?? this.text,
    muted: muted ?? this.muted,
    accent: accent ?? this.accent,
    indigo: indigo ?? this.indigo,
    softAccent: softAccent ?? this.softAccent,
    shadow: shadow ?? this.shadow,
  );
  @override
  PortfolioColors lerp(covariant PortfolioColors? other, double t) {
    if (other == null) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return PortfolioColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      raised: mix(raised, other.raised),
      line: mix(line, other.line),
      text: mix(text, other.text),
      muted: mix(muted, other.muted),
      accent: mix(accent, other.accent),
      indigo: mix(indigo, other.indigo),
      softAccent: mix(softAccent, other.softAccent),
      shadow: mix(shadow, other.shadow),
    );
  }
}

extension PortfolioContext on BuildContext {
  PortfolioColors get colors => Theme.of(this).extension<PortfolioColors>()!;
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}

ThemeData portfolioTheme(Brightness brightness) {
  final p = brightness == Brightness.dark
      ? PortfolioColors.dark
      : PortfolioColors.light;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: p.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.accent,
      brightness: brightness,
      primary: p.accent,
      onPrimary: brightness == Brightness.dark
          ? const Color(0xFFFFFFFF)
          : Colors.white,
      surface: p.surface,
      onSurface: p.text,
    ),
    extensions: [p],
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    dividerColor: p.line,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: p.text,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: p.background),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 50),
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 17),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.text,
        minimumSize: const Size(48, 50),
        side: BorderSide(color: p.line),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.text,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
         ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: p.text,
      ),
    ),
    focusColor: p.accent.withValues(alpha: .22),
    hoverColor: p.accent.withValues(alpha: .08),
  );
}
