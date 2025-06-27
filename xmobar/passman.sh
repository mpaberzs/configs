#!/usr/bin/env bash

# TODO: make usable with other pass managers
if op whoami > /dev/null 2>&1 ; then
  echo "<action='/home/martins/.config/xmobar/passmanactionlock.sh'></action>";
else
  echo "<action='/home/martins/.config/xmobar/passmanaction.sh'></action>";
fi
