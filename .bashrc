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

source_folder ~/user-configs/shell/bash-source.d

getVolume() {
 volumeInput=$(pactl list sinks)
 currentVolume=$(echo "${volumeInput#*Sink #$sinkNumber}" | grep -E 'V.*-left' | grep -oE '[0-9]+%' | tail -n 1)
 notify-send -t 500 "Volume: $currentVolume" &
 echo Volume: "$currentVolume"
}

alsi -n
