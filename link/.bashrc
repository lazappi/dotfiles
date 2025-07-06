# Where the magic happens.
export DOTFILES=~/.dotfiles

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

PATH=~/bin:$PATH
export PATH

eval "$(thefuck --alias)"
# eval "$(starship init bash)"

eval "$(frum init)"

src


source /Users/luke.zappia/.docker/init-bash.sh || true # Added by Docker Desktop
