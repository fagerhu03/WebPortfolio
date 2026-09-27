#!/usr/bin/env bash
set -euo pipefail
# Pin the same SDK used to test this portfolio. The Vercel build image has Git.
SDK_DIR="${VERCEL_FLUTTER_SDK_DIR:-/tmp/fager-flutter-3.38.7}"
if [ ! -x "$SDK_DIR/bin/flutter" ]; then
  git clone --depth 1 --branch 3.38.7 https://github.com/flutter/flutter.git "$SDK_DIR"
fi
export PATH="$SDK_DIR/bin:$PATH"
flutter --version
flutter pub get
flutter build web --release --no-web-resources-cdn --pwa-strategy=none
