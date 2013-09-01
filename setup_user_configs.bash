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
    )

  for target in ${!locations[@]}; do
    ln -s ${self[location]}/$target ${locations[$target]}
  done

  cat ${self[location]}/ssh/* >> $HOME/.ssh/authorized_keys
}

setup_user_configs $0
