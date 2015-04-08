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
  local delim="$(paddedColor blue)"
  local systemLoad=`uptime | egrep -o '[0-9]{1,2}\.[0-9]{1}' | head -1`
  # local batteryLoad=`acpi | cut -d' ' -f 4 | tr -d ','`
  local gitBranch=$(git branch 2>/dev/null | sed --regexp-extended \
      "s/^\* (.*)$/ $(validateSEDReplacement "$(paddedColor\
      light blue)")\1$(validateSEDReplacement "$(paddedColor blue)")/g" \
    | tr --delete "\n" | sed 's/  / /g' | sed 's/^ *//g' | sed 's/ *$//g')
  if [[ ${systemLoad} > 1.9 ]]; then
      systemLoad="$delim($(paddedColor bold blink red)$systemLoad$delim) "
  elif [[ $systemLoad > 0.9 ]]; then
      systemLoad="$delim($(paddedColor yellow)$systemLoad$delim) "
  elif [[ $systemLoad > 0.5 ]]; then
      systemLoad="$delim($(paddedColor cyan)$systemLoad$delim) "
  else
      systemLoad=""
  fi
  if [ "$gitBranch" ]; then
      gitBranch="${delim}${gitBranch}$delim#"
  else
      gitBranch="$(paddedColor blue)#"
  fi

  local errorPrompt=""
  if [ $errorNumber -ne 0 ]; then # set an error string for the prompt, if applicable
      errorPrompt="$(paddedColor bold red)${errorNumber} "
  fi

  if [[ "$USER" == "milan" ]]; then
      local user="$(paddedColor green)"
  elif [[ "$USER" == "root" ]];then
      local user="$(paddedColor red)"
  else
      local user="$(paddedColor yellow)"
  fi
  user+="$USER"

  local at="$(paddedColor blue)@"

  if [[ "$SSH_CONNECTION" ]];then
      local host="$(paddedColor yellow)"
  else
      local host="$(paddedColor blue)"
  fi
  host+=$HOSTNAME

  if [[ "$TERM" != 'linux' ]]; then
    local titleBar="\[\e]0;\u@\h:`pwd`\a\]"
  fi

  PS1="${titleBar}${errorPrompt}${user}$delim@${host}$delim:$(\
      paddedColor cyan)\w${systemLoad}\n${gitBranch}$(paddedColor reset)"
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

source /usr/share/doc/pkgfile/command-not-found.bash

((_HOME_CONFIG_BASH_PROFILE_+=1))
export _HOME_CONFIG_BASH_PROFILE_

# vim: foldmarker=#<!,#!>
