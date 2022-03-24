#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If not a child of fish, execute fish (instead)
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi

function source_folder () {
  local file=''
  if [ -d $1 ]; then
    for file in "$1"/*; do
      [ -x "$file" ] && source "$file"
    done
  fi
}

source_folder ~/user-configs/shell/bash-source.d

getVolume() {
 volumeInput=$(pactl list sinks)
 currentVolume=$(echo "${volumeInput#*Sink #$sinkNumber}" | grep -E 'V.*-left' | grep -oE '[0-9]+%' | tail -n 1)
 notify-send -t 500 "Volume: $currentVolume" &
 echo Volume: "$currentVolume"
}

alsi -n
