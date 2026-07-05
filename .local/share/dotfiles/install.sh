#!/usr/bin/env bash
# install.sh — install system files from dotfiles into place
# Lives at ~/.local/share/dotfiles/install.sh; run with sudo.
set -euo pipefail

SRC="$(dirname "${BASH_SOURCE[0]}")"
changed=0

deploy() {                       # deploy <file> <dest-dir> <mode>
  local f="$SRC/$1" dest="$2/$1"
  if ! cmp -s "$f" "$dest" 2>/dev/null; then
    install -D -m "$3" "$f" "$dest"
    echo "installed: $dest"
    changed=1
  fi
}

deploy rapl-cap.sh      /usr/local/bin      0755
deploy rapl-cap.service /etc/systemd/system 0644

if (( changed )); then
  systemctl daemon-reload
  systemctl enable --now rapl-cap.service
else
  echo "nothing to do"
fi
