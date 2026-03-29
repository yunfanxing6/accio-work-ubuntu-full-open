# Accio Work Ubuntu Full Reconstruction

This repository contains a full reconstructed Ubuntu-oriented workspace for
Accio Work.

It includes:

- the reconstructed application tree in `app/`
- Linux resource files in `resources/`
- Ubuntu packaging metadata in `packaging/`
- scripts for assembling a portable build, building a `.deb`, validating the
  runtime, and installing locally

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

## Build Flow

Assemble the portable Linux product:

```sh
npm run assemble
```

Build a Debian package:

```sh
npm run build:deb
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

## Local Desktop Installation

The local installer places the app in:

- `~/Applications/Accio`
- `~/.local/share/applications/com.accio.desktop.desktop`
- `~/Desktop/Accio Work.desktop`

It also registers the `accio://` URL scheme for the current user.

## Public Release Considerations

This repository is published as a reconstructed Ubuntu port workspace with the
authorization supplied for public release. See `NOTICE.md` for the publication
scope.
