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
