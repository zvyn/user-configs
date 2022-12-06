#
# ~/config/bash_profile
#

#<! functions
pwdtail () { #returns the last 2 fields of the working directory
  pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

function validateSEDReplacement() {
    echo "$1" | sed --expression 's/\\/\\\\/g' --expression 's/\//\\\//g' \
        --expression 's/&/\\\&/g'
}

prompt_command () {
  local errorNumber="$?"
  local delim="$(paddedColor cyan)"
  local systemLoad=`uptime | egrep -o '[0-9]{1,2}\.[0-9]{1}' | head -1`
  # local batteryLoad=`acpi | cut -d' ' -f 4 | tr -d ','`
  local gitBranch="$(paddedColor bold green)$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '') "
  local gitBranches="$(git branch --sort=-committerdate --no-merged 2>/dev/null| tr -d ' ' | tr '\n' ' ')"
  if [[ ${systemLoad} > 1.9 ]]; then
      systemLoad="$delim$(paddedColor bold blink red)$systemLoad$delim "
  elif [[ $systemLoad > 0.9 ]]; then
      systemLoad="$delim$(paddedColor yellow)$systemLoad$delim "
  elif [[ $systemLoad > 0.5 ]]; then
      systemLoad="$delim$(paddedColor cyan)$systemLoad$delim "
  else
      systemLoad="$delim$(paddedColor green)$systemLoad$delim "
  fi
  local env=""
  if [ $VIRTUAL_ENV ]; then
      env="$(paddedColor yellow)$(basename $(dirname $VIRTUAL_ENV))$delim "
  fi

  local errorPrompt=""
  if [ $errorNumber -ne 0 ]; then # set an error string for the prompt, if applicable
      errorPrompt="$(paddedColor bold red)${errorNumber} "
  else
      errorPrompt="$(paddedColor bold green)# "
  fi

  if [[ "$USER" == "milan" ]]; then
      local user=""
  elif [[ "$USER" == "root" ]];then
      local user="$(paddedColor bold red)$USER "
  else
      local user="$(paddedColor bold yellow)$USER "
  fi

  if [[ "$SSH_CONNECTION" ]];then
      local at="$(paddedColor blue)@"
      local host="${at}$(paddedColor bold yellow)${HOSTNAME} "
  else
      local host=""
  fi

  if [[ "$TERM" != 'linux' ]]; then
    local titleBar="\[\e]0;\u@\h:`pwd`\a\]"
  fi

  PS1="${titleBar}${user}${host}$(paddedColor light cyan)\w ${env}${gitBranch}$(paddedColor cyan)${gitBranches}\n${errorPrompt}$(paddedColor reset)"
}
#!>

#<! complete
complete -cf sudo
complete -cf s

complete -A directory mkdir rmdir

complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2

complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf
complete -f -o default -X '!*.+(dvi|DVI)' dvips dvipdf xdvi
complete -f -o default -X '!*.+(pdf|PDF)' xpdf ps2pdf evince

complete -f -o default -X '!*.tex' tex latex pdflatex
#!>

PROMPT_COMMAND=prompt_command

if [ -f /usr/share/doc/pkgfile/command-not-found.bash ]; then
  source /usr/share/doc/pkgfile/command-not-found.bash
fi

((_HOME_CONFIG_BASH_PROFILE_+=1))
export _HOME_CONFIG_BASH_PROFILE_

# vim: foldmarker=#<!,#!>
