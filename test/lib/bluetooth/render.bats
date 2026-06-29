#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../helpers.bash"

setup() {
  setup_test_environment
  unset _BLUETOOTH_REVAMPED_RENDER_LOADED
  source "${BATS_TEST_DIRNAME}/../../../src/lib/bluetooth/render.sh"
}

teardown() {
  cleanup_test_environment
}

@test "render.sh - bluetooth_render_device is empty on cold start" {
  [[ -z "$(bluetooth_render_device "")" ]]
}

@test "render.sh - bluetooth_render_device uses the default format" {
  [[ "$(bluetooth_render_device "AirPods 85%")" == "AirPods 85%" ]]
}

@test "render.sh - bluetooth_render_device honors a custom format" {
  set_tmux_option "@bluetooth_revamped_format" "BT %s"
  [[ "$(bluetooth_render_device "AirPods 85%")" == "BT AirPods 85%" ]]
}

@test "render.sh - bluetooth_render_device joins multiple devices" {
  local txt=$'AirPods 85%\nMagic Mouse 50%'
  [[ "$(bluetooth_render_device "${txt}")" == "AirPods 85%, Magic Mouse 50%" ]]
}

@test "render.sh - bluetooth_render_device honors a custom separator" {
  set_tmux_option "@bluetooth_revamped_separator" " | "
  local txt=$'AirPods 85%\nMouse 50%'
  [[ "$(bluetooth_render_device "${txt}")" == "AirPods 85% | Mouse 50%" ]]
}

@test "render.sh - bluetooth_render_icon is empty when nothing is connected" {
  [[ -z "$(bluetooth_render_icon "")" ]]
}

@test "render.sh - bluetooth_render_icon returns the default icon" {
  [[ "$(bluetooth_render_icon "AirPods 85%")" == "BT" ]]
}

@test "render.sh - bluetooth_render_icon honors a custom icon" {
  set_tmux_option "@bluetooth_revamped_icon" "BLE"
  [[ "$(bluetooth_render_icon "AirPods 85%")" == "BLE" ]]
}

@test "render.sh - bluetooth_render_count is 0 with nothing connected" {
  [[ "$(bluetooth_render_count "")" == "0" ]]
}

@test "render.sh - bluetooth_render_count counts a single device" {
  [[ "$(bluetooth_render_count "AirPods 85%")" == "1" ]]
}

@test "render.sh - bluetooth_render_count counts multiple devices" {
  local txt=$'AirPods 85%\nMagic Mouse 50%\nKeychron K2'
  [[ "$(bluetooth_render_count "${txt}")" == "3" ]]
}

@test "render.sh - bluetooth_render_min is empty with nothing connected" {
  [[ -z "$(bluetooth_render_min "")" ]]
}

@test "render.sh - bluetooth_render_min returns the only device" {
  [[ "$(bluetooth_render_min "AirPods 85%")" == "AirPods 85%" ]]
}

@test "render.sh - bluetooth_render_min picks the lowest battery device" {
  local txt=$'AirPods 85%\nMagic Mouse 20%\nKeyboard 60%'
  [[ "$(bluetooth_render_min "${txt}")" == "Magic Mouse 20%" ]]
}

@test "render.sh - bluetooth_render_min ignores devices with no battery" {
  local txt=$'Keychron K2\nAirPods 30%'
  [[ "$(bluetooth_render_min "${txt}")" == "AirPods 30%" ]]
}

@test "render.sh - bluetooth_render_min is empty when no device reports battery" {
  local txt=$'Keychron K2\nMagic Trackpad'
  [[ -z "$(bluetooth_render_min "${txt}")" ]]
}
