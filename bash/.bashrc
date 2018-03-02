# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# include .bash_aliases if it exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories
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

# turn on protection againts override with >
set -o noclobber

##
# Interface
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
# History
##

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# set history length
HISTSIZE=10000
HISTFILESIZE=10000

##
# External environments
##

# init rbenv
if which rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

##
# Utility functions
##

# print a header, where the title is the first argument
print_header()
{
    title_length=${#1}
    printf "%0.s-" $(seq 1 $title_length)
    printf "\n"
    echo "$1"
}

# update all the packages, which are available through a package manager
up()
{
    if which apt-get &> /dev/null; then
        print_header "Updating with apt..."
        sudo apt update && sudo apt upgrade && sudo apt-get autoremove && sudo apt-get autoclean
    fi

    if which brew &> /dev/null; then
        print_header "Updating with brew..."
        brew update && brew upgrade && brew cleanup -s
    fi

    if which conda &> /dev/null; then
        print_header "Updating with conda..."
        conda update anaconda
    else
        if which pip &> /dev/null; then
            print_header "Updating with pip..."
            pip install -U pip-review
            pip-review --auto
            pip check
        fi
        if which pip3 &> /dev/null; then
            print_header "Updating with pip3..."
            pip3 install -U pip-review
            pip-review --auto
            pip3 check
        fi
    fi

    if which rbenv &> /dev/null; then
        print_header "Updating with gem using rbenv..."
        gem update --system
        gem update --no-ri --no-rdoc
        gem cleanup
    fi

    if which npm &> /dev/null; then
        print_header "Updating with npm..."
        sudo npm update -g
    fi

    if which apm &> /dev/null; then
        print_header "Updating with apm..."
        apm upgrade
    fi
}

# run the given command in all directories
indirs()
{
    for dir in */;
    do
        cd $dir;
        echo "In $dir executing \"$*\""
        eval "$*"
        cd ..;
    done
}

# run the given git command in all git directories
ingitdirs()
{
    for dir in */;
    do
        cd $dir;
        if [ -d .git ];
        then
            echo "In $dir executing \"git $*\""
            eval "git $*";
        fi;
        cd ..;
    done
}

# run the given git command in all git directories which are on the given branch
# the first param is the branch, the second is the command
ingitdirsonbranch()
{
    for dir in */;
    do
        cd $dir;
        if [ -d .git ] && [ "$(git branch-name)" == "$1" ];
        then
            echo "In $dir executing \"git $*\""
            cmd=$(expr "$*" : "$1\(.*\)")
            eval "git $cmd";
        fi;
        cd ..;
    done
}

# run the given git command in all git directories which have uncommited changes
ingitdirswithchanges()
{
    for dir in */;
    do
        cd $dir;
        if [[ -d .git ]] && ([[ "$(git st)" = *"Changes to be committed:"* ]] || [[ "$(git st)" = *"Changes not staged for commit:"* ]] || [[ "$(git st)" = *"Untracked files:"* ]]);
        then
            echo "In $dir executing \"git $*\""
            eval "git $*";
        fi;
        cd ..;
    done
}
