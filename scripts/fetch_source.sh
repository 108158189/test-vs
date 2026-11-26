#!/usr/bin/env bash
# Fetch the encrypted source bundle and unpack it into the ephemeral runner workspace.
# No URLs, credentials or source files are stored in this repository.
set -euo pipefail

: "${BUNDLE_URL:?SOURCE_BUNDLE_URL secret is missing}"
: "${BUNDLE_KEY:?SOURCE_BUNDLE_KEY secret is missing}"
: "${GITHUB_ENV:?must run inside GitHub Actions}"
: "${RUNNER_TEMP:?must run inside GitHub Actions}"

DEST="${RUNNER_TEMP}/vsdj-src"
mkdir -p "$DEST"

curl -fsSL --retry 3 --connect-timeout 20 "$BUNDLE_URL" -o "${RUNNER_TEMP}/bundle.tar.enc"

openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -md sha256 \
  -pass env:BUNDLE_KEY \
  -in "${RUNNER_TEMP}/bundle.tar.enc" \
  -out "${RUNNER_TEMP}/bundle.tar"

tar -xf "${RUNNER_TEMP}/bundle.tar" -C "$DEST"
rm -f "${RUNNER_TEMP}/bundle.tar" "${RUNNER_TEMP}/bundle.tar.enc"

if [ ! -f "${DEST}/CMakeLists.txt" ]; then
  echo "source bundle is missing CMakeLists.txt" >&2
  exit 1
fi

echo "SRC=${DEST}" >> "${GITHUB_ENV}"
echo "source bundle unpacked into runner temp workspace"
