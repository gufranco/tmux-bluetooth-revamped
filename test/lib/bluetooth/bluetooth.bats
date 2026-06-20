#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

MACOS_BT=$'Bluetooth:\n    Connected:\n        AirPods Pro:\n            Address: 00-11\n            Battery Level: 85%\n'
LINUX_BT=$'Device: /org/freedesktop/UPower/devices/headset\n  model:               WH-1000XM4\n  percentage:          80%\n'

setup() {
  setup_test_environment
  unset _BLUETOOTH_REVAMPED_BLUETOOTH_LOADED
  source "${BATS_TEST_DIRNAME}/../../../src/lib/bluetooth/bluetooth.sh"
}

teardown() {
  cleanup_test_environment
}

@test "bluetooth.sh - bt_parse_macos reads name and battery" {
  [[ "$(bt_parse_macos "${MACOS_BT}")" == "AirPods Pro 85%" ]]
}

@test "bluetooth.sh - bt_parse_macos is empty with nothing connected" {
  [[ -z "$(bt_parse_macos "Bluetooth:\n    Not Connected:")" ]]
}

@test "bluetooth.sh - bt_parse_linux reads model and percentage" {
  [[ "$(bt_parse_linux "${LINUX_BT}")" == "WH-1000XM4 80%" ]]
}

@test "bluetooth.sh - bt_parse_linux is empty without a model" {
  [[ -z "$(bt_parse_linux "percentage: 50%")" ]]
}

@test "bluetooth.sh - bt_parse_macos enumerates every connected device" {
  local txt=$'Bluetooth:\n    Connected:\n        AirPods Pro:\n            Battery Level: 85%\n        Magic Mouse:\n            Battery Level: 50%\n'
  run bt_parse_macos "${txt}"
  [[ "${lines[0]}" == "AirPods Pro 85%" ]]
  [[ "${lines[1]}" == "Magic Mouse 50%" ]]
}

@test "bluetooth.sh - bt_parse_linux enumerates every device" {
  local txt=$'model: WH-1000XM4\npercentage: 80%\nmodel: MX Master\npercentage: 40%\n'
  run bt_parse_linux "${txt}"
  [[ "${lines[0]}" == "WH-1000XM4 80%" ]]
  [[ "${lines[1]}" == "MX Master 40%" ]]
}

@test "bluetooth.sh - read_bluetooth uses system_profiler on macOS" {
  _PLATFORM_OS_CACHE="Darwin"
  _read_bt_macos() { printf '%s' "${MACOS_BT}"; }
  [[ "$(read_bluetooth)" == "AirPods Pro 85%" ]]
}

@test "bluetooth.sh - read_bluetooth uses upower on Linux" {
  _PLATFORM_OS_CACHE="Linux"
  has_command() { return 0; }
  _read_bt_linux() { printf '%s' "${LINUX_BT}"; }
  [[ "$(read_bluetooth)" == "WH-1000XM4 80%" ]]
}

@test "bluetooth.sh - read_bluetooth is empty without upower on Linux" {
  _PLATFORM_OS_CACHE="Linux"
  has_command() { return 1; }
  [[ -z "$(read_bluetooth)" ]]
}
