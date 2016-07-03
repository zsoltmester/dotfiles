# ~/.profile: executed by the command interpreter for login shells

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# include .vars if it exists
# the .vars should contain environment variable definitions and path extension
if [ -f "$HOME/.vars" ]; then
    . "$HOME/.vars"
fi
