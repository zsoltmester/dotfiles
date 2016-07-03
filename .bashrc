#~/.bashrc file for interactive shells

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set the default editor
export EDITOR=nano

# the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

##
# INTERFACE
##

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# check if the terminal support colors
if (( $(tput colors) >= 8 )); then
    support_colors=yes
fi

# set the prompt for "user@host:dir$ "
if [ "$support_colors" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# set the colors for the ls command
if [ "$support_colors" = yes ] && [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
if [ "$support_colors" = yes ]; then
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi

unset support_colors

##
# HISTORY
##

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# set history length
HISTSIZE=1000
HISTFILESIZE=2000
