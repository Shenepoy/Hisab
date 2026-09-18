#!/usr/bin/env bash
# Public FOSS must be able to install its own GitHub APKs.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MAIN="$ROOT/android/app/src/main/AndroidManifest.xml"
FOSS="$ROOT/android/app/src/foss/AndroidManifest.xml"

fail() {
  echo "$1" >&2
  exit 1
}

[[ -f "$MAIN" ]] || fail "missing main manifest"
[[ -f "$FOSS" ]] || fail "missing foss manifest"
if grep -q 'REQUEST_INSTALL_PACKAGES' "$MAIN"; then
  fail "public main manifest must not request package installs"
fi
grep -q 'REQUEST_INSTALL_PACKAGES' "$FOSS" || fail "foss must request package installs"
grep -q 'apkupdate' "$FOSS" || fail "foss must declare the APK FileProvider"
echo "Public FOSS update manifests look correct"
