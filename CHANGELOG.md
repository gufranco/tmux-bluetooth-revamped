# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-06-23

### Changed

- Self-audit for the family hardening pass. Device detection works on both macOS
  and Linux, and the segment colors are named colors that survive the tmux 3.7
  format-expansion change. No code change needed.

## [1.1.0] - 2026-06-20

### Added

- Enumerate every connected Bluetooth device, joined by a configurable separator,
  instead of only the first device.

## [1.0.0] - 2026-06-19

### Added

- Bluetooth placeholders: `#{bluetooth}` and `#{bluetooth_icon}`.
- Non-blocking design: the device query runs in a background worker and the value
  is read from a tmux user-option, with no temp files.
- macOS via `system_profiler`, Linux via `upower`.
- Empty output when no device is connected.
