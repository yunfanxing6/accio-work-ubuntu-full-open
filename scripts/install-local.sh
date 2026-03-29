#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PORTABLE_DIR="$ROOT_DIR/build/portable/Accio-linux-x64"
APP_DIR="$HOME/Applications/Accio"
DESKTOP_FILE="$HOME/.local/share/applications/com.accio.desktop.desktop"
DESKTOP_SHORTCUT="$HOME/Desktop/Accio Work.desktop"

"$ROOT_DIR/scripts/assemble-portable.sh"

mkdir -p "$HOME/Applications" "$HOME/.local/share/applications"
rm -rf "$APP_DIR"
cp -r "$PORTABLE_DIR" "$APP_DIR"
chmod +x "$APP_DIR/run-accio.sh"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Accio Work
GenericName=AI Assistant
Comment=Local-first desktop AI agent for Ubuntu
TryExec=$APP_DIR/run-accio.sh
Exec=$APP_DIR/run-accio.sh %u
Icon=$APP_DIR/resources/tray-icon@3x.png
Terminal=false
Categories=Development;
Keywords=AI;Assistant;Coding;Automation;Ecommerce;
MimeType=x-scheme-handler/accio;
StartupNotify=true
StartupWMClass=Accio
EOF

cp "$DESKTOP_FILE" "$DESKTOP_SHORTCUT"
chmod 644 "$DESKTOP_FILE"
chmod +x "$DESKTOP_SHORTCUT"

update-desktop-database "$HOME/.local/share/applications" || true
xdg-settings set default-url-scheme-handler accio com.accio.desktop.desktop || true
gio set "$DESKTOP_SHORTCUT" metadata::trusted true || true

printf 'Installed to %s\n' "$APP_DIR"
printf 'Desktop launcher: %s\n' "$DESKTOP_SHORTCUT"
