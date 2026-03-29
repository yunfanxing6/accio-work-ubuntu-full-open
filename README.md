# Accio Work Ubuntu Port

An Ubuntu-first reconstruction of Accio Work that turns the packaged desktop
release into a Linux-native product workflow: buildable, installable,
testable, and ready to publish.

It includes:

- the reconstructed application tree in `app/`
- Linux resource files in `resources/`
- Ubuntu packaging metadata in `packaging/`
- scripts for assembling a portable build, creating a `.deb`, creating an
  `AppImage`, validating the runtime, installing locally, and preparing release
  assets

## Why This Exists

The upstream desktop release was packaged for another platform. This workspace
reconstructs a practical Ubuntu delivery layer around that release so the app
can behave like a real Linux product:

- Linux ELF runtime
- Linux-native native modules
- Ubuntu desktop launcher integration
- `accio://` protocol registration
- `.deb` packaging
- `AppImage` packaging
- repeatable validation on Ubuntu

## What This Repository Is

This is not the original upstream TypeScript monorepo. It is a reconstructed
runtime workspace derived from an authorized upstream desktop release and then
adapted for Ubuntu.

That means the code here is primarily:

- compiled Electron main-process and renderer bundles
- vendored runtime dependencies from the packaged app
- Linux-native replacements for native modules where required
- Ubuntu packaging and validation tooling

## Highlights

- full reconstructed `app/` tree ready for Linux packaging
- portable Linux assembly from a pinned Electron runtime
- Debian packaging with desktop file, icons, AppStream metadata, and maintainer scripts
- user-local installation for desktop testing
- automated runtime validation on Ubuntu
- release asset generation for `.deb`, `AppImage`, and portable archive outputs

## Ubuntu Product Goal

The goal is to deliver a Linux-native Ubuntu product in the packaging and
runtime sense:

- Linux ELF executables
- Linux-native native addons
- Ubuntu desktop launcher integration
- `accio://` protocol registration
- Debian package generation
- runtime validation on Ubuntu

The app itself remains an Electron application rather than a GTK or Qt rewrite.

## Repository Layout

- `app/` - reconstructed application code and runtime dependencies
- `resources/` - tray icons, browser extension payload, update config, and extra runtime resources
- `packaging/` - Debian control files, desktop file, AppStream metadata, maintainer scripts
- `scripts/assemble-portable.sh` - produces `build/portable/Accio-linux-x64/`
- `scripts/build-deb.sh` - produces `build/dist/accio-work_0.4.6_amd64.deb`
- `scripts/build-appimage.sh` - produces `build/dist/Accio-0.4.6-linux-x86_64.AppImage`
- `scripts/install-local.sh` - installs the built app into the current user's desktop environment
- `scripts/test-release.sh` - validates the reconstructed Linux release end to end

## Prerequisites

- Ubuntu or compatible Linux
- `npm`
- `dpkg-deb`
- `desktop-file-validate`
- `appstreamcli`

Install the local build toolchain:

```sh
npm install
```

## Outputs

The standard scripts generate:

- `build/portable/Accio-linux-x64/`
- `build/dist/accio-work_0.4.6_amd64.deb`

Release asset packaging also generates:

- `build/dist/Accio-0.4.6-linux-x86_64.AppImage`
- `build/dist/Accio-0.4.6-linux-x64-portable.tar.gz`
- `build/dist/SHA256SUMS.txt`

## Build Flow

Assemble the portable Linux product:

```sh
npm run assemble
```

Build a Debian package:

```sh
npm run build:deb
```

Build an AppImage:

```sh
npm run build:appimage
```

Build release assets for GitHub or manual distribution:

```sh
npm run build:release-assets
```

Validate the reconstructed release:

```sh
npm test
```

Install for the current user:

```sh
npm run install:local
```

## Validation Coverage

The validation script checks:

- desktop entry validity
- AppStream metadata validity
- Debian package payload permissions
- absence of Mach-O leftovers in the Linux build
- Electron ABI compatibility of native modules
- `better-sqlite3`, `sqlite-vec`, `sharp`, and `@napi-rs/canvas`
- local gateway startup
- browser relay startup
- successful `ready-to-show` application startup

## Release Workflow

Typical Ubuntu release flow:

1. `npm install`
2. `npm test`
3. `npm run build:release-assets`
4. publish `build/dist/*` to GitHub Releases or another distribution channel

## Local Desktop Installation

The local installer places the app in:

- `~/Applications/Accio`
- `~/.local/share/applications/com.accio.desktop.desktop`
- `~/Desktop/Accio Work.desktop`

It also registers the `accio://` URL scheme for the current user.

## Release Artifacts

The packaged outputs target two common Ubuntu delivery modes:

- `.deb` for system package installation and desktop integration
- `AppImage` for a single-file portable Linux release
- portable tarball for user-local unpack-and-run distribution

Both artifacts are produced from the same reconstructed app tree and validated
against the same runtime checks.

## Public Release Considerations

This repository is published as a reconstructed Ubuntu port workspace with the
authorization supplied for public release. See `NOTICE.md` for the publication
scope.
