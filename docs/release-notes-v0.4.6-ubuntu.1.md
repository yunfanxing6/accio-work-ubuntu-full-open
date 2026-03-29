# Accio Work Ubuntu v0.4.6-ubuntu.1

## 中文

这是 `Accio Work` 的 Ubuntu 重构发布版本，目标是把上游桌面包整理成更完整的 Linux 产品形态，并提供可重复的构建、发布与验证流程。

本次发布包含：

- `accio-work_0.4.6_amd64.deb`
- `Accio-0.4.6-linux-x86_64.AppImage`
- `Accio-0.4.6-linux-x64-portable.tar.gz`
- `SHA256SUMS.txt`

本次发布亮点：

- 使用 Linux 原生 Electron 运行时
- 替换并验证 Linux 原生模块：`better-sqlite3`、`sqlite-vec`、`sharp`、`@napi-rs/canvas`
- 提供 Ubuntu 桌面集成：桌面入口、图标、AppStream 元数据、`accio://` 协议注册
- 提供 `.deb`、`AppImage`、便携包三种发布形态
- 提供完整验证流程，覆盖启动、原生模块、gateway、browser relay、桌面元数据与安装包结构

验证结果：

- `desktop-file-validate`：通过
- `appstreamcli validate --pedantic`：通过
- 原生模块运行时加载：通过
- gateway / browser relay 启动探测：通过
- 应用启动并到达 `ready-to-show`：通过
- `.deb` 安装、启动、卸载、清理：通过

说明：

- 该版本是 Ubuntu 原生运行与原生打包意义上的 Linux 版本
- 应用技术栈仍为 Electron，并非 GTK / Qt 重写

## English

This is the Ubuntu reconstruction release of `Accio Work`, focused on turning the upstream desktop package into a more complete Linux product workflow with reproducible build, release, and validation steps.

This release includes:

- `accio-work_0.4.6_amd64.deb`
- `Accio-0.4.6-linux-x86_64.AppImage`
- `Accio-0.4.6-linux-x64-portable.tar.gz`
- `SHA256SUMS.txt`

Highlights:

- Linux-native Electron runtime
- Linux-native replacement and validation for `better-sqlite3`, `sqlite-vec`, `sharp`, and `@napi-rs/canvas`
- Ubuntu desktop integration with launcher, icons, AppStream metadata, and `accio://` protocol registration
- Three release shapes: `.deb`, `AppImage`, and portable tarball
- End-to-end validation covering startup, native modules, gateway, browser relay, desktop metadata, and package structure

Validation status:

- `desktop-file-validate`: pass
- `appstreamcli validate --pedantic`: pass
- native module runtime loading: pass
- gateway / browser relay startup probe: pass
- application reached `ready-to-show`: pass
- `.deb` install, launch, uninstall, and purge cleanup: pass

Notes:

- This is a Linux-native Ubuntu release in packaging and runtime terms
- The application stack remains Electron, not a GTK or Qt rewrite
