# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# Note: Bash on Windows does not currently apply umask properly.
if [ `umask` = "0000" ]; then
	umask 022
fi

if [ -n `command -v tmux` ] ; then # tmux is installed
	TPM_FOLDER="$HOME/.tmux/plugins/tpm"
	if [ ! -d "$TPM_FOLDER" ] ; then
		git clone 'https://github.com/tmux-plugins/tpm' "$TPM_FOLDER"
		if [ -n "$TMUX" ] ; then
			tmux source-file $HOME/.tmux.conf
		fi
		"$TPM_FOLDER/bin/install_plugins"
	else
		: #$TPM_FOLDER/bin/update_plugins" "all"
	fi
fi

if [ -n `command -v vim` ] ; then # vim is installed
	VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim";
	if [ ! -d "$VUNDLE_DIR" ] ; then
		git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_DIR;
		vim --not-a-term +PluginInstall +qall
	fi
fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

# set PATH so it includes user's private bin directories
export PATH
[ -r "$HOME/bin" ]                         && PATH="$HOME/bin:$PATH"
[ -r "$HOME/.local/bin" ]                  && PATH="$HOME/.local/bin:$PATH"
[ -r "$HOME/.cargo/bin" ]                  && PATH="$HOME/.cargo/bin:$PATH"
[ -r "$HOME/miniconda3/bin" ]                && PATH="$HOME/miniconda3/bin:$PATH"
[ -r "/usr/local/opt/python/libexec/bin" ] && PATH="/usr/local/opt/python/libexec/bin:$PATH"

[ -r "$HOME/.nvm" ]               && export NVM_DIR="$HOME/.nvm"
[ -r "$NVM_DIR/nvm.sh" ]          && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -r "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANSIBLE_STDOUT_CALLBACK="debug"

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc"
	fi
fi

