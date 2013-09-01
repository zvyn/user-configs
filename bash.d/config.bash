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
    "s/^\* (.*)$/ $(validateSEDReplacement "$COLOR_RED")\1$(validateSEDReplacement "$COLOR_BLUE")/g" \
    | tr --delete "\n" | sed 's/  / /g' | sed 's/^ *//g' | sed 's/ *$//g')
  if [ "$gitBranch" ]; then
    gitBranch="${COLOR_BLUE}(${gitBranch}${COLOR_BLUE})"
  else
    gitBranch="${COLOR_BLUE}#!"
  fi

  errorPrompt=""
  if [ $errorNumber -ne 0 ]; then # set an error string for the prompt, if applicable
    errorPrompt="($errorNumber) "
  fi
  if [ `id -u` -eq 0 ]; then
    local userColor="${COLOR_RED}"
  else
    local userColor="${COLOR_GREEN}"
  fi
  # if (acpi -a | grep --quiet on) &> /dev/null; then
  #   local batteryPrompt="${COLOR_GREEN}+${COLOR_DKGRAY}$batteryLoad"
  # elif (acpi -a | grep --quiet off) &> /dev/null; then
  #   local batteryPrompt="${COLOR_RED}-${COLOR_DKGRAY}$batteryLoad"
  # fi
  if [[ "$TERM" != 'linux' ]]; then
    local titleBar="\[\e]0;${errorPrompt}\u@\h:`pwd`\a\]"
  fi

  export PS1="${titleBar}${COLOR_RED}$errorPrompt${userColor}\u${COLOR_BLUE}@${COLOR_CYAN}\
\h${COLOR_BLUE} (${systemLoad}) ${userColor}\
\w\n${gitBranch}${COLOR_DEFAULT} "
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
