alias ..='cd ..'

# show colored output, if possible
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# my parametrized ls
alias ll="ls -alhF --group-directories-first"

# prevent accidently deletions
alias rm="rm -i"
alias mv="mv -i"

# display size in human readable form
alias df="df -h"
alias du="du -h"

# create parents, if necesseary
alias mkdir='mkdir -p'

# update with apt-get
alias up="sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean"

# an "alert" alias for long running commands
# use like so: "sleep 10; alert"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
