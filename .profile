# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# Note: Bash on Windows does not currently apply umask properly.
if [ "$(umask)" = "0000" ]; then
	umask 022
fi

if [ -n "$(command -v tmux)" ] ; then # tmux is installed
	TPM_FOLDER="$HOME/.tmux/plugins/tpm"
	if [ ! -d "$TPM_FOLDER" ] ; then
		git clone 'https://github.com/tmux-plugins/tpm' "$TPM_FOLDER"
		"$TPM_FOLDER/bin/install_plugins"
	else
		: #$TPM_FOLDER/bin/update_plugins" "all"
	fi
fi

if [ -n "$(command -v vim)" ] ; then # vim is installed
	VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim";
	if [ ! -d "$VUNDLE_DIR" ] ; then
		git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_DIR;
	fi
	vim +PluginInstall +qall
fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

# set PATH so it includes user's private bin directories
export PATH
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

