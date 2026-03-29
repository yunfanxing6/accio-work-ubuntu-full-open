# Architecture Notes

## Runtime Shape

The reconstructed application is a packaged Electron desktop app with three
main runtime layers:

- main process bundles under `app/out/main/`
- preload bundles under `app/out/preload/`
- renderer bundles under `app/out/renderer/`

## Native Components

The Ubuntu port depends on Linux-native variants of several native modules:

- `better-sqlite3`
- `sqlite-vec`
- `sharp`
- `@napi-rs/canvas`

These were rebuilt or replaced for Linux and validated against the Electron
runtime ABI used by the product.

## Resources

Additional runtime resources live in `resources/`, including:

- tray icons
- browser extension assets
- update metadata
- external tool version metadata

## Packaging Direction

The Ubuntu packaging layer adds:

- a desktop file
- AppStream metadata
- Debian maintainer scripts
- icon installation
- a wrapper launcher
