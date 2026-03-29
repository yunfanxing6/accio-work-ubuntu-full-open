#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_DIR="$ROOT_DIR/build"
PORTABLE_DIR="$BUILD_DIR/portable/Accio-linux-x64"
ELECTRON_DIST="$ROOT_DIR/node_modules/electron/dist"

if [ ! -x "$ELECTRON_DIST/electron" ]; then
  printf 'Missing Electron runtime. Run npm install first.\n' >&2
  exit 1
fi

rm -rf "$PORTABLE_DIR"
mkdir -p "$BUILD_DIR/portable"
cp -r "$ELECTRON_DIST" "$PORTABLE_DIR"
mv "$PORTABLE_DIR/electron" "$PORTABLE_DIR/Accio"
cp -r "$ROOT_DIR/resources/." "$PORTABLE_DIR/resources/"

npx @electron/asar pack "$ROOT_DIR/app" "$PORTABLE_DIR/resources/app.asar" --unpack-dir node_modules

cat > "$PORTABLE_DIR/run-accio.sh" <<'EOF'
#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SANDBOX_BIN="$SCRIPT_DIR/chrome-sandbox"

if [ -u "$SANDBOX_BIN" ] && [ "$(stat -c %u "$SANDBOX_BIN")" = "0" ]; then
  exec "$SCRIPT_DIR/Accio" "$@"
fi

exec "$SCRIPT_DIR/Accio" --no-sandbox "$@"
EOF

chmod +x "$PORTABLE_DIR/run-accio.sh"
printf 'Built %s\n' "$PORTABLE_DIR"
