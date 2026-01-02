if type -q eza
    # -l: long, --icons: visual, --git: status, -a: all
    abbr -a ll 'eza --classify --group-directories-first --long --icons --git --all'
    abbr -a ls 'eza --classify --group-directories-first'
    abbr -a tree 'eza --tree --icons'
end
