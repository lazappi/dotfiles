if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

welcome

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/luke.zappia/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/luke.zappia/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/luke.zappia/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/luke.zappia/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


source /Users/luke.zappia/.docker/init-bash.sh || true # Added by Docker Desktop
export PATH="/usr/local/sbin:$PATH"
