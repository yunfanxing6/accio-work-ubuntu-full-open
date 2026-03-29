#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_DIR="$ROOT_DIR/build"
DIST_DIR="$BUILD_DIR/dist"
APPDIR="$BUILD_DIR/AppDir"
PORTABLE_DIR="$BUILD_DIR/portable/Accio-linux-x64"
TOOLS_DIR="$BUILD_DIR/tools"
APPIMAGETOOL="$TOOLS_DIR/appimagetool-x86_64.AppImage"
OUTPUT="$DIST_DIR/Accio-0.4.6-linux-x86_64.AppImage"
PROXY_URL="http://127.0.0.1:10808"

"$ROOT_DIR/scripts/assemble-portable.sh"

mkdir -p "$DIST_DIR" "$TOOLS_DIR"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/lib" "$APPDIR/usr/share/applications" "$APPDIR/usr/share/icons/hicolor/48x48/apps" "$APPDIR/usr/share/metainfo"

cp -r "$PORTABLE_DIR" "$APPDIR/usr/lib/Accio"
cp "$ROOT_DIR/packaging/com.accio.desktop.metainfo.xml" "$APPDIR/usr/share/metainfo/com.accio.desktop.metainfo.xml"
cp "$ROOT_DIR/packaging/com.accio.desktop.metainfo.xml" "$APPDIR/usr/share/metainfo/com.accio.desktop.appdata.xml"
cp "$ROOT_DIR/resources/tray-icon@3x.png" "$APPDIR/accio-work.png"
cp "$ROOT_DIR/resources/tray-icon@3x.png" "$APPDIR/.DirIcon"
cp "$ROOT_DIR/resources/tray-icon@3x.png" "$APPDIR/usr/share/icons/hicolor/48x48/apps/accio-work.png"

cat > "$APPDIR/AppRun" <<'EOF'
#!/usr/bin/env sh
set -eu

APPDIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec "$APPDIR/usr/lib/Accio/run-accio.sh" "$@"
EOF

cat > "$APPDIR/com.accio.desktop.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Accio Work
GenericName=AI Assistant
Comment=Local-first desktop AI agent for Ubuntu
TryExec=AppRun
Exec=AppRun %u
Icon=accio-work
Terminal=false
Categories=Development;
Keywords=AI;Assistant;Coding;Automation;Ecommerce;
MimeType=x-scheme-handler/accio;
StartupNotify=true
StartupWMClass=Accio
X-AppImage-Version=0.4.6
EOF

cp "$APPDIR/com.accio.desktop.desktop" "$APPDIR/usr/share/applications/com.accio.desktop.desktop"
chmod +x "$APPDIR/AppRun"

if [ ! -x "$APPIMAGETOOL" ]; then
  HTTPS_PROXY="$PROXY_URL" HTTP_PROXY="$PROXY_URL" curl -L "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -o "$APPIMAGETOOL"
  chmod +x "$APPIMAGETOOL"
fi

ARCH=x86_64 APPIMAGE_EXTRACT_AND_RUN=1 "$APPIMAGETOOL" "$APPDIR" "$OUTPUT"
chmod +x "$OUTPUT"
printf 'Built %s\n' "$OUTPUT"
