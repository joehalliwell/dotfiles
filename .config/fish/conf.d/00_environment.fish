if status is-interactive
    for line in (systemctl --user show-environment)
        set -l kv (string split -m 1 = -- $line)
        
        # Guard clause: skip empty values or protected variables
        if test -z "$kv[2]"; or contains -- $kv[1] PWD SHLVL _
            continue
        end

        set -gx $kv[1] $kv[2]
    end
end
