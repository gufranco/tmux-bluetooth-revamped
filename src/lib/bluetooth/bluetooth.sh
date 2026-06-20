#!/usr/bin/env bash
#
# bluetooth.sh: connected device name and battery acquisition.
#
# Pure parsers turn probe output into a "<name> <battery>" string. Readers wrap
# the host probes behind seams that tests override.

[[ -n "${_BLUETOOTH_REVAMPED_BLUETOOTH_LOADED:-}" ]] && return 0
_BLUETOOTH_REVAMPED_BLUETOOTH_LOADED=1

_BT_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${_BT_LIB_DIR}/../utils/platform.sh"
# shellcheck source=/dev/null
source "${_BT_LIB_DIR}/../utils/has-command.sh"

# bt_parse_macos TEXT -> "<name> <battery%>" for the first connected device.
bt_parse_macos() {
  printf '%s\n' "${1}" | awk '
    /Connected:/ { inconn = 1; next }
    inconn && /^[[:space:]]+[A-Za-z0-9].*:[[:space:]]*$/ {
      name = $0
      sub(/:[[:space:]]*$/, "", name)
      gsub(/^[[:space:]]+/, "", name)
    }
    inconn && /Battery Level:/ {
      v = $0
      sub(/.*Battery Level:[[:space:]]*/, "", v)
      print name " " v
      exit
    }
  '
}

# bt_parse_linux TEXT -> "<model> <percentage>" for the first device with both.
bt_parse_linux() {
  printf '%s\n' "${1}" | awk '
    /model:/ { m = $0; sub(/.*model:[[:space:]]*/, "", m) }
    /percentage:/ {
      p = $0; sub(/.*percentage:[[:space:]]*/, "", p)
      if (m != "") { print m " " p; exit }
    }
  '
}

# Host-probe seams.
_read_bt_macos() { system_profiler SPBluetoothDataType 2>/dev/null; }
_read_bt_linux() { upower --dump 2>/dev/null; }

# read_bluetooth -> "<name> <battery>", empty when nothing is connected.
read_bluetooth() {
  if is_macos; then
    bt_parse_macos "$(_read_bt_macos)"
  elif is_linux && has_command upower; then
    bt_parse_linux "$(_read_bt_linux)"
  fi
}

export -f bt_parse_macos
export -f bt_parse_linux
export -f _read_bt_macos
export -f _read_bt_linux
export -f read_bluetooth
