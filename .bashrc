# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# prompt

build_ps1() {
	local exit_code="$?"

	join_by() {
		local IFS="$1"
		shift
		echo "$*"
	}

	format_text() {
		ESC="\e"
		STR=$1
		shift
		if [ -z "$*" ] ; then # emphasis
			BEGIN=""
			END=""
		else
			END="$ESC[0m"
			codes=$(join_by ";" $*)
			BEGIN="$ESC[${codes}m"
		fi
		echo -e "$BEGIN$STR$END"
	}

	local BOLD=1
	local FAINT=2
	local ITALIC=3
	local UNDERLINE=4
	local BLINK=5
	local BLINK_FAST=6
	local STRIKETHROUGH=9

	local FG_BLACK=30
	local FG_RED=31
	local FG_GREEN=32
	local FG_YELLOW=33
	local FG_BLUE=34
	local FG_MAGENTA=35
	local FG_CYAN=36
	local FG_WHITE=37

	local BG_BLACK=40
	local BG_RED=41
	local BG_GREEN=42
	local BG_YELLOW=43
	local BG_BLUE=44
	local BG_MAGENTA=45
	local BG_CYAN=46
	local BG_WHITE=47

	local USERNAME="\u"
	local DIRECTORY="\w"
	local HOSTNAME_SHORT="\h"
	local HOSTNAME_LONG="\H"
	local SIGIL="\\$"

	local DATE="\d"
	local TIME_SHORT="\A"
	local TIME_LONG="\@"
	local TIME_SHORT_SECONDS="\t"
	local TIME_LONG_SECONDS="\T"

	represent_exit_code() {
		if [ "$exit_code" == "0" ] ; then
			echo "$(format_text "$1" "$FG_GREEN")"
		else
			echo "$(format_text "$2" "$FG_RED")"
		fi
	}
	
	parse_git_branch() {
		git_root="$(git rev-parse --show-toplevel)"
		if [ "$git_root" != "$HOME" ] ; then
			git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
		fi
	}

	local symbols=()

	# edit below
	# For dynamic symbols (git branch, exit code, etc.) you must turn assign PROMPT_COMMAND="build_ps1"
	# (Disabled by default since it causes lag)

	#symbols+=("$(represent_exit_code "☺" "☹") ")

	# Comment out to hide username
	SHOW_USERNAME="Y"
	if [ "$SHOW_USERNAME" == "Y" ] ; then
		symbols+=("$(format_text "$USERNAME" "$BOLD" "$FG_GREEN")")
	fi

	# Comment out to hide hostname unless you're in an SSH session
	SHOW_HOSTNAME="Y"
	if [ -n "$SSH_TTY" ] || [ "$SHOW_HOSTNAME" == "Y" ] ; then
		symbols+=("$(format_text "@$HOSTNAME_SHORT" "$BOLD" "$FG_GREEN"):")
	fi

	symbols+=("$(format_text "$DIRECTORY" "$BOLD" "$FG_BLUE")")

	#local git_branch="$(parse_git_branch)"
	if [ -n "$git_branch" ] ; then
		symbols+=(" $(format_text "($git_branch)" "$BOLD" "$FG_CYAN")")
	fi

	if [ "$UID" -eq "0" ] ; then
		symbols+=("$(format_text "$SIGIL" "$BOLD" "$FG_RED")")
	else
		symbols+=("$(format_text "$SIGIL" "$BOLD" "$FG_YELLOW")")
	fi

	PS1="$(join_by "" "${symbols[@]}") "
}

# if this is an SSH session, set title of shell to hostname
if
	[ -n "$SSH_CLIENT" ] &&
	[ -z "$TMUX"       ] ;
then
	# set title
	printf "\033k$USER@$HOSTNAME\033\\"
fi

# if display isn't set, enable it
if [ -n "$DISPLAY" ] ; then
	DISPLAY=:0
fi

# start tmux
if
	[ -n "$(command -v tmux)" ] && # tmux is installed
	[ -z "$TMUX" ]              && # not inside tmux
	[ "$TERM" != 'screen' ]     ;  # not inside screen
then
	TMUX_SESSION_ID=$(tmux ls | grep attached --invert-match | cut -d ":" -f1)
	if [ -n "$TMUX_SESSION_ID" ] ; then
		tmux attach -t "$TMUX_SESSION_ID"
	else
		exec tmux new-session && exit
	fi
	#tmux attach 2> /dev/null ||     # attach to a session if it exists
	#exec tmux new-session && exit;  # otherwise, start a new one
fi

# if running in WSL, set up environment
WINHOME="/mnt/c/Users/$USER"
if [ -d $WINHOME ] ; then
	export WINHOME
fi

# default to Vim
export VISUAL
VIM_PATH=$(which vim)
if [ -n "$VIM_PATH" ]; then
	VISUAL="$VIM_PATH"
else
	VISUAL=$(which vi)
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	#PROMPT_COMMAND="build_ps1"
	build_ps1
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
