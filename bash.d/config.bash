#
# ~/config/bash_profile
#

function validateSEDReplacement() {
    echo "$1" | sed --expression 's/\\/\\\\/g' --expression 's/\//\\\//g' \
        --expression 's/&/\\\&/g'
}

prompt_command () {
  local errorNumber="$?"
  local braceOpen="$(paddedColor blue reset)("
  local braceClose="$(paddedColor blue reset))"
  local systemLoad=`uptime | egrep -o '[0-9]{1,2}\.[0-9]{1}' | head -1`
  # local batteryLoad=`acpi | cut -d' ' -f 4 | tr -d ','`
  local gitBranch=$(git branch 2>/dev/null | sed --regexp-extended \
      "s/^\* (.*)$/ $(validateSEDReplacement "$(paddedColor\
      light blue)")\1$(validateSEDReplacement "$(paddedColor blue)")/g" \
    | tr --delete "\n" | sed 's/  / /g' | sed 's/^ *//g' | sed 's/ *$//g')
  if [[ ${systemLoad} > 1.9 ]]; then
      systemLoad="$braceOpen$(paddedColor bold blink red)$systemLoad$braceClose "
  elif [[ $systemLoad > 0.9 ]]; then
      systemLoad="$braceOpen$(paddedColor light yellow)$systemLoad$braceClose "
  elif [[ $systemLoad > 0.5 ]]; then
      systemLoad="$braceOpen$(paddedColor cyan)$systemLoad$braceClose "
  else
      systemLoad=""
  fi
  if [ "$gitBranch" ]; then
      gitBranch="$braceOpen${gitBranch}$braceClose"
  else
      gitBranch="$(paddedColor light blue)#!"
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
      host="$(paddedColor light blue)"
  else
      host="$(paddedColor cyan)"
  fi
  host+=$HOSTNAME

  if [[ "$TERM" != 'linux' ]]; then
    local titleBar="\[\e]0;\u@\h:`pwd`\a\]"
  fi

  export PS1="${titleBar}${errorPrompt}${user}${at}${host}:\w ${systemLoad}
${gitBranch}$(paddedColor reset) "
}
PROMPT_COMMAND=prompt_command

pwdtail () { #returns the last 2 fields of the working directory
  pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# bind '"\M-v"':vi-editing-mode

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

((_HOME_CONFIG_BASH_PROFILE_+=1))
export _HOME_CONFIG_BASH_PROFILE_
