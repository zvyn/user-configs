alias qemu_squash='qemu-system-x86_64 -soundhw hda -m 3G -kernel kernel -append "url=http://10.0.2.2:8000/root.sqfs ip=::::::dhcp quiet splash" -initrd initramfs --enable-kvm'
alias http='python3 -m http.server'
alias ..='cd ..'
alias cp='cp -vi'
alias mv='mv -i'
alias rtfm='less README*'
alias ls='ls --color=auto'
alias viewjpg='display "vid:*.jpg"'
alias Y='yay -Syu'
alias ll='ls -lhX --group-directories-first'
alias g='git'
alias s='sudo'
alias y='yay'
alias v="$EDITOR"
alias sv="sudo -E $EDITOR"
alias nmpc='ncmpcpp'
alias ducks='du -cksh * | sort -rn'
alias reload='exec $0'
alias gpoh='git push origin HEAD'
alias gotomain='git checkout main || git checkout master'
alias dmerged='git branch --merged | egrep -v "(^\*|^\+|master|main|dev)" | xargs git branch -d'
alias gitdmerged='gotomain && git pull && dmerged'
alias hg_patch_import='hg import --no-commit'
alias a='. env/bin/activate'
alias d='deactivate'
alias V='nvim -S'
alias zipfile='python3 -m zipfile'
alias zebra='ip -c --br a'
alias bra='zebra'
alias j=journalctl
alias ju='j -u'
alias Mount='udisksctl mount --block-device'
alias Unmount='udisksctl unmount --block-device'
