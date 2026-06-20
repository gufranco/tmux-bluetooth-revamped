# tmux-bluetooth-revamped

The connected Bluetooth device and its battery in your tmux status bar, without
ever blocking the status render.

The value is read from a tmux server user-option and returns instantly, while a
detached worker queries Bluetooth in the background. No temp files are used.

Built from
[tmux-plugin-template](https://github.com/gufranco/tmux-plugin-template).

## Placeholders

| Placeholder | Output |
|-------------|--------|
| `#{bluetooth}` | connected device and battery, for example `AirPods Pro 85%` |
| `#{bluetooth_icon}` | an icon shown only when a device is connected |

## Install

With [TPM](https://github.com/tmux-plugins/tpm):

```tmux
set -g @plugin 'gufranco/tmux-bluetooth-revamped'
set -g status-right '#{bluetooth_icon} #{bluetooth}'
```

Press `prefix + I` to install.

## Configuration

| Option | Default | Meaning |
|--------|---------|---------|
| `@bluetooth_revamped_interval` | `30` | seconds a reading stays fresh |
| `@bluetooth_revamped_format` | `%s` | format for the device string |
| `@bluetooth_revamped_icon` | `BT` | icon shown when a device is connected |
| `@bluetooth_revamped_enable_logging` | `0` | set to `1` to log under `~/.tmux/bluetooth-revamped-logs` |

## Platform support

macOS uses `system_profiler SPBluetoothDataType`. Linux uses `upower`. When no
device is connected the placeholders render empty.

## License

[MIT](LICENSE), copyright Gustavo Franco.
