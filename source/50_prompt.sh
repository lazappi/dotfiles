# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# Colour codes

## Reset
Reset='\[\e[0m\]'           # Text Reset
RBold='\[\e[21m\]'          # Reset Bold
RDim='\[\e[22m\]'           # Reset Dim
RItalic='\[\e[23m\]'        # Reset Italic
RUnder='\[\e[24m\]'         # Reset Underline
RBlink='\[\e[25m\]'         # Reset Blink
RRev='\[\e[27m\]'           # Reset Reverse colours
RHidden='\[\2e[8m\]'        # Reset Hidden

## Formatting Modes
Norm='\[\e[0m\]'            # Normal
Bold='\[\e[1m\]'            # Bold
Dim='\[\e[2m\]'             # Dim
Italic='\[\e[3m\]'          # Italic
Under='\[\e[4m\]'           # Underline
Blink='\[\e[5m\]'           # Blink
Rev='\[\e[7m\]'             # Reverse colours
Hidden='\[\e[8m\]'          # Hidden

## Regular Colors
Black='\[\e[30m\]'          # Black
Red='\[\e[31m\]'            # Red
Green='\[\e[32m\]'          # Green
Yellow='\[\e[33m\]'         # Yellow
Blue='\[\e[34m\]'           # Blue
Purple='\[\e[35m\]'         # Purple
Cyan='\[\e[36m\]'           # Cyan
White='\[\e[37m\]'          # White

## Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

## High Intensity
IBlack='\[\e[90m\]'         # Black
IRed='\[\e[91m\]'           # Red
IGreen='\[\e[92m\]'         # Green
IYellow='\[\e[93m\]'        # Yellow
IBlue='\[\e[94m\]'          # Blue
IPurple='\[\e[95m\]'        # Purple
ICyan='\[\e[96m\]'          # Cyan
IWhite='\[\e[97m\]'         # White

## High Intensity backgrounds
On_IBlack='\[\e[100m\]'     # Black
On_IRed='\[\e[101m\]'       # Red
On_IGreen='\[\e[102m\]'     # Green
On_IYellow='\[\e[103m\]'    # Yellow
On_IBlue='\[\e[104m\]'      # Blue
On_IPurple='\[\e[105m\]'    # Purple
On_ICyan='\[\e[106m\]'      # Cyan
On_IWhite='\[\e[107m\]'     # White

# Set colours

if [[ ! "${__prompt_colors[@]}" ]]; then
  __prompt_colors=(
    $Reset                # 0: Reset
    $Bold$Under$Yellow    # 1: user colour
    $Bold$Blue            # 2: path colour
    $On_IBlue             # 3: time colour
    $Bold$Blue            # 4: prompt colour
    $Bold$Cyan            # 5: git colour
    $Bold$Red             # 6: error colour
    $Bold$Purple          # 7: timer colour
    $Bold$Green           # 8: conda colour
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    __prompt_colors[1]=$Bold$Under$Cyan
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    __prompt_colors[1]=$Bold$Under$Green
  fi

fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
# Sets up local variables that can be used by function
alias __prompt_get_colors='__prompt_colors[9]=; local i; for i in ${!__prompt_colors[@]}; do local c$i="\[\e[0;${__prompt_colors[$i]}m\]"; done'

# Exit code of previous command.
function __prompt_exitcode() {
  __prompt_get_colors
  [[ $1 != 0 ]] && echo "$c6[Error $1]$c0 "
}

# Showing the runtime of the last command; adapted from
# http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
# https://github.com/gfredericks/dotfiles/base/.bashrc.base.symlink
function __timer_start() {
  timer=${timer:-$SECONDS}
}

function __timer_stop() {
  the_seconds=$(($SECONDS - $timer))
  unset timer
}

function __prompt_timer() {
  __prompt_get_colors
  __timer_stop

  # Hide results if the_seconds is small
  if [[ $the_seconds > 3 ]]; then
    timer_show="`format-duration seconds $the_seconds`"
    echo "$c7[last: ${timer_show}]$c0 "
  else
    echo ""
  fi
}

# Git status.
function __prompt_git() {
  __prompt_get_colors
  local status branch flags
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return 1;
  branch="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$branch" ]] || branch="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$branch" ]] || branch="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r "+"}\
        /^(# )?Changes not staged for commit:$/  {r=r "!"}\
        /^(# )?Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  __prompt_vcs_info=("$branch" "$flags")
}

# hg status.
function __prompt_hg() {
  __prompt_get_colors
  local summary branch bookmark flags
  summary="$(hg summary 2>/dev/null)"
  [[ $? != 0 ]] && return 1;
  branch="$(echo "$summary" | awk '/branch:/ {print $2}')"
  bookmark="$(echo "$summary" | awk '/bookmarks:/ {print $2}')"
  flags="$(
    echo "$summary" | awk 'BEGIN {r="";a=""} \
      /(modified)/     {r= "+"}\
      /(unknown)/      {a= "?"}\
      END {print r a}'
  )"
  __prompt_vcs_info=("$branch" "$bookmark" "$flags")
}

# SVN info.
function __prompt_svn() {
  __prompt_get_colors
  local info last current
  info="$(svn info . 2> /dev/null)"
  [[ ! "$info" ]] && return 1
  last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
  current="$(echo "$info" | awk '/Revision:/ {print $2}')"
  __prompt_vcs_info=("$last" "$current")
}

# Maintain a per-execution call stack.
__prompt_stack=()
trap '__prompt_stack=("${__prompt_stack[@]}" "$BASH_COMMAND"); __timer_start' DEBUG

# conda environment
# Adapted from
# https://github.com/bryanwweber/dot-files/blob/master/macos.bash_profile#L16
function __prompt_conda() {
    __prompt_get_colors
    if [ ! -z "$CONDA_DEFAULT_ENV" ]; then
        if [ "$CONDA_DEFAULT_ENV" != "base" ]; then
            echo "$c8[$CONDA_DEFAULT_ENV]$c0 "
        fi
    fi
}

function __prompt_command() {
  local i exit_code=$?
  # If the first command in the stack is __prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${__prompt_stack[0]}" == "__prompt_command" ]] && exit_code=0
  __prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  __prompt_get_colors
  # http://twitter.com/cowboy/status/150254030654939137
  PS1="" # PS1="\n" for newline before prompt
  # user@host:
  PS1="$PS1$c1\u@\h:$c0 "
  # conda: [env]
  PS1="$PS1$(__prompt_conda)"
  __prompt_vcs_info=()
  # git: [branch:flags]
  __prompt_git || \
  # hg:  [branch:bookmark:flags]
  __prompt_hg || \
  # svn: [repo:lastchanged]
  __prompt_svn
  # Iterate over all vcs info parts, outputting an escaped var name that will
  # be interpolated automatically. This ensures that malicious branch names
  # can't execute arbitrary commands. For more info, see this PR:
  # https://github.com/cowboy/dotfiles/pull/68
  if [[ "${#__prompt_vcs_info[@]}" != 0 ]]; then
    PS1="$PS1$c5["
    for i in "${!__prompt_vcs_info[@]}"; do
      if [[ "${__prompt_vcs_info[i]}" ]]; then
        [[ $i != 0 ]] && PS1="$PS1:"
        PS1="$PS1\${__prompt_vcs_info[$i]}"
      fi
    done
    PS1="$PS1]$c0"
  fi
  # path
  PS1="$PS1$c2\w$c0"
  PS1="$PS1\n"
  # date: [HH:MM:SS]
  PS1="$PS1$c3$(date +"%H:%M:%S")$c0 "
  # timer: [last: time]
  PS1="$PS1$(__prompt_timer)"
  unset timer
  # exit code: [Error 127]
  PS1="$PS1$(__prompt_exitcode "$exit_code")"
  PS1="$PS1$c4\$$c0 "
}

PROMPT_COMMAND="__prompt_command"
# Share history across windows
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Trim number of directory levels shown
PROMPT_DIRTRIM=3
