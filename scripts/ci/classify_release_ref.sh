#!/usr/bin/env bash
# Classify a GitHub ref for the public Release workflow.
#
#   classify_release_ref.sh <github.ref> <github.ref_name>
#
# Prints `kind=stable|preview|none` for Actions (`>> $GITHUB_OUTPUT`).
# A tag that is neither vX.Y.Z nor vX.Y.Z-test fails closed.
set -euo pipefail

REF="${1:?usage: $0 <ref> <ref_name>}"
REF_NAME="${2:?usage: $0 <ref> <ref_name>}"

if [[ "$REF" != refs/tags/* ]]; then
  echo "kind=none"
  exit 0
fi

if [[ "$REF_NAME" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "kind=stable"
  exit 0
fi

if [[ "$REF_NAME" =~ ^v[0-9]+\.[0-9]+\.[0-9]+-test$ ]]; then
  echo "kind=preview"
  exit 0
fi

echo "Unrecognized release tag '$REF_NAME'. Use vX.Y.Z or vX.Y.Z-test." >&2
exit 1
