#
# ~/.bashrc
#

function source_folder () {
  local file=''
  if [ -d $1 ]; then
    for file in "$1"/*; do
      [ -x "$file" ] && source "$file"
    done
  fi
}

source_folder ~/Private/Config/shell/bash-source.d
