alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll="ls -alhF"

alias rm="rm -i"
alias mv="mv -i"

alias df="df -h"
alias du="du -h"

# update with apt-get
alias up="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean"

# an "alert" alias for long running commands
# use like so: "sleep 10; alert"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
