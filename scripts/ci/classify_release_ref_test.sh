#!/usr/bin/env bash
# Regression tests for public release tag classification.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/ci/classify_release_ref.sh"

fail() {
  echo "❌ $*" >&2
  exit 1
}

expect_kind() {
  local ref="$1" name="$2" expected="$3"
  local got
  got="$("$SCRIPT" "$ref" "$name")" || fail "expected success for $name"
  [[ "$got" == "kind=$expected" ]] || fail "expected kind=$expected for $name, got $got"
}

expect_fail() {
  if "$SCRIPT" "$1" "$2" >/dev/null 2>&1; then
    fail "expected rejection for $2"
  fi
}

expect_kind refs/heads/main main none
expect_kind refs/heads/release/v1 release/v1 none
expect_kind refs/tags/v0.8.0 v0.8.0 stable
expect_kind refs/tags/v0.8.0-test v0.8.0-test preview

expect_fail refs/tags/v0.8.0-test.3 v0.8.0-test.3
expect_fail refs/tags/v0.8.0-rc1 v0.8.0-rc1
expect_fail refs/tags/v0.8 v0.8
expect_fail refs/tags/v0.8.0-TEST v0.8.0-TEST
expect_fail refs/tags/v1.2.3-test-extra v1.2.3-test-extra

echo "✅ Release ref classification tests passed"
