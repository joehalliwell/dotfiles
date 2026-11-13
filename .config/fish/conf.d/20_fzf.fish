# fzf: Ctrl-T (files), Alt-C (cd). Ctrl-R is overridden by atuin (30_atuin.fish).
if status is-interactive; and type -q fzf
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --exclude .git'
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers {}'"
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git'
    fzf --fish | source
end
