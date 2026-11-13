# zoxide: smarter cd (replaces `cd`, adds `cdi`)
if status is-interactive; and type -q zoxide
    zoxide init fish --cmd cd | source
end
