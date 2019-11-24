
# Git shortcuts

alias g='git'
alias gp='git push'
alias gpup='gp --set-upstream origin $(gbs)'
alias gpa='gp --all'
alias gu='git pull'
alias gl='git log'
alias gs='git status'
alias gb='git branch'

# Current branch or SHA if detached.
alias gbs='git branch | perl -ne '"'"'/^\* (?:\(detached from (.*)\)|(.*))/ && print "$1$2"'"'"''

# Run commands in each subdirectory.
alias gu-all='eachdir git pull'
alias gp-all='eachdir git push'
alias gs-all='eachdir git status'

# add a github remote by github username
function gra() {
  if (( "${#@}" != 1 )); then
    echo "Usage: gra githubuser"
    return 1;
  fi
  local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
  gr add "$1" "git://github.com/$1/$repo"
}

# GitHub URL for current repo.
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local host="$(echo "$remote" | perl -pe 's/.*@//;s/:.*//')"
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://$host/$user_repo"
}
# GitHub URL for current repo, including current branch + path.
alias gurlp='echo $(gurl)/tree/$(gbs)/$(git rev-parse --show-prefix)'

# git log with per-commit cmd-clickable GitHub URLs (iTerm)
function gf() {
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\t$(gurl)/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -F
}

# Combine diff --name-status and --stat
function gstat() {
  local file mode modes color lines range code line_regex
  local file_len graph_len e r c
  range="${1:-HEAD~}"
  echo "Diff name-status & stat for range: $range"
  IFS=$'\n'

  lines=($(git diff --name-status "$range"))
  code=$?; [[ $code != 0 ]] && return $code
  declare -A modes
  for line in "${lines[@]}"; do
    file="$(echo $line | cut -f2)"
    mode=$(echo $line | cut -f1)
    modes["$file"]=$mode
  done

  file_len=0
  lines=($(git diff -M --stat --stat-width=999 "$range"))
  line_regex='s/\s*([^|]+?)\s*\|.*/$1/'
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    (( ${#file} > $file_len )) && file_len=${#file}
  done
  graph_len=$(($COLUMNS-$file_len-10))
  (( $graph_len <= 0 )) && graph_len=1

  lines=($(git diff -M --stat --stat-width=999 --stat-name-width=$file_len \
    --stat-graph-width=$graph_len --color "$range"))
  e=$(echo -e "\033")
  r="$e[0m"
  declare -A c=([M]="1;33" [D]="1;31" [A]="1;32" [R]="1;34")
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    if [[ "$file" =~ \{.+\=\>.+\} ]]; then
      mode=R
      line="$(echo "$line" | perl -pe "s/(^|=>|\})/$r$e[${c[R]}m\$1$r$e[${c[A]}m/g")"
      line="$(echo "$line" | perl -pe "s/(\{)/$r$e[${c[R]}m\$1$r$e[${c[D]}m/")"
    else
      mode=${modes["$file"]}
      color=0; [[ "$mode" ]] && color=${c[$mode]}
      line="$e[${color}m$line"
    fi
    echo "$line" | sed "s/\|/$e[0m$mode \|/"
  done
  unset IFS
}
