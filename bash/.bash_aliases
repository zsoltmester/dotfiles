# fix common mistakes
alias cd..='cd ..'
alias lesss='less'

# shortcuts
alias e='exit'

# show colored grep, if possible
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'

# ls aliases for both GNU and BSD version
if ls --color=auto &> /dev/null; then
    alias ls='ls --color=auto'
    if [ "$OSTYPE" == linux-gnu ]; then
        alias ll='ls -alhF --group-directories-first'
    else
        alias ll='gls -alhF --group-directories-first'
    fi
else
    export CLICOLOR=1
    alias ll='ls -alhF'
fi

# prevent accidently deletions
alias rm='rm -i'
alias mv='mv -i'

# display size in human readable form
alias df='df -h'
alias du='du -h'

# create parents, if necesseary
alias mkdir='mkdir -p'

# tar print updates
alias tar='tar -v'

# an "alert" alias for long running commands
# use like so: "sleep 10; alert"
if which notify-send &> /dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
    alias alert='echo "OS not supported."'
fi
