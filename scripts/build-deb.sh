#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_ROOT="$ROOT_DIR/build/deb-root"
DIST_DIR="$ROOT_DIR/build/dist"
PORTABLE_DIR="$ROOT_DIR/build/portable/Accio-linux-x64"

"$ROOT_DIR/scripts/assemble-portable.sh"

rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT/DEBIAN" "$BUILD_ROOT/opt/Accio" "$BUILD_ROOT/usr/bin" "$BUILD_ROOT/usr/share/applications" "$BUILD_ROOT/usr/share/metainfo" "$BUILD_ROOT/usr/share/pixmaps" "$BUILD_ROOT/usr/share/icons/hicolor/16x16/apps" "$BUILD_ROOT/usr/share/icons/hicolor/32x32/apps" "$BUILD_ROOT/usr/share/icons/hicolor/48x48/apps"
mkdir -p "$DIST_DIR"

cp -r "$PORTABLE_DIR/." "$BUILD_ROOT/opt/Accio/"
cp "$ROOT_DIR/packaging/control" "$BUILD_ROOT/DEBIAN/control"
cp "$ROOT_DIR/packaging/postinst" "$BUILD_ROOT/DEBIAN/postinst"
cp "$ROOT_DIR/packaging/postrm" "$BUILD_ROOT/DEBIAN/postrm"
cp "$ROOT_DIR/packaging/com.accio.desktop.desktop" "$BUILD_ROOT/usr/share/applications/com.accio.desktop.desktop"
cp "$ROOT_DIR/packaging/com.accio.desktop.metainfo.xml" "$BUILD_ROOT/usr/share/metainfo/com.accio.desktop.metainfo.xml"
cp "$PORTABLE_DIR/resources/tray-icon.png" "$BUILD_ROOT/usr/share/icons/hicolor/16x16/apps/accio-work.png"
cp "$PORTABLE_DIR/resources/tray-icon@2x.png" "$BUILD_ROOT/usr/share/icons/hicolor/32x32/apps/accio-work.png"
cp "$PORTABLE_DIR/resources/tray-icon@3x.png" "$BUILD_ROOT/usr/share/icons/hicolor/48x48/apps/accio-work.png"
cp "$PORTABLE_DIR/resources/tray-icon@3x.png" "$BUILD_ROOT/usr/share/pixmaps/accio-work.png"

cat > "$BUILD_ROOT/usr/bin/accio-work" <<'EOF'
#!/usr/bin/env sh
set -eu

exec /opt/Accio/run-accio.sh "$@"
EOF

chmod 4755 "$BUILD_ROOT/opt/Accio/chrome-sandbox"
chmod 755 "$BUILD_ROOT/usr/bin/accio-work" "$BUILD_ROOT/DEBIAN/postinst" "$BUILD_ROOT/DEBIAN/postrm"
chmod 644 "$BUILD_ROOT/usr/share/applications/com.accio.desktop.desktop" "$BUILD_ROOT/usr/share/metainfo/com.accio.desktop.metainfo.xml"

dpkg-deb --root-owner-group --build "$BUILD_ROOT" "$DIST_DIR/accio-work_0.4.6_amd64.deb"
printf 'Built %s\n' "$DIST_DIR/accio-work_0.4.6_amd64.deb"
