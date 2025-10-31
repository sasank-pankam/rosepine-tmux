#!/usr/bin/env bash
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value="$(tmux show-option -gqv "$option")"

  if [ -n "$value" ]; then
    echo "$value"
  else
    echo "$default"
  fi
}

set() {
  local option=$1
  local value=$2
  tmux_commands+=(set-option -gq "$option" "$value" ";")
}

setw() {
  local option=$1
  local value=$2
  tmux_commands+=(set-window-option -gq "$option" "$value" ";")
}

main() {

  # Aggregate all commands in one array
  local tmux_commands=()

  source /dev/stdin <<<"$(sed -e "/^[^#].*=/s/^/local /" "${PLUGIN_DIR}/rosepine.tmuxtheme")"

  # status
  set status "on"
  set status-bg "${thm_base}"
  set status-justify "centre"
  set status-left ""
  set status-right ""

  # messages
  set message-style "fg=${thm_foam},bg=${thm_overlay},align=centre"
  set message-command-style "fg=${thm_foam},bg=${thm_overlay},align=centre"

  # panes
  set pane-border-style "fg=${thm_overlay}"
  set pane-active-border-style "fg=${thm_pine}"

  # windows
  setw window-status-activity-style "fg=${thm_text},bg=${thm_base},none"
  setw window-status-separator "#[fg=$thm_text] |  "
  setw window-status-style "fg=${thm_text},bg=${thm_base},none"

  # --------=== Statusline

  local show_directory
  readonly show_directory="#[fg=$thm_rose,bg=$thm_base,nobold,nounderscore,noitalics]$right_separator#[fg=$thm_base,bg=$thm_rose,nobold,nounderscore,noitalics]  #[fg=$thm_text,bg=$thm_overlay] #{b:pane_current_path} #{?client_prefix,#[fg=$thm_love]"

  local show_session
  readonly show_session="#[fg=$thm_pine]}#[bg=$thm_overlay]$right_separator#{?client_prefix,#[bg=$thm_love],#[bg=$thm_pine]}#[fg=$thm_base] #[fg=$thm_text,bg=$thm_overlay] #S "

  local show_directory_in_window_status
  readonly show_directory_in_window_status="#[fg=$thm_text,bg=$thm_overlay]#W"

  local show_directory_in_window_status_current
  readonly show_directory_in_window_status_current="#[fg=$thm_love,bg=colour237]*#W"

  local right_column2=$show_session

  local window_status_format=$show_directory_in_window_status
  local window_status_current_format=$show_directory_in_window_status_current

  setw window-status-format "${window_status_format}"
  setw window-status-current-format "${window_status_current_format}"

  # --------=== Modes
  setw mode-style "fg=${thm_rose} bg=${thm_hl_med} bold"

  tmux "${tmux_commands[@]}"
}

main "$@"
