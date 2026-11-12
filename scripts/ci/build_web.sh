#!/usr/bin/env bash
# Build the local-only web bundle. No keys or environment variables are used.
#
# Usage: scripts/ci/build_web.sh [--wasm]
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

# --wasm remains accepted for existing callers; Wasm is now the default.
if [[ $# -gt 1 || ( $# -eq 1 && "$1" != "--wasm" ) ]]; then
  echo "Usage: $0 [--wasm]" >&2
  exit 2
fi

flutter pub run powersync:setup_web
test -f web/sqlite3.wasm
test -f web/powersync_db.worker.js

echo "Compiling local-only web bundle..."
flutter build web \
  --wasm --web-content-hash \
  --dart-define=ENABLE_WEB_SEMANTICS=false

bash scripts/ci/stage_web_static.sh
echo "Built build/web"
