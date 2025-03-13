#!/usr/bin/env bash

set -e
set -u

id=$(aerospace list-windows --all --json | jq '.[] | select(."app-name" == "WezTerm" or ."app-name" == "wezterm-gui" )."window-id"')
space=$(aerospace list-workspaces --focused)

focused=$(aerospace list-windows --focused --json | jq '.[] | select(."app-name" == "WezTerm" or ."app-name" == "wezterm-gui" )."window-id"')

if [[ -z "${id}" ]]; then
  # terminal is not open or is it hidden
  /usr/bin/osascript -e 'tell application "WezTerm" to reopen'
  sleep 0.5
  id=$(aerospace list-windows --all --json | jq '.[] | select(."app-name" == "WezTerm" or ."app-name" == "wezterm-gui" )."window-id"')
  aerospace move-node-to-workspace --window-id $id $space
  aerospace focus --window-id $id
  aerospace layout floating --window-id $id
else
  if [[ "${id}" -eq "${focused}" ]]; then
    # terminal is currently focused, minimize it 
    aerospace macos-native-minimize --window-id $id
  else
    # terminal is open but not focused, focus it
    aerospace move-node-to-workspace --window-id $id $space
    aerospace focus --window-id $id
    aerospace layout floating --window-id $id
  fi
fi
