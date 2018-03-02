# include .env if it exists
# .env contains environment related variables
if [ -f "$HOME/.env" ]; then
    . "$HOME/.env"
fi

# set the default editor
export EDITOR=vi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	    . "$HOME/.bashrc"
    fi
fi
