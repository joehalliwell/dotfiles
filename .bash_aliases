# enable color support for grep add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Enable exa, if available
if command -v exa &> /dev/null; then
    FANCY_LS='exa --classify'
    alias l="$FANCY_LS"
    alias ls="$FANCY_LS"
    alias ll="$FANCY_LS --all --group --long"
    alias la="$FANCY_LS --all "
fi

# Enable bat, if available
if command -v bat &> /dev/null; then
    alias cat='bat'
    export BAT_THEME="TwoDark"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

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
alias cl="clear"

# Mini apps
alias wttr="curl https://wttr.in"
alias words="find . -type f -print0 | sort -z | wc -w --files0-from - | tail -n1"

# Commonplace (notes/journal functions)
function today() {
    _today="$COMMONPLACE/Journal/$(date +%Y/%m/%d.md)"
    if [[ ! -f "$_today" ]]; then
        echo "Creating $_today"
        mkdir -p "$(dirname $_today)"
        touch "$_today"
        date "+# %A, %B %d, %Y" >> "$_today"
    fi
    echo >> "$_today"
    date "+## %H:%M:%S" >> "$_today"
    echo >> "$_today"
    code "$_today"
}
function search() {
    query="$1"
    if [[ -z "$query" ]]; then
        sk --ansi -i -c 'rg --color ansi --vimgrep "{}"' --print0 | cut -z -d : -f 1-3 | xargs -0 -r code -g
    else
        rg --vimgrep --color ansi "$query" | sk --ansi --print0 | cut -z -d : -f 1-3 | xargs -0 -r code -g
    fi
}
alias tasks="pushd $COMMONPLACE; search '\[ \]'; popd"
alias commonplace="git --git-dir=$COMMONPLACE/.git --work-tree=$COMMONPLACE"
alias cca="commonplace add --all $COMMONPLACE; commonplace commit -m 'Routine updates'"
alias ccs="cca; commonplace pull --rebase; commonplace push"

# Scratch Jupyter Lab for random hacking
# Deps: ipykernel jupyter ipython
function sandbox() {
    sandbox_env="$HOME/.venv/sandbox"
    sandbox_dir="$HOME/Dropbox/Notebooks"

    if [ ! -d  "$sandbox_env" ]; then
        echo "No sandbox virtual environment in $sandbox_env!";
        return
    fi
    if [ ! -d "$sandbox_dir" ]; then
        echo "No sandbox dir $sandbox_dir!";
        return
    fi
    source "$sandbox_env/bin/activate"
    python3 -m ipykernel install --user --name sandbox
    jupyter lab --ip 0.0.0.0 --notebook-dir "$sandbox_dir"
    deactivate
}

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
## Update a directory of git checkouts
function dup() {
    for d in *; do
        if [[ -d $d && -d $d/.git ]]; then
            banner $d
            pushd $d
            git pull --rebase
            popd
        fi
    done
}

# Extra fasd aliases
alias co='a -e code'
alias o='a -e xdg-open'
_fasd_bash_hook_cmd_complete co o
