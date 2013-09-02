#!/bin/bash
# Copyright: Milan Oberkirch, 2013 (CC BY-SA 3.0).

function setup_user_configs() {
## Setup an initial configuration for the home-directory.

  ## Set folder-variables.
  self[location]="$(dirname $(readlink -f $1))"
  # See http://standards.freedesktop.org/basedir-spec/basedir-spec-0.6.html.
  if [[ $XDG_CONFIG_HOME == '' ]]; then
    local XDG_CONFIG_HOME="$HOME/.config"
  fi
  #/>

  ## Map files in this repository to files in the users home-directory.
  declare -A local locations=(
    [xdg/xfce4]="$XDG_CONFIG_HOME/xfce4"
    [xdg/autostart]="$XDG_CONFIG_HOME/autostart"
    [xdg/awn]="$XDG_CONFIG_HOME/awn"
    [X/Xmodmap]="$HOME/.Xmodmap"
    [X/Xresources]="$HOME/.Xresources"
    [X/xinitrc]="$HOME/.xinitrc"
    [X/xprofile]="$HOME/.xprofile"
    [.bashrc]="$HOME/.bashrc"
    [vim/vimrc.local]="$HOME/.vimrc.local"
    [vim/vimrc.bundles.local]="$HOME/.vimrc.bundles.local")
  #/>

  ## Make a backup of existing files (by default).
  local desition=''
  local backup_dir="$HOME/config-$(date +%Y/%m/%d)"
  echo -n "Make a backup into $backup_dir first? [Y/n] "; read desition
  case $desition in
    n|no|N|No)
      ;;
    *)
      mkdir -p $backup_dir
      for file in ${locations[*]}; do
        if [ -e $file ]; then
          mv --no-target-directory $file $backup_dir/$(basename $file)
        fi
      done
      ;;
  esac
  #/>

  ## Create a symbolic link for each file listed in locations.
  for target in ${!locations[@]}; do
    ln --symbolic --interactive --no-target-directory\
      ${self[location]}/$target ${locations[$target]}
  done
  #/>

  ## Optionally install vim-spf13. See http://vim.spf13.com.
  echo -n "Install vim-spf13? [y/N] "; read desition
  case $desition in
    y|yes|Y|Yes) curl http://j.mp/spf13-vim3 -L -o - | sh
      ;;
  esac
  #/>

  ## Optionally grand pubkey-ssh-access to my computer(s).
  echo -n "Append ssh-keys to authorized keys? [y/N] "; read desition
  case $desition in
    y|yes|Y|Yes)
      cat ${self[location]}/ssh/*.pub >> $HOME/.ssh/authorized_keys
      ;;
  esac
  #/>
#/>
}

## Run only if called directly. Makes sourcing of this file safe.
__NAME__="setup_user_configs"
if [[ "$0" == "*${__NAME__}.bash" ]]; then
  ${__NAME__} $0 $*
fi
#/> file-settings for vim: foldmethod=marker foldmarker=##,#/> shiftwidth=2
