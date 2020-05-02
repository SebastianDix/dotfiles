# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s autocd 
shopt -s cdable_vars
shopt -s direxpand
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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
	CHROOT= ${debian_chroot:+($debian_chroot)}
	PS1='\[\033[01;32m\]\d\[\033[00m\]:[ \[\033[01;34m\]\w\[\033[00m\] ] '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
		;;
	*)
		;;
esac

if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


#   sleep 10; alert

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.


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

# setting editor for readline ctrl+x,e and less etc.
EDITOR=vim

# add bin  folder to path variable
export PATH="$PATH:${HOME}/bin/"

if [ -f ~/.bash_prompt ]; then
	. ~/.bash_prompt
fi
if [ -f ~/.bash_functions ]; then
	. ~/.bash_functions
fi
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.bash_custom ]; then
	. ~/.bash_custom
fi
# SSH Agent
# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.
# source : https://www.schoonology.com/technology/ssh-agent-windows/

env=~/.ssh/agent.env

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

agent_is_running() {
	if [ "$SSH_AUTH_SOCK" ]; then
		# ssh-add returns:
		#   0 = agent running, has keys
		#   1 = agent running, no keys
		#   2 = agent not running
		ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
	else
		false
	fi
}

agent_has_keys() {
	ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
	. "$env" >/dev/null
}

agent_start() {
	(umask 077; ssh-agent >"$env")
	. "$env" >/dev/null
}

#add_all_keys() {
#  ls ~/.ssh | grep ^id_rsa.*$ | sed "s:^:`echo ~`/.ssh/:" | xargs -n 1 ssh-add
#}

if ! agent_is_running; then
	agent_load_env
fi

add_all_priv_keys() {
	for i in ${HOME}/.ssh/*; do
		if [[ $(basename ${i}) =~ ^id_.* ]] && [[ ! $(basename ${i}) =~ .*\.pub$ ]]; then
			ssh-add "${i}"
		fi
	done
}
# if your keys are not stored in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub, you'll need
# to paste the proper path after ssh-add
if ! agent_is_running; then
	agent_start
	add_all_priv_keys
elif ! agent_has_keys; then
add_all_priv_keys
fi
echo `ssh-add -l | wc -l` SSH keys registered.
unset env

export HISTSIZE=10000;
PROMPT_COMMAND='history -a'
shopt -s cmdhist
export HOME=${HOME}
export PATH=$PATH:~/bin
