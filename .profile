# set the language
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# set the default editor
export EDITOR=vi

# include .env if it exists
# .env contains environment related variables
if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	    . "$HOME/.bashrc"
    fi
    # silence deprecation warning on mac
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi
