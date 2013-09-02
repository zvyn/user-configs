#!/bin/bash
# Copyright: Milan Oberkirch, 2013 (CC BY-SA 3.0).

function clone_setup() {
## Clone user-configs from github and run setup.
  echo -n Clone user-configs to $HOME/config and run setup? [y/N]\ 
  local desition=''
  read desition
  case $desition in
    y|yes|Y|Yes)
      set -e
      git clone https://github.com/zvyn/user-configs.git $HOME/config
      ($HOME/config/setup_user_configs.bash)
      ;;
    *)
      return 1
      ;;
  esac
#/>
}

## Run always! Useful for piping into bash but unwanted when being sourced.
__NAME__="clone_setup"
${__NAME__} $0 $*
#/> file-settings for vim: foldmethod=marker foldmarker=##,#/> shiftwidth=2
