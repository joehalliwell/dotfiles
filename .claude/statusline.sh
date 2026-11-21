#!/usr/bin/env bash
# Claude Code status line: context usage and cwd (worktree-aware).
input=$(cat)
cwd=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
model=$(jq -r '.model.display_name // .model.id // empty' <<<"$input")
[ -z "$cwd" ] && cwd=$PWD

disp=$cwd
for h in "$HOME" "$(cd "$HOME" 2>/dev/null && pwd -P)"; do
  case "$cwd" in
    "$h") disp="~"; break ;;
    "$h"/*) disp="~${cwd#"$h"}"; break ;;
  esac
done
# Worktrees: show repo⎇name rather than the long .claude/worktrees path.
case "$disp" in
  */.claude/worktrees/*) wt=${disp#*/.claude/worktrees/}; disp="${disp%%/.claude/worktrees/*} ⎇ ${wt%%/*}" ;;
esac

if [ -n "$pct" ]; then
  p=$(printf '%.0f' "$pct")
  n=$(( (p + 5) / 10 )); [ "$n" -lt 0 ] && n=0; [ "$n" -gt 10 ] && n=10
  ctx=""
  for ((i = 0; i < 10; i++)); do
    if [ "$i" -lt "$n" ]; then ctx+="▓"; else ctx+="░"; fi
  done
  ctx+=" ${p}%"
else
  ctx='░░░░░░░░░░ --'
fi

# Starship-style colours: directory bright-cyan, git branch bright-purple, status red.
cyan=$'\e[96m'; purple=$'\e[95m'; red=$'\e[31m'; reset=$'\e[0m'

# Git branch (nerd-font branch glyph, as in starship [git_branch]); no optional locks.
git_seg=""
if branch=$(git --no-optional-locks -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null) ||
   branch=$(git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null); then
  git_seg="${purple}"$''" ${branch}${reset}"
  if [ -n "$(git --no-optional-locks -C "$cwd" status --porcelain 2>/dev/null | head -n1)" ]; then
    git_seg="${git_seg} ${red}!${reset}"
  fi
fi

# Toolbox indicator (toolbox/distrobox containers).
tb=""
if [ -f /run/.toolboxenv ] || [ -n "$TOOLBOX_PATH" ]; then
  tb="⬢ ${CONTAINER_ID:-toolbox} "
elif [ -n "$DISTROBOX_ENTER_PATH" ]; then
  tb="⬢ ${CONTAINER_ID:-distrobox} "
fi

printf '%s │ %s │ %s%s%s%s%s\n' "${model:-?}" "$ctx" "$tb" "$cyan" "$disp" "$reset" "${git_seg:+ $git_seg}"
