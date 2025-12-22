function refresh_env --description "Hydrate shell with systemd environment (Bash-quoting safe)"
    # 1. Force systemd to re-parse config files
    systemctl --user daemon-reload

    # 2. Pipeline:
    #    a. Get systemd env
    #    b. Feed to Bash to handle the $'...' quoting
    #    c. Output null-delimited pairs (printenv -0)
    #    d. 'string split0' converts nulls to newlines for the 'read' loop

    systemctl --user show-environment \
    | bash -c 'set -a; source /dev/stdin; set +a; printenv -0' \
    | string split0 \
    | while read -l item

        # Split key=value at the first equals sign
        set -l kv (string split -m 1 = -- $item)

        # Guard: Skip malformed lines
        if test (count $kv) -lt 2
            continue
        end

        # Guard: Filter protected variables
        if contains -- $kv[1] PATH PWD SHELL SHLVL _
            continue
        end

        # Import the clean value
        set -gx $kv[1] $kv[2]
    end
end
