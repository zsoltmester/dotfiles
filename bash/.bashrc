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
    fi

    if which rbenv &> /dev/null; then
        print_header "Updating with gem using rbenv..."
        gem update --system -N
        gem update -N
        gem cleanup
    fi

    if which npm &> /dev/null; then
        print_header "Updating with npm..."
        sudo npm update -g
        # TODO: sudoless npm update
    fi

    if which apm &> /dev/null; then
        print_header "Updating with apm..."
        apm upgrade
    fi

    # TODO: update pip packages
}

# Executes the given command in all subdirectories of the current directory.
indirs()
{
    local command="$*"
    [[ -z "$command" ]] && echo "Command is empty!" && return
    printf "Command to execute: \"$command\"\n\n"

    for directory in */
    do
        cd $directory
        printf "\033[01;34m${directory::-1}\033[00m:\n"
        eval "$command"
        printf '\n'
        cd ..
    done
}

# Executes the given git command in all subdirectories of the current directory, which are a git repository.
ingitdirs()
{
    local command="$*"
    [[ -z "$command" ]] && echo "Command is empty!" && return
    printf "Command to execute: \"git $command\"\n\n"

    for directory in */
    do
        cd $directory
        if [[ -d .git ]]
        then
            printf "\033[01;34m${directory::-1}\033[00m:\n"
            eval "git $command"
            printf '\n'
        fi
        cd ..
    done
}

# Executes the given git command in all subdirectories of the current directory, which are a git repository and on the given branch.
ingitdirsonbranch()
{
    local branch="$1"
    [[ -z "$branch" ]] && echo "Branch is empty!" && return
    printf "Branch to search for: $branch\n"

    local command="${@:2}"
    [[ -z "$command" ]] && echo "Command is empty!" && return
    printf "Command to execute: \"git $command\"\n\n"

    for directory in */
    do
        cd $directory
        if [[ -d .git ]] && [[ "$(git branch-name)" == "$branch" ]]
        then
            printf "\033[01;34m${directory::-1}\033[00m:\n"
            eval "git $command"
            printf '\n'
        fi
        cd ..
    done
}

# Executes the given git command in all subdirectories of the current directory, which are a git repository and have uncommited changes.
ingitdirswithchanges()
{
    local command="$*"
    [[ -z "$command" ]] && echo "Command is empty!" && return
    printf "Command to execute: \"git $command\"\n\n"

    for directory in */
    do
        cd $directory
        if [[ -d .git ]]
        then
            local repository_status="$(git st)"
            if [[ "$repository_status" = *"Changes to be committed:"* ]] || [[ "$repository_status" = *"Changes not staged for commit:"* ]] || [[ "$repository_status" = *"Untracked files:"* ]]
            then
                printf "\033[01;34m${directory::-1}\033[00m:\n"
                eval "git $command"
                printf '\n'
            fi
        fi
        cd ..
    done
}
