if type -q bat
    # Use 'abbr' so it expands in-place (active freedom)
    alias cat bat

    # Theme and Manpage integration
    set -gx BAT_THEME "TwoDark"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT "-c"

    # File preview for fzf
    set -gx FZF_DEFAULT_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"

    # Colorize --help messages
    # Usage: helpme <command> (e.g., helpme git)
    function helpme
        $argv --help 2>&1 | bat --plain --language=help
    end
end
