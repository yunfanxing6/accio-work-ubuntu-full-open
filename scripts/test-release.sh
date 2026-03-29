#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PORTABLE_DIR="$ROOT_DIR/build/portable/Accio-linux-x64"
DEB_PATH="$ROOT_DIR/build/dist/accio-work_0.4.6_amd64.deb"
TMP_JS="$ROOT_DIR/build/native-module-check.cjs"
EXTRACT_DIR=$(mktemp -d)

cleanup() {
  rm -f "$TMP_JS"
  rm -rf "$EXTRACT_DIR"
}

trap cleanup EXIT

"$ROOT_DIR/scripts/build-deb.sh"

desktop-file-validate "$ROOT_DIR/packaging/com.accio.desktop.desktop"
appstreamcli validate --pedantic "$ROOT_DIR/packaging/com.accio.desktop.metainfo.xml"

dpkg-deb -x "$DEB_PATH" "$EXTRACT_DIR"
desktop-file-validate "$EXTRACT_DIR/usr/share/applications/com.accio.desktop.desktop"
appstreamcli validate --pedantic "$EXTRACT_DIR/usr/share/metainfo/com.accio.desktop.metainfo.xml"

python3 - <<'PY'
import subprocess

listing = subprocess.check_output(['dpkg-deb', '-c', 'build/dist/accio-work_0.4.6_amd64.deb'], text=True)
required = {
    './opt/Accio/chrome-sandbox': '-rwsr-xr-x',
    './usr/bin/accio-work': '-rwxr-xr-x',
    './usr/share/applications/com.accio.desktop.desktop': '-rw-r--r--',
    './usr/share/metainfo/com.accio.desktop.metainfo.xml': '-rw-r--r--',
}
seen = {}
for line in listing.splitlines():
    parts = line.split()
    if len(parts) < 6:
        continue
    path = parts[-1]
    if path in required:
        seen[path] = parts[0]
missing = [path for path in required if path not in seen]
if missing:
    raise SystemExit('Missing files in .deb: ' + ', '.join(missing))
bad = [f'{path}={seen[path]}' for path, mode in required.items() if seen[path] != mode]
if bad:
    raise SystemExit('Unexpected .deb file modes: ' + ', '.join(bad))
print('.deb payload check OK')
PY

python3 - <<'PY'
from pathlib import Path
root = Path('build/portable/Accio-linux-x64')
mach = []
for p in root.rglob('*'):
    if not p.is_file():
        continue
    try:
        with p.open('rb') as f:
            magic = f.read(4)
    except OSError:
        continue
    if magic in {b'\xcf\xfa\xed\xfe', b'\xfe\xed\xfa\xcf', b'\xca\xfe\xba\xbe', b'\xbe\xba\xfe\xca'}:
        mach.append(str(p))
if mach:
    raise SystemExit('Found Mach-O leftovers:\n' + '\n'.join(mach))
print('Mach-O scan OK')
PY

cat > "$TMP_JS" <<'EOF'
const { createRequire } = require('node:module');
const req = createRequire(process.cwd() + '/build/portable/Accio-linux-x64/resources/app.asar/package.json');

(async () => {
  const DB = req('better-sqlite3');
  const vec = req('sqlite-vec');
  const db = new DB(':memory:');
  db.loadExtension(vec.getLoadablePath());
  const row = db.prepare('select vec_version() as v').get();
  if (!row || !row.v) throw new Error('sqlite-vec extension did not return a version');
  db.close();

  const sharp = req('sharp');
  const png = await sharp(Buffer.from('<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"><rect width="1" height="1" fill="red"/></svg>')).png().toBuffer();
  if (!png.length) throw new Error('sharp returned an empty buffer');

  const canvas = req('@napi-rs/canvas');
  if (typeof canvas.createCanvas !== 'function') throw new Error('canvas binding unavailable');

  console.log('Native module check OK');
})().catch((error) => {
  console.error(error && error.stack ? error.stack : error);
  process.exit(1);
});
EOF

ELECTRON_RUN_AS_NODE=1 "$PORTABLE_DIR/Accio" "$TMP_JS"

python3 - <<'PY'
import json
import subprocess
import time
import urllib.request

proc = subprocess.Popen(['build/portable/Accio-linux-x64/run-accio.sh'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
try:
    results = {}
    deadline = time.time() + 20
    while time.time() < deadline and len(results) < 3:
        for name, url in {
            'gateway_catalog': 'http://127.0.0.1:4097/skills/catalog',
            'relay_version': 'http://127.0.0.1:9236/json/version',
            'relay_list': 'http://127.0.0.1:9236/json/list',
        }.items():
            if name in results:
                continue
            try:
                with urllib.request.urlopen(url, timeout=1) as response:
                    results[name] = {'status': response.status}
            except Exception as exc:
                if hasattr(exc, 'code'):
                    results[name] = {'status': exc.code}
        time.sleep(0.5)
    print(json.dumps(results, ensure_ascii=True, indent=2))
finally:
    proc.terminate()
    try:
        out = proc.communicate(timeout=5)[0]
    except subprocess.TimeoutExpired:
        proc.kill()
        out = proc.communicate()[0]
    if 'ready-to-show' not in out:
        raise SystemExit('App did not reach ready-to-show state')
    print('Startup probe OK')
PY

printf 'Full reconstructed release validation passed\n'
