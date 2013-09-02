#!/bin/bash
# Copyright: Milan Oberkirch, 2013 (CC BY-SA 3.0).

function clone_setup() {
## Clone user-configs from github and run setup.
  echo Clone user-configs to config and run setup-script? [y/N]\ 
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

## Run only if called directly. Makes sourcing of this file safe.
if [ ! $__NAME__ ]; then
  __NAME__=$(basename --suffix=.bash $0)
  if [[ $(type -t ${__NAME__}) == function ]]; then
    ${__NAME__} $0 $*
  fi
fi
#/> file-settings for vim: foldmethod=marker foldmarker=##,#/> shiftwidth=2
