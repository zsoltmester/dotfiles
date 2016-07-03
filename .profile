# ~/.profile: executed by the command interpreter for login shells

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# include .path if it exists
# the .path should contain the path extension, for example:
#   PATH="$PATH:$HOME/Programs/intellij-idea/bin"\
#   ":$HOME/Programs/sqldeveloper/sqldeveloper/bin"\
if [ -f "$HOME/.path" ]; then
   . "$HOME/.path"
fi
