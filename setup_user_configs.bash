__NAME__="setup_user_configs"

function setup_user_configs() {
  declare -A local self
  self[location]="$(dirname $(readlink -f $1))"

  if [[ $XDG_CONFIG_HOME == '' ]]; then
    local XDG_CONFIG_HOME="$HOME/.config"
  fi
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
    [vim/vimrc.bundles.local]="$HOME/.vimrc.bundles.local"
    )

  local desition=''
  local backup_dir="$HOME/config-$(date +%Y/%m/%d)"
  echo -n "Make a backup into $backup_dir first? [Y/n] "; read desition
  case $desition in
      n|no|N|No)
          break
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

  for target in ${!locations[@]}; do
    ln --symbolic --interactive --no-target-directory\
      ${self[location]}/$target ${locations[$target]}
  done

  echo -n "Install vim-spf13? [y/N] "; read desition
  case $desition in
      y|yes|Y|Yes) curl http://j.mp/spf13-vim3 -L -o - | sh
          ;;
  esac

  echo -n "Append ssh-keys to authorized keys? [y/N] "; read desition
  case $desition in
      y|yes|Y|Yes)
          cat ${self[location]}/ssh/*.pub >> $HOME/.ssh/authorized_keys
          ;;
  esac
}

if [[ $0 == *setup_user_configs.bash ]]; then
  setup_user_configs $0 $*
fi
