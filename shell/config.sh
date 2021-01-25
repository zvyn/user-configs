#
# ~/config/shell_profile
#

## Enovirenment-Variables
## locals:
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_TIME="de_DE.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_MONETARY="de_DE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export MM_CHARSET="de_DE.UTF-8"
#/>

export HISTIGNORE="&:ls:[bf]g:exit: *:reboot:poweroff"
export HISTFILE="$HOME/.histfile"
export HISTSIZE=5000
export SAVEHIST=5000
export GOPATH=$HOME/go
export PATH="/usr/lib/colorgcc/bin:$PATH:/home/milan/Programme/bin:/home/milan/.gem/ruby/2.0.0/bin:$GOPATH/bin"
export EDITOR="vim"
export LS_COLORS='di=01;36:*.zip=33:*.tar=33:*.tar.gz=33:*.tar.bz2=33:*.jpg=35:*.JPG=35:*.jpeg=35:*.JPEG=35:*.PNG=35:*.png=35:*.rar=33:*.ico=35:*.gif=35:*.svg=35:*.xcf=35:*.cpp=31:*.h=31:*.rkt=31'
export QEMU_AUDIO_DRV=pa
export CDPATH=~/Code
export PIP_REQUIRE_VIRTUALENV=1
#/>

## Aliases
alias nat='netctl-auto switch-to'
alias nal='netctl-auto list'
alias nac='netctl-auto current'
alias ssh_w3h='command ssh wshaend@www.haendel.uni-freiburg.de'
alias ssh_info='command ssh oberkirm@login.informatik.uni-freiburg.de'
alias ssh_rz='command ssh mo54@login.uni-freiburg.de'
alias ssh_home='command ssh -p 41 m@o-desktop.homeip.net'
alias ssh_küche='command ssh -Y root@shell.oberkirch.org'
alias ssh_lfs='command ssh root@stp.ruf.uni-freiburg.de'
alias qemu_squash='qemu-system-x86_64 -soundhw hda -m 3G -kernel kernel -append "url=http://10.0.2.2:8000/root.sqfs ip=::::::dhcp quiet splash" -initrd initramfs --enable-kvm'
alias simpleHTTP='python2 -m SimpleHTTPServer'
alias ..='cd ..'
alias cd='pushd $PWD 1>/dev/null; cd'
alias cd_uni=' cd Studium/SoSe2013'
alias cp='cp -vi'
alias mv='mv -i'
alias rtfm='less README*'
alias ls='ls --color=auto'
alias viewjpg='display "vid:*.jpg"'
alias Y='yaourt -Syu --aur'
alias ll='ls -lhX --group-directories-first'
alias g='git'
alias s='sudo'
alias y='yaourt'
alias v='vim'
alias sv='sudo -E vim'
alias svn_add_folder='svn add --depth=empty'
alias nmpc='ncmpcpp'
alias sysd='sudo systemctl'
alias start='sudo systemctl start'
alias restart='sudo systemctl restart'
alias stop='sudo systemctl stop'
alias status='sudo systemctl status'
alias halt='sudo shutdown -h now'
alias ducks='du -cksh * | sort -rn'
alias reload='exec $0'
alias gpoh='git push origin HEAD'
alias gitdmerged='git branch -d $((git checkout master && git pull) > /dev/null && git branch --merged | grep -v master | tr -d "\n")'
alias hg_patch_import='hg import --no-commit'
alias a='. env/bin/activate'
alias d='deactivate'
alias V='nvim -S'
alias zebra='ip -c --br a'
alias bra='zebra'
alias freeze='pip freeze -r requirements.txt | grep -v "pkg-resources" > requirements_new.txt && mv requirements_new.txt requirements.txt'
#/>

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
