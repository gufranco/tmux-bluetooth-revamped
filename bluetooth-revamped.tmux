#!/usr/bin/env bash
#
# bluetooth-revamped.tmux: TPM entry point.
#
# Replaces the #{bluetooth} and #{bluetooth_icon} placeholders in status-left and
# status-right with calls to the dispatcher, which reads cached values.

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BT_CMD="${PLUGIN_DIR}/src/bluetooth.sh"

placeholders=(
  "\#{bluetooth}"
  "\#{bluetooth_icon}"
)

commands=(
  "#(${BT_CMD} device)"
  "#(${BT_CMD} icon)"
)

interpolate() {
  local value="${1}"
  local i
  for (( i = 0; i < ${#placeholders[@]}; i++ )); do
    value="${value//${placeholders[i]}/${commands[i]}}"
  done
  echo "${value}"
}

update_option() {
  local option="${1}"
  local current
  current=$(tmux show-option -gqv "${option}")
  tmux set-option -gq "${option}" "$(interpolate "${current}")"
}

chmod +x "${BT_CMD}" 2>/dev/null || true

update_option "status-left"
update_option "status-right"
