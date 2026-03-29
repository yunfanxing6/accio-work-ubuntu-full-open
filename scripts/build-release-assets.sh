#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST_DIR="$ROOT_DIR/build/dist"
PORTABLE_PARENT="$ROOT_DIR/build/portable"
PORTABLE_NAME="Accio-linux-x64"

"$ROOT_DIR/scripts/build-deb.sh"

mkdir -p "$DIST_DIR"
tar czf "$DIST_DIR/Accio-0.4.6-linux-x64-portable.tar.gz" -C "$PORTABLE_PARENT" "$PORTABLE_NAME"

(
  cd "$DIST_DIR"
  sha256sum "accio-work_0.4.6_amd64.deb" "Accio-0.4.6-linux-x64-portable.tar.gz" > "SHA256SUMS.txt"
)

printf 'Built %s\n' "$DIST_DIR/Accio-0.4.6-linux-x64-portable.tar.gz"
printf 'Built %s\n' "$DIST_DIR/SHA256SUMS.txt"
