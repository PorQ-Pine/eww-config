#!/usr/bin/env bash

module="$1"
state_var="open_${module}"
ANIM_DURATION=0.5
modules=(control_center date power_menu profile_selector)

open_module() {
  (
    if ! eww list-windows | grep -q "*${module}"; then
      eww open "$module"
      sleep 0.05
    fi
    eww update "$state_var=true"

    for mod in "${modules[@]}"; do
      [[ "$mod" != "$module" ]] && eww update "open_${mod}=false"
    done

    (
      sleep $ANIM_DURATION
      for mod in "${modules[@]}"; do
        [[ "$mod" != "$module" ]] && eww close "$mod"
      done
    ) &
  ) &
}

close_module() {
  (
    eww update "$state_var=false"
    (
      sleep $ANIM_DURATION
      eww close "$module"
    ) &
  ) &
}

(
  current=$(eww get "$state_var")
  if [[ "$current" == "true" ]]; then
    close_module
  else
    open_module
  fi
) &

exit 0
