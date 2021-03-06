# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH="/usr/local/bin:$(path_remove /usr/local/bin)"
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"


# Make 'less' more friendly for non-text input (eg. .zip)
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# Iterm 2 shell integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Prettier cat, less, ls with bat and exa
alias cat='bat --paging=never'
alias less=bat
alias ls=exa
alias ll='exa -l --header --git --time-style=long-iso'
alias tree='exa --tree'
