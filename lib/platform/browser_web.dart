import 'dart:js_interop';
import 'package:web/web.dart' as web;

const _themeKey = 'fager-portfolio-theme';

void openUrl(String url) {
  final uri = Uri.parse(url);
  // Ensure all web links (http/https) open in a new tab
  if (uri.scheme == 'https' || uri.scheme == 'http') {
    web.window.open(url, '_blank', 'noopener,noreferrer');
  } else {
    // mailto and other schemes usually happen in the background or trigger apps
    web.window.location.href = url;
  }
}

String? readTheme() {
  try {
    return web.window.localStorage.getItem(_themeKey);
  } catch (_) {
    return null;
  }
}

void saveTheme(String value) {
  try {
    web.window.localStorage.setItem(_themeKey, value);
  } catch (_) {}
}

bool prefersReducedMotion() =>
    web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
bool prefersDark() =>
    web.window.matchMedia('(prefers-color-scheme: dark)').matches;
void Function() watchPreferences(void Function() changed) {
  final queries = [
    web.window.matchMedia('(prefers-reduced-motion: reduce)'),
    web.window.matchMedia('(prefers-color-scheme: dark)'),
  ];
  final listener = ((web.Event event) {
    changed();
  }).toJS;
  for (final query in queries) {
    query.addEventListener('change', listener);
  }
  return () {
    for (final query in queries) {
      query.removeEventListener('change', listener);
    }
  };
}

String currentSection() => web.window.location.hash.replaceFirst('#', '');
void setSection(String section) {
  web.window.history.replaceState(null, '', '#$section');
}

void setPageTheme(bool dark) {
  web.document.documentElement?.setAttribute(
    'data-theme',
    dark ? 'dark' : 'light',
  );
  web.document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute('content', dark ? '#0A1128' : '#F4F7FA');
}
