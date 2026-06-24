<div align="center">

<h1>tmux-bluetooth-revamped</h1>

**Every connected Bluetooth device and its battery in your tmux status bar, without blocking the render.**

[![Tests](https://github.com/tmux-revamped/tmux-bluetooth-revamped/actions/workflows/tests.yml/badge.svg)](https://github.com/tmux-revamped/tmux-bluetooth-revamped/actions/workflows/tests.yml) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![Version](https://img.shields.io/badge/version-1.1.1-blue.svg)](CHANGELOG.md)

</div>

**2** placeholders · **2** platforms · **76** tests · **95%+** coverage

The value is read from a tmux server user-option and returns instantly, while a detached worker queries Bluetooth in the background. No temp files are used. Every connected device is listed, joined by a configurable separator.

Built from [tmux-plugin-template](https://github.com/tmux-revamped/tmux-plugin-template).

<table>
<tr>
<td><b>Non-blocking</b><br>The status render reads a cached tmux user-option and returns instantly.</td>
<td><b>No temp files</b><br>State lives in a tmux server user-option, never on disk.</td>
</tr>
<tr>
<td><b>Every device</b><br>Lists all connected devices and their battery, joined by a configurable separator.</td>
<td><b>Tested</b><br>76 tests with 95%+ coverage across both platforms.</td>
</tr>
</table>

## Placeholders

| Placeholder | Output |
|-------------|--------|
| `#{bluetooth}` | connected devices and battery, joined, for example `AirPods 85%, Mouse 50%` |
| `#{bluetooth_icon}` | an icon shown only when a device is connected |

## Install

With [TPM](https://github.com/tmux-plugins/tpm):

```tmux
set -g @plugin 'tmux-revamped/tmux-bluetooth-revamped'
set -g status-right '#{bluetooth_icon} #{bluetooth}'
```

Press `prefix + I` to install.

## Configuration

| Option | Default | Meaning |
|--------|---------|---------|
| `@bluetooth_revamped_interval` | `30` | seconds a reading stays fresh |
| `@bluetooth_revamped_format` | `%s` | format for the device string |
| `@bluetooth_revamped_separator` | `, ` | separator between multiple devices |
| `@bluetooth_revamped_icon` | `BT` | icon shown when a device is connected |
| `@bluetooth_revamped_enable_logging` | `0` | set to `1` to log under `~/.tmux/bluetooth-revamped-logs` |

## Support by platform and architecture

| Platform | Supported |
|----------|-----------|
| macOS (Intel and Apple Silicon) | yes, built-in `system_profiler` |
| Linux (x86_64 and arm64) | yes, with `upower` installed |

macOS needs no extra package. On Linux, install `upower`. When no device is
connected the placeholders render empty. Every connected device is listed, joined by the configurable separator.

## Development

```sh
make test
make lint
make coverage
```

## License

[MIT](LICENSE), copyright Gustavo Franco.
