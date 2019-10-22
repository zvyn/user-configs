# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/milan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/user-configs/shell/virtualenvwrapper.sh
source ~/user-configs/shell/config.sh

source ~/user-configs/shell/mouse.zsh
bindkey -M vicmd m zle-toggle-mouse

# ctrl-left and ctrl-right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
# ctrl-bs and ctrl-del
bindkey "\e[3;5~" kill-word
bindkey "\C-_"    backward-kill-word
# del, home and end
bindkey "\e[3~" delete-char
bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line
# alt-bs
#bindkey "\e\d"  undo
# Reverse search
bindkey '^R' history-incremental-search-backward


autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line


autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\en" down-line-or-beginning-search # Down
bindkey "\ep" up-line-or-beginning-search # Up
# Use arrow-keys:
#bindkey "^[[A" up-line-or-beginning-search # Up
#bindkey "^[[B" down-line-or-beginning-search # Down

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT="\$vcs_info_msg_0_"
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%f'
zstyle ':vcs_info:*' enable git

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b
%# '
