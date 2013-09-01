#!/bin/bash
#
# ~/.xinitrc
#

#region source
[ -f /etc/xprofile ] && source /etc/xprofile

# source files in xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f ~/.xprofile ] && source ~/.xprofile
#endregion

if [ $1 ]; then
  exec $@
else
  exec xfce4-session
fi
