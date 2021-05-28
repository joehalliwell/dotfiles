# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Write history every time a command completes
PROMPT_COMMAND='history -a;history -n;echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Disable terminal bell
bind "set bell-style visible"

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export LESS='--quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a basic prompt
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Set npm -g installation prefix
export NPM_CONFIG_PREFIX="$HOME/.local/opt/node"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_CONFIG_PREFIX/share/man"

# Set up the path
function _add_path() {
    path=$1
    if [[ ! -d "$path" ]]; then
        echo ".bashrc: Warning! Not adding invalid '$path' to \$PATH"
        return
    fi
    export PATH="$PATH:$path"
}

# Used to run shell integrated setup command
function _setup_command {
  cmd=$1
  if ! command -v $cmd &> /dev/null; then
    echo ".bashrc: Warning! Not setting up invalid command '$cmd'"
    return
  fi
  eval "$($*)"
}

_add_path "$HOME/.local/bin"
_add_path "$HOME/.cargo/bin"
_add_path "$HOME/.local/opt/flutter/bin"
_add_path "$NPM_CONFIG_PREFIX/bin"

_setup_command starship init bash
#_setup_command zoxide init bash
_setup_command fasd --init auto

export NLTK_DATA="$HOME/.local/opt/nltk_data"
export COMMONPLACE="$HOME/work/commonplace-private"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
