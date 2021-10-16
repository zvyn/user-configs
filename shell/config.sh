#
# ~/config/shell_profile
#

## Functions
## pip freeze
clean_freeze () {
  local venv=$(mktemp -d) && \
  python3.7 -m venv $venv && \
  source $venv/bin/activate && \
  pip install -r requirements.txt && \
  freeze && \
  deactivate && \
  rm -r $venv
}
#/>
## colors
changeColor () {
  ## Usage
  local help_message="\
Usage:
  changeColor ((fg|bg|light|light-bg)? color (bold|dim|underlined|inverted)*)+
Example:
  changeColor fg red light-bg green underlined bold"
  #/>

  ## local properties
  local codes='0;'
  local prefix=3
  local color=''
  local format=''
  #/>

  ## parse command-line
  while [[ $1 ]]; do
    case $1 in
      -h|--help)
        echo -e "$help_message"
        return 0;;
      fg)
        prefix=3;;
      bg)
        prefix=4;;
      light)
        prefix=9;;
      light-bg)
        prefix=10;;
      black)
        color=0;;
      red)
        color=1;;
      green)
        color=2;;
      yellow)
        color=3;;
      blue)
        color=4;;
      magenta)
        color=5;;
      cyan)
        color=6;;
      gray)
        color=7;;
      bold)
        format="1;";;
      dim)
        format="2;";;
      underlined)
        format="4;";;
      blink)
        format="5;";;
      inverted)
        format="7;";;
    esac
    codes+="$format"
    if [[ "$color" ]]; then
      codes+="${prefix}${color};"
    fi
    shift
  done
  #/>
  echo -en "\e[${codes%?}m"
}

padWithEscape () {
  echo -en "\[$*\]"
}

paddedColor () {
  echo -n $(padWithEscape $(changeColor $*))
}
#/>

## Personal Hacks & Backups

## auen
if [[ $HOSTNAME = "auen" ]]; then
  alias rsync_local='test -d /data/backup/current/ &&\
    command sudo rsync /home/milan/ /data/backup/current/home/milan/\
    --one-file-system\
    --exclude="Musik"\
    --exclude="Trash/"\
    --exclude=".dropbox/"\
    --exclude="Dropbox/"\
    --exclude=".cache/"\
    --exclude=".mozilla/firefox/kvxo3xoe.default/Cache/"\
    --archive\
    --partial --progress\
    --delete --delete-excluded  # safe with snapshots'
  alias rsync_küche='command rsync /home/milan/\
    --rsh="ssh" root@webtop:/mnt/milan/\
    --one-file-system\
    --exclude=".Private/"\
    --exclude="Musik"\
    --exclude="Trash/"\
    --exclude=".dropbox/"\
    --exclude="Dropbox/"\
    --exclude=".cache/"\
    --exclude=".mozilla/firefox/kvxo3xoe.default/Cache/"\
    --archive --inplace\
    --partial --progress\
    --delete --delete-excluded\
    --backup --backup-dir="../deleted/$(date +%Y/%m/%d)"\
    --stats'
  pull_programm_folders () {
    local IFS=$'\n'
    for i in $(ls ~/Programme); do
      cd "$i"
      echo -en "${_COLOR_DEFAULT} Checking $_COLOR_WHITE $i $_COLOR_DEFAULT..."
      if [ -d .git ]; then
        echo -en "$_COLOR_GREEN pull:"
        echo -e "$_COLOR_DEFAULT"
        git pull
      else
        echo -e "$_COLOR_RED not a git-repository"
      fi
      cd ~/Programme
    done
    echo -e "$_COLOR_DEFAULT"
  }
fi
#/>

# list all module-options
list_mod_parameters ()
{
  local N=/dev/null;
  local C=`tput op` O=$(echo -en "\n`tput setaf 2`>>> `tput op`");
  local mod
  local mc
  for mod in $(cat /proc/modules|cut -d" " -f1);
  do
    local md=/sys/module/$mod/parameters;
    [[ ! -d $md ]] && continue;
    local m=$mod;
    local d=`modinfo -d $m 2>$N | tr "\n" "\t"`;
    echo -en "$O$m$C";
    [[ ${#d} -gt 0 ]] && echo -n " - $d";
    echo;
    for mc in $(cd $md; echo *);
    do
      local de=`modinfo -p $mod 2>$N | grep ^$mc 2>$N|sed "s/^$mc=//" 2>$N`;
      echo -en "\t$mc=`cat $md/$mc 2>$N`";
      [[ ${#de} -gt 1 ]] && echo -en " - $de";
      echo;
    done;
  done
}

# Mounts cryptdevices with fstab-entries (defaults to 500GB-HDD on auenland)
cryptmount() {
  if [[ $# == 0 ]]; then
    sudo umount /data/media/Musik
    cryptmount /dev/sda1 data
    bindMusic
  else
    if zenity --password | sudo cryptsetup luksOpen $1 $2; then
      mount /dev/mapper/$2 || sudo mount /dev/mapper/$2
    else
      local error=$?
      if [[ $error == 5 ]]; then
        sudo umount /dev/mapper/$2
        sudo umount /dev/mapper/$2
        sudo cryptsetup luksClose $2 &&\
          zenity --info --text="Device '$2' locked."
      elif [[ $error == 2 ]]; then
        cryptmount $1 $2
      elif [[ $error != 1 ]]; then
        zenity --error --text="An error occoured: $?"
      fi
    fi
  fi
}

bindMusic () {
  sudo mount --bind /data/media/Musik /home/milan/Musik
}

#/>

## 3-Liners

say () {
  for word in $*
  do mpv http://ssl.gstatic.com/dictionary/static/sounds/de/0/$word.mp3
  done
}

psgrep () {
  ps aux | grep -e $1
}

wiki () {
  search=`echo $@ | sed -e 's/ /_/g'`
  dig +short txt $search.wp.dg.cx
}

playFreq () {
  f=$1;echo "int s=16e3/$f;main(i){unsigned char v[s];read(0,v,s);for(;;)putchar(v[i%s]=(v[i%s]+v[++i%s])/2);}"|gcc -x c -&&./a.out</dev/urandom|aplay -d 2
}
# remind me, its important!
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
function remindme() {
sleep $1 && (zenity --info --text "$2" || echo "$2") &
}
#/>

## (Un-)Pack
# Unpacks Archives inplace
function unpack() {
if [ -f $1 ]; then
  case $1 in
    *.tar.bz2|*.tbz2)
      tar xvfj $1
      ;;
    *.tar.gz|*.tgz)
      tar xvfz $1
      ;;
    *.bz2)
      bzip2 -d $1
      ;;
    *.rar)
      unrar x $1
      ;;
    *.gz)
      gzip -d $1
      ;;
    *.tar)
      tar xvf $1
      ;;
    *.zip)
      unzip $1
      ;;
    *.Z)
      compress -d $1
      ;;
    *.7z)
      7z x $1
      ;;
    *)
      echo  "Cannot extract \"$1\" via unpack()"
      ;;
  esac
else
  echo "\"$1\" is not a valid file"
fi
}

#Archive einpacken:
function pack() {
ERROR=true
if [ -d $2 ]; then
  ERROR=false
fi
if [ -f $2 ]; then
  ERROR=false
fi
if [ "$ERROR" = "false" ]; then
  case $1 in
    *.tar.bz2|*.tbz2)
      tar cvfj $1 $2
      ;;
    *.tar.gz|.*tgz)
      tar cvfz $1 $2
      ;;
    *.bz2)
      bzip2 --stdout $2 >$1
      ;;
    *.gz)
      gzip -r --stdout $2 >$1
      ;;
    *.tar)
      tar cvf $1 $2
      ;;
    *.zip)
      zip -r $1 $2
      ;;
    *.Z)
      compress --stdout $2 >$1
      ;;
    *.7z)
      7z a $1 $2
      ;;
    *)
      echo "Cannot pack \"$1\" with pack()"
  esac
else
  echo "Cannot pack \"$2\" with pack()"
fi
}
#/>

## sudo magic
function se () {
  name=$1
  shift
  case $(type -t $name) in
    'alias')
      # A naïve 'alias $name | cut -d"'" -f2' wouldn't handle "'"s correctly.
      eval sudo $(type $name | cut -f 2- -d'`' | head -c -2 ) $@
      ;;
    'function')
      sudo sh -c "export $(type $name | tail -n +1); $name $@"
      ;;
    *)
      sudo $name $@
      ;;
  esac
}
#/>

#/>

((_HOME_CONFIG_SHELL_PROFILE_+=1))
export _HOME_CONFIG_SHELL_PROFILE_

#modeline for vim: foldmethod=marker foldmarker=##,#/> tabstop=2 shiftwidth=2
