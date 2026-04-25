if type -q eza
    # -l: long, --icons: visual, --git: status, -a: all
    alias ls 'eza --classify --group-directories-first'
    alias ll 'eza --classify --group-directories-first --long --icons --git --all'
    abbr -a tree 'eza --tree --icons'
end
