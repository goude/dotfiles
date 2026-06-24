#!/usr/bin/env bash
# Show-desktop toggle for the waybar button (labwc / wlroots).
#
# Uses wlrctl (foreign-toplevel protocol) — labwc has no action-trigger CLI,
# so the bar talks to toplevels directly. Stateless: reads the real window
# state each click, so it stays correct even if windows changed in between.
#
#   any window visible      -> minimise them all   (show the desktop)
#   all windows minimised   -> focus/activate them (reveal them again)
#
# Depends on: wlrctl (apt). Layer-shell surfaces (waybar, wallpaper) are not
# toplevels, so they are never touched.
if wlrctl toplevel find state:unminimized; then
  wlrctl toplevel minimize state:unminimized
else
  wlrctl toplevel focus state:minimized
fi
