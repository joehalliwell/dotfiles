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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Python-related aliases
alias python="python3"
alias pip="python3 -m pip"
alias venv="python3 -m venv"

# Desktop convenience
alias open="xdg-open"
alias copy="xclip -selection clipboard"
alias paste="xclip -selection clipboard -out"
alias banner="toilet -f mono9 --termwidth"

# Mini apps
alias wttr="curl https://wttr.in"
alias words="find . -type f -print0 | sort -z | wc -w --files0-from - | tail -n1"

function search() {
    query="$1"
    if [[ -z "$query" ]]; then
        sk --ansi -i -c 'rg --color ansi --vimgrep "{}"' --print0 | cut -z -d : -f 1-3 | xargs -0 -r code -g
    else
        rg --vimgrep --color ansi "$query" | sk --ansi --print0 | cut -z -d : -f 1-3 | xargs -0 -r code -g
    fi
}
alias tasks='search "\[ \]|TODO"'

# System management
alias dotfiles="git --git-dir=$HOME/work/dotfiles/.git --work-tree=$HOME"
function up() {
    sudo apt update
    sudo apt -y full-upgrade

    if [[ -x $(command -v rustup) ]]; then
        rustup update
        # cargo install cargo-update
        cargo install-update --all
    else
        echo "Skipping rust update"
    fi
}

# Extra fasd aliases
alias o='a -e xdg-open'
alias co='a -e code'
_fasd_bash_hook_cmd_complete o
