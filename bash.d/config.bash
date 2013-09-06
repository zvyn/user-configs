#
# ~/config/bash_profile
#

function validateSEDReplacement() {
    echo "$1" | sed --expression 's/\\/\\\\/g' --expression 's/\//\\\//g' \
        --expression 's/&/\\\&/g'
}

prompt_command () {
  local errorNumber="$?"
  local systemLoad=`uptime | egrep -o '[0-9]{1,2}\.[0-9]{1,2}' | head -1`
  # local batteryLoad=`acpi | cut -d' ' -f 4 | tr -d ','`
  local gitBranch=$(git branch 2>/dev/null | sed --regexp-extended \
      "s/^\* (.*)$/ $(validateSEDReplacement "$(paddedColor\
      red)")\1$(validateSEDReplacement "$(paddedColor blue)")/g" \
    | tr --delete "\n" | sed 's/  / /g' | sed 's/^ *//g' | sed 's/ *$//g')
  if [ "$gitBranch" ]; then
      gitBranch="$(paddedColor blue)(${gitBranch}$(paddedColor blue))"
  else
      gitBranch="$(paddedColor blue)#!"
  fi

  errorPrompt=""
  if [ $errorNumber -ne 0 ]; then # set an error string for the prompt, if applicable
    errorPrompt="($errorNumber) "
  fi

  if [ `id -u` -eq 0 ]; then
      local userColor="$(paddedColor red)"
  else
      local userColor="$(paddedColor green)"
  fi

  if [[ "$TERM" != 'linux' ]]; then
    local titleBar="\[\e]0;${errorPrompt}\u@\h:`pwd`\a\]"
  fi

  export PS1="${titleBar}$(paddedColor red)$errorPrompt${userColor}\u$(\
      paddedColor blue)@$(paddedColor cyan)\h$(paddedColor blue\
      ) (${systemLoad}) ${userColor}\w\n${gitBranch}$(paddedColor default) "
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
