# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-19

### Added

- Bluetooth placeholders: `#{bluetooth}` and `#{bluetooth_icon}`.
- Non-blocking design: the device query runs in a background worker and the value
  is read from a tmux user-option, with no temp files.
- macOS via `system_profiler`, Linux via `upower`.
- Empty output when no device is connected.
