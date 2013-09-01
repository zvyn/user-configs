__NAME__="setup_user_configs"

function setup_user_configs() {
  declare -A local self=(
    [name]="$__NAME__"
    [location]="$(dirname $(readlink -f $1))"
    )

  if [[ $XDG_CONFIG_HOME == '' ]]; then
    local XDG_CONFIG_HOME="$HOME/.config"
  fi
  declare -A local locations=(
    [xfce4]="$XDG_CONFIG_HOME/xfce4"
    [autostart]="$XDG_CONFIG_HOME/autostart"
    [awn]="$XDG_CONFIG_HOME/awn"
    [Xmodmap]="$HOME/.Xmodmap"
    [Xresources]="$HOME/.Xresources"
    [xinitrc]="$HOME/.xinitrc"
    [xprofile]="$HOME/.xprofile"
    [.bashrc]="$HOME/.bashrc"
    [vim/vimrc.local]="$HOME/.vimrc.local"
    [vim/vimrc.bundles.local]="$HOME/.vimrc.bundles.local"
    )

  for target in ${!locations[@]}; do
    ln --symbolic --interactive --no-target-directory\
      ${self[location]}/$target ${locations[$target]}
  done

  cat ${self[location]}/ssh/* >> $HOME/.ssh/authorized_keys
}

if [[ $0 == *setup_user_configs.bash ]]; then
  setup_user_configs $0 $*
fi
