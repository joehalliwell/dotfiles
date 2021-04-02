# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # some more ls aliases
    FANCY_LS='exa --classify'
    alias l="$FANCY_LS"
    alias ll="$FANCY_LS --all --group --long"
    alias la="$FANCY_LS --all "
fi

# Use bat instead of cat, if available
if command -v bat &> /dev/null; then alias cat=bat; fi

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

# Scratch Jupyter Lab for random hacking
function sandbox() {
    sandbox_env="$HOME/.venv/sandbox"
    if [ ! -d  "$sandbox_env" ]; then
        echo "No sandbox virtual environment in $sandbox_env!";
        return
    fi
    pushd "$HOME/Dropbox/Notebooks"
    source "$sandbox_env/bin/activate"
    jupyter lab
    source "$sandbox_env/bin/deactivate"
    popd
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

# Extra fasd aliases
alias co='a -e code'
alias o='a -e xdg-open'
_fasd_bash_hook_cmd_complete co o
